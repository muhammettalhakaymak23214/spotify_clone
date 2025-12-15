import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/view/player_view.dart';
import 'package:spotify_clone/view/track_list_view.dart';
import 'package:spotify_clone/view_model/library_view_model.dart';
import 'package:spotify_clone/widgets/custom_app_bar.dart';
import 'package:spotify_clone/widgets/custom_bottom_sheet.dart';
import 'package:spotify_clone/widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_text.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late LibraryViewModel viewModel;
  List<PlayTrackItem> playlist = [];

  @override
  void initState() {
    super.initState();
    viewModel = LibraryViewModel();
    viewModel.fetchAlbum();
    viewModel.fetchArtist();
    viewModel.fetchPlaylist();
    viewModel.fetchPodcast();
  }

  int selectedIndex = 10;

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 110;
    return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: selectedIndex,
        viewModel: viewModel,
        actionButtonsData: [
          AppBarButtonData(
            index: 10,
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            onPressed: () {},
          ),
          AppBarButtonData(
            index: 10,
            icon: FaIcon(FontAwesomeIcons.plus),
            onPressed: () {
              CustomBottomSheet().customShowModalBottom(context);
            },
          ),
        ],
        bottomButtonsData: [
          AppBarButtonData(
            index: 0,
            type: "playlist",
            text: AppStrings.playlist,
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
            type: "podcasts",
            text: AppStrings.podcasts,
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
            type: "user",
            text: AppStrings.albums,
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
            type: "artists",
            text: AppStrings.artists,
            onPressed: () {
              if (!viewModel.isLoadingArtist.value) {
                selectedIndex = 3;
                setState(() {});
                viewModel.items.clear();
                viewModel.fetchArtist();
              }
            },
          ),

          //burayı düzletmem lazım
          AppBarButtonData(
            type: "indirilenler",
            text: "İndirilenler",
            index: 4,
            onPressed: () {
              selectedIndex = 4;
              setState(() {});
              viewModel.loadSongs();
            },
          ),
        ],
        leading: Image.asset(AppStrings.profileImagePath),
        onTap: () => Scaffold.of(context).openDrawer(),
        title: SizedBox(
          child: Text(
            AppStrings.library,
            style: TextStyle(color: AppColors.white),
          ),
        ),
        appBarHeight: appBarHeight,
      ),

      body: Observer(
        builder: (context) {
          return !viewModel.isDownloaded.value
              ? Observer(
                  builder: (_) {
                    if (viewModel.isLoadingAlbum.value &&
                        viewModel.isLoadingArtist.value &&
                        viewModel.isLoadingPlaylist.value &&
                        viewModel.isLoadingPodcast.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (viewModel.items.isEmpty) {
                      return Center(child: Text("Sonuç bulunamadi"));
                    }
                    return ListView.builder(
                      itemCount: viewModel.items.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.items[index];
                        final imageUrl =
                            item.imagesUrl != null && item.imagesUrl!.isNotEmpty
                            ? item.imagesUrl
                            : null;
                        final subtitle = item.subTitle ?? "";

                        return ListTile(
                          leading: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey,
                                  child: Icon(Icons.music_note),
                                ),
                          title: Text(item.title ?? "No Title"),
                          subtitle: Text(subtitle),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TrackListView(
                                  id: item.id ?? "",
                                  type: item.type ?? MediaType.show,
                                  title: item.title ?? "",
                                  imageUrl: item.imagesUrl,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              : Observer(
                  builder: (context) {
                    return viewModel.songs.isEmpty
                        ? Center(
                            child: CustomText(
                              data: AppStrings.emtyDownloadedList,
                              color: AppColors.grey,
                              textSize: TextSize.large,
                            ),
                          )
                        : ListView.builder(
                            itemCount: viewModel.songs.length,
                            itemBuilder: (context, index) {
                              final song = viewModel.songs[index];
                              return ListTile(
                                onTap: () async {
                                  int i = 0;
                                  playlist.clear();
                                  while (i <= viewModel.songs.length - 1) {
                                    playlist.add(
                                      PlayTrackItem(
                                        previewUrl: "",
                                        id: viewModel.songs[i]['id'],
                                        trackName: viewModel.songs[i]['title'],
                                        artistName:
                                            viewModel.songs[i]['artist'],
                                        albumImage: "",
                                        albumImagePath: viewModel
                                            .songs[i]['albumCoverPath'],
                                        previewPath:
                                            viewModel.songs[i]['filePath'],
                                      ),
                                      /*
                                      await viewModel.getTrackWithPreview(
                                        viewModel.songs[i],
                                      ),*/
                                    );
                                    i++;
                                  }

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlayerView(
                                        playlist: playlist,
                                        title: "İndirilenler",
                                        type: MediaType.downloaded,
                                        currentIndex: index,
                                      ),
                                    ),
                                  );
                                  await viewModel.loadSongs();
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                  child:
                                      File(song['albumCoverPath']).existsSync()
                                      ? Image.file(
                                          File(song['albumCoverPath'] ?? ""),
                                          fit: BoxFit.cover,
                                        )
                                      : const Text("Resim bulunamadı"),
                                ),
                                title: CustomText(
                                  data: song['title'],
                                  textSize: TextSize.medium,
                                ),
                                subtitle: CustomText(
                                  data: song['artist'],
                                  textSize: TextSize.small,
                                  color: AppColors.grey,
                                ),
                                trailing: IconButton(
                                  icon: CustomIcon(
                                    iconData: Icons.delete,
                                    color: AppColors.white,
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
        },
      ),
    );
  }
}
