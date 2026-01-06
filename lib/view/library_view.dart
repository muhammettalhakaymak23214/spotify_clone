import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/services/service_locator.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/view/main_tab_view.dart';
import 'package:spotify_clone/view_model/library_view_model.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_app_bar.dart';
import 'package:spotify_clone/product/widgets/bottom_sheets/create_bottom_sheet.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final player = getIt<PlayerStore>();
  late LibraryViewModel viewModel;
  List<PlayTrackItem> playlist = [];
  int selectedIndex = 10;

  @override
  void initState() {
    super.initState();
    viewModel = LibraryViewModel();
    viewModel.fetchAlbum();
    viewModel.fetchArtist();
    viewModel.fetchPlaylist();
    viewModel.fetchPodcast();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: selectedIndex,
        viewModel: viewModel,
        actionButtonsData: [
          AppBarButtonData(
            index: 10,
            icon: const AppIcon(
              icon: FontAwesomeIcons.magnifyingGlass,
              size: AppIconSize.small,
            ),
            onPressed: () {},
          ),
          AppBarButtonData(
            index: 10,
            icon: const AppIcon(
              icon: FontAwesomeIcons.plus,
              size: AppIconSize.small,
            ),
            onPressed: () {
              CreateBottomSheet().customShowModalBottom(context);
            },
          ),
        ],
        bottomButtonsData: [
          AppBarButtonData(
            index: 0,
            type: _Constants.typePlaylist,
            text: l10n.filterPlaylists,
            onPressed: () {
              if (!viewModel.isLoadingPlaylist.value) {
                selectedIndex = 0;
                setState(() {});
                viewModel.items.clear();
                viewModel.fetchPlaylist();
              }
            },
          ),
          AppBarButtonData(
            index: 1,
            type: _Constants.typePodcasts,
            text: l10n.filterPodcasts,
            onPressed: () {
              if (!viewModel.isLoadingPodcast.value) {
                selectedIndex = 1;
                setState(() {});
                viewModel.items.clear();
                viewModel.fetchPodcast();
              }
            },
          ),
          AppBarButtonData(
            index: 2,
            type: _Constants.typeUser,
            text: l10n.filterAlbums,
            onPressed: () {
              if (!viewModel.isLoadingAlbum.value) {
                selectedIndex = 2;
                setState(() {});
                viewModel.items.clear();
                viewModel.fetchAlbum();
              }
            },
          ),
          AppBarButtonData(
            index: 3,
            type: _Constants.typeArtists,
            text: l10n.filterArtists,
            onPressed: () {
              if (!viewModel.isLoadingArtist.value) {
                selectedIndex = 3;
                setState(() {});
                viewModel.items.clear();
                viewModel.fetchArtist();
              }
            },
          ),
          //---------------------
          AppBarButtonData(
            type: _Constants.typeDownloads,
            text: l10n.filterDownloads,
            index: 4,
            onPressed: () {
              selectedIndex = 4;
              setState(() {});
              viewModel.loadSongs();
            },
          ),
        ],
        leading: Image.asset(_Constants.profileImagePath),
        onTap: () => Scaffold.of(context).openDrawer(),
        title: SizedBox(
          child: AppText(
            text: l10n.bottomNavigatorLibrary,
            style: AppTextStyle.titleM,
          ),
        ),
        appBarHeight: _Constants.appBarHeight,
      ),
      body: Observer(
        builder: (context) {
          return !viewModel.isDownloaded.value
              ? _buildRemoteList()
              : _buildDownloadedList();
        },
      ),
    );
  }

  Widget _buildRemoteList() {
    final l10n = AppLocalizations.of(context)!;
    return Observer(
      builder: (_) {
        if (viewModel.isLoadingAlbum.value &&
            viewModel.isLoadingArtist.value &&
            viewModel.isLoadingPlaylist.value &&
            viewModel.isLoadingPodcast.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.items.isEmpty) {
          return Center(
            child: AppText(
              text: l10n.libraryViewEmtyDownloadedList,
              style: AppTextStyle.bodyM,
            ),
          );
        }
        return ListView.builder(
          itemCount: viewModel.items.length,
          itemBuilder: (context, index) {
            final item = viewModel.items[index];
            final imageUrl =
                item.imagesUrl != null && item.imagesUrl!.isNotEmpty
                ? item.imagesUrl
                : null;

            return ListTile(
              leading: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: _Constants.imageSize,
                      height: _Constants.imageSize,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: _Constants.imageSize,
                      height: _Constants.imageSize,
                      color: _Constants.greyColor,
                      child: const AppIcon(icon: Icons.music_note),
                    ),
              title: AppText(
                text: item.title ?? "",
                style: AppTextStyle.bodyM,
                fontWeight: FontWeight.bold,
              ),
              subtitle: AppText(
                text: item.subTitle ?? "",
                style: AppTextStyle.bodyS,
                color: _Constants.greyColor,
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainTabView(
                      initialIndex: 5,
                      id: item.id ?? "",
                      title: item.title ?? "",
                      type: item.type ?? MediaType.show,
                      imageUrl: item.imagesUrl ?? "",
                    ),
                  ),
                  (route) => false,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDownloadedList() {
    final l10n = AppLocalizations.of(context)!;
    return Observer(
      builder: (context) {
        return viewModel.songs.isEmpty
            ? Center(
                child: AppText(
                  text: l10n.libraryViewEmtyDownloadedList,
                  color: _Constants.greyColor,
                  style: AppTextStyle.titleS,
                ),
              )
            : ListView.builder(
                itemCount: viewModel.songs.length,
                itemBuilder: (context, index) {
                  final song = viewModel.songs[index];
                  return ListTile(
                    onTap: () async {
                      playlist.clear();
                      for (var s in viewModel.songs) {
                        playlist.add(
                          PlayTrackItem(
                            previewUrl: "",
                            id: s['id'],
                            trackName: s['title'],
                            artistName: s['artist'],
                            albumImage: "",
                            albumImagePath: s['albumCoverPath'],
                            previewPath: s['filePath'],
                          ),
                        );
                      }
                      player.playFromPlaylist(
                        list: playlist,
                        index: index,
                        type: MediaType.downloaded,
                        id: "0",
                      );
                      await viewModel.loadSongs();
                    },
                    leading: ClipRRect(
                      borderRadius: _Constants.imageBorderRadius,
                      child: SizedBox(
                        width: _Constants.imageSize,
                        height: _Constants.imageSize,
                        child: File(song['albumCoverPath']).existsSync()
                            ? Image.file(
                                File(song['albumCoverPath'] ?? ""),
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: AppText(
                                  text: "",
                                  style: AppTextStyle.bodyS,
                                ),
                              ),
                      ),
                    ),
                    title: AppText(
                      text: song['title'],
                      style: AppTextStyle.bodyM,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle: AppText(
                      text: song['artist'],
                      style: AppTextStyle.bodyS,
                      color: _Constants.greyColor,
                    ),
                    trailing: IconButton(
                      icon: AppIcon(
                        icon: Icons.delete,
                      ),
                      onPressed: () {
                        viewModel.delete(song['id']);
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}

abstract final class _Constants {
  //Path
  static String get profileImagePath => AppStrings.profileImagePath;
  // Sizes
  static double get appBarHeight => 110.h;
  static double get imageSize => 50.w;
  static BorderRadius get imageBorderRadius => BorderRadius.circular(10.r);
  // Colors
  static Color get greyColor => AppColors.grey;
  // Strings / Types
  static const String typePlaylist = "playlist";
  static const String typePodcasts = "podcasts";
  static const String typeUser = "user";
  static const String typeArtists = "artists";
  static const String typeDownloads = "indirilenler";
}
