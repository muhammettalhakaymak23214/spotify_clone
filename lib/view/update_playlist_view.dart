import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/view/main_tab_view.dart';
import 'package:spotify_clone/view/playlist_add_tracks_search_view.dart';
import 'package:spotify_clone/view/track_list_view.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';
import 'package:spotify_clone/widgets/bottom_sheet/update_playlist_bottom_sheet.dart';

class UpdatePlaylistView extends StatefulWidget {
  const UpdatePlaylistView({super.key, required this.playlistId});

  final String playlistId;

  @override
  State<UpdatePlaylistView> createState() => _UpdatePlaylistViewState();
}

class _UpdatePlaylistViewState extends State<UpdatePlaylistView> {
  late UpdatePlaylistViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = UpdatePlaylistViewModel();
    getUserTopTracks();
    debugPrint(widget.playlistId);
    getPlaylistDetail();
  }

  void getUserTopTracks() async {
    await viewModel.getUserTopTracks(limit: 5, consumedCount: 0);
  }

  void getPlaylistDetail() async {
    await viewModel.getPlaylistDetail(playlistId: widget.playlistId);
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.tracks.clear();
    viewModel.offset = 0;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: _Constants.cardColor,
        leading: IconButton(
          icon: const AppIcon(icon: Icons.arrow_back),
          onPressed: () {
            _onBackPressed(context);
          },
        ),
        centerTitle: true,
        title: Observer(
          builder: (context) {
            final String playlistName = viewModel.playlistName.value;
            return SizedBox(
              width: _Constants.w200,
              child: _AppBarTitleSection(playlistName: playlistName),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: _Constants.topDecoration,
              height: _Constants.topContainerHeight,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: _Constants.padding20h,
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Observer(
                            builder: (context) {
                              final String playlistCoverImage =
                                  viewModel.playlistCoverImage.value;
                              return _PlaylistCoverImageSection(
                                playlistCoverImage: playlistCoverImage,
                              );
                            },
                          ),
                          SizedBox(
                            width: screenWidth - (_Constants.w210),
                            height: _Constants.h150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(height: _Constants.h10),
                                SizedBox(
                                //  width: _Constants.w150,
                                  child: Observer(
                                    builder: (context) {
                                      final String playlistName =
                                          viewModel.playlistName.value;
                                      return AppText(
                                        text: playlistName,
                                        style: AppTextStyle.titleM,
                                      );
                                    },
                                  ),
                                ),
                                _ProfileRowSection(
                                  profilePhotoPath: _Constants.profilePhotoImagePath,
                                ),
                                _ChangeButton(
                                  widget: widget,
                                  viewModel: viewModel,
                                ),
                                SizedBox(height: _Constants.h10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _Constants.h10),
                    child: SizedBox(
                      height: _Constants.h50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            padding: _Constants.paddingStart10,
                            onPressed: () {},
                            icon: AppIcon(
                              icon: Icons.public_outlined,
                              color: _Constants.greyColor,
                              size: AppIconSize.small,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: AppIcon(
                              icon: Icons.more_vert_outlined,
                              size: AppIconSize.small,
                              color: _Constants.greyColor,
                            ),
                          ),
                          Observer(
                            builder: (context) {
                              return AnimatedSwitcher(
                                duration: _Constants.duration350,
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                transitionBuilder: (child, animation) {
                                  final inAnimation = Tween<Offset>(
                                    begin: const Offset(1.5, 0),
                                    end: Offset.zero,
                                  ).animate(animation);

                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: inAnimation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: viewModel.playlistInTracks.isNotEmpty
                                    ? _ListNotEmptySection(
                                        key: const ValueKey('visible'),
                                        widget: widget,
                                        viewModel: viewModel,
                                      )
                                    : const SizedBox(key: ValueKey('hidden')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: _Constants.h5),
            Observer(
              builder: (context) {
                return AnimatedSwitcher(
                  duration: _Constants.duration350,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final inAnimation = Tween<Offset>(
                      begin: const Offset(-3, 0),
                      end: Offset.zero,
                    ).animate(animation);

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: inAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: viewModel.playlistInTracks.isEmpty
                      ? SizedBox(
                          child: _Deneme(
                            screenWidth: screenWidth,
                            widget: widget,
                            viewModel: viewModel,
                          ),
                        )
                      : _PlaylistAddedTracks(
                          viewModel: viewModel,
                          widget: widget,
                        ),
                );
              },
            ),
            SizedBox(
              height: _Constants.h650,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Observer(
                    builder: (context) {
                      final double topPadding =
                          viewModel.playlistInTracks.isEmpty ? 20 : 0;
                      return AnimatedPadding(
                        duration: _Constants.duration300,
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.only(
                          top: topPadding,
                          left: 20,
                          bottom: 10,
                          right: 20,
                        ),
                        child: const _RecommendedSongsTitleSection(),
                      );
                    },
                  ),
                  SizedBox(
                    height: _Constants.h370,
                    width: double.infinity,
                    child: Observer(
                      builder: (context) {
                        return viewModel.tracks.isEmpty
                            ? const _NullDataRecommendedSongs()
                            : _UserTopTracksListViewBuilder(
                                viewModel: viewModel,
                                widget: widget,
                              );
                      },
                    ),
                  ),
                  _RefreshButton(
                    screenWidth: screenWidth,
                    viewModel: viewModel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _onBackPressed(BuildContext context) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainTabView(initialIndex: 0)),
      (route) => false,
    );
  }
}

class _Deneme extends StatelessWidget {
  const _Deneme({
    super.key,
    required this.screenWidth,
    required this.widget,
    required this.viewModel,
  });

  final double screenWidth;
  final UpdatePlaylistView widget;
  final UpdatePlaylistViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton.icon(
      onPressed: () async {
        if (viewModel.isAddingTrack == false) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PlaylistAddTracksSearchView(playlistId: widget.playlistId),
            ),
          ).then((result) {
            if (result != null) {
              viewModel.count = result;
            }
          });
          await viewModel.getPlaylistDetail(playlistId: widget.playlistId);
          await viewModel.getPlaylistTracks(playlistId: widget.playlistId);
          int sayac = 0;
          while (sayac < viewModel.count) {
            var index1 = viewModel.playlistInTracks.length;
            index1 = index1 - (viewModel.count - sayac);
            viewModel.listKey.currentState?.insertItem(index1);
            sayac++;
          }
        }
      },
      icon: AppIcon(icon: Icons.add, color: _Constants.blackColor),
      label: AppText(
        text: l10n.updatePlaylistViewThisAddPlaylist,
        color: _Constants.blackColor,
        style: AppTextStyle.titleS,
      ),
    );
  }
}

class _ListNotEmptySection extends StatelessWidget {
  const _ListNotEmptySection({
    super.key,
    required this.widget,
    required this.viewModel,
  });

  final UpdatePlaylistView widget;
  final UpdatePlaylistViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            height: _Constants.h30,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (viewModel.isAddingTrack == false) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaylistAddTracksSearchView(
                        playlistId: widget.playlistId,
                      ),
                    ),
                  ).then((result) {
                    if (result != null) {
                      viewModel.count = result;
                    }
                  });
                  await viewModel.getPlaylistDetail(
                    playlistId: widget.playlistId,
                  );
                  await viewModel.getPlaylistTracks(
                    playlistId: widget.playlistId,
                  );
                  int sayac = 0;
                  while (sayac < viewModel.count) {
                    var index1 = viewModel.playlistInTracks.length;
                    index1 = index1 - (viewModel.count - sayac);
                    viewModel.listKey.currentState?.insertItem(index1);
                    sayac++;
                  }
                }
              },
              icon: AppIcon(icon: Icons.add, color: _Constants.blackColor, size: AppIconSize.small),
              label: AppText(
                text: l10n.updatePlaylistViewAdd,
                color: _Constants.blackColor,
                style: AppTextStyle.titleS,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: _Constants.w10),
            child: SizedBox(
              height: _Constants.h30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _Constants.greenColor,
                ),
                onPressed: () {
                  if (viewModel.isAddingTrack == false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrackListView(
                          id: widget.playlistId,
                          title: viewModel.playlistName.value,
                          type: MediaType.playlist,
                          imageUrl: viewModel.playlistCoverImage.value,
                        ),
                      ),
                    );
                  }
                },
                child: AppText(text: l10n.updatePlaylistViewGoPlaylist, style: AppTextStyle.titleS),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaylistAddedTracks extends StatefulWidget {
  const _PlaylistAddedTracks({required this.viewModel, required this.widget});

  final UpdatePlaylistViewModel viewModel;
  final UpdatePlaylistView widget;

  @override
  State<_PlaylistAddedTracks> createState() => _PlaylistAddedTracksState();
}

class _PlaylistAddedTracksState extends State<_PlaylistAddedTracks> {
  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: widget.viewModel.listKey,
      initialItemCount: widget.viewModel.playlistInTracks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final track = widget.viewModel.playlistInTracks[index];
        return SizeTransition(
          sizeFactor: animation,
          child: ListTile(
            title: AppText(
              text: track.trackName ?? "",
              style: AppTextStyle.titleM
            ),
            subtitle: AppText(
              text: track.artistName ?? "",
              style:AppTextStyle.titleS,
              color: _Constants.greyColor,
            ),
            leading: ClipRRect(
              borderRadius: _Constants.radius10,
              child: Image.network(track.image ?? ""),
            ),
            trailing: IconButton(
              onPressed: () async {
                if (widget.viewModel.isAddingTrack == false) {
                  widget.viewModel.isAddingTrack = true;
                  if (!widget.viewModel.isPressedRemove) {
                    widget.viewModel.isPressedRemove = true;
                    final removedTrack =
                        widget.viewModel.playlistInTracks[index];
                    widget.viewModel.playlistInTracks.removeAt(index);
                    widget.viewModel.listKey.currentState?.removeItem(
                      index,
                      (context, animation) => SizeTransition(
                        sizeFactor: animation,
                        child: ListTile(
                          title: AppText(
                            text: removedTrack.trackName ?? "",
                            style:AppTextStyle.titleM,
                          ),
                          subtitle: AppText(
                            text: removedTrack.artistName ?? "",
                            style:AppTextStyle.titleS,
                            color: _Constants.greyColor,
                          ),
                        ),
                      ),
                    );
                    await widget.viewModel.deleteTracksToPlaylist(
                      playlistId: widget.widget.playlistId,
                      trackUri: "spotify:track:${removedTrack.id}",
                    );
                    await widget.viewModel.getPlaylistTracks(
                      playlistId: widget.widget.playlistId,
                    );
                    await widget.viewModel.getPlaylistDetail(
                      playlistId: widget.widget.playlistId,
                    );
                    widget.viewModel.isPressedRemove = false;
                  }
                  widget.viewModel.isAddingTrack = false;
                }
              },
              icon: AppIcon(
                icon: Icons.remove,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.screenWidth, required this.viewModel});

  final double screenWidth;
  final UpdatePlaylistViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: screenWidth / 2 - (50)),
      child: ElevatedButton(
        onPressed: () async {
          if (viewModel.isAddingTrack == false) {
            viewModel.offset = viewModel.offset + 5;
            viewModel.tracks.clear();
            await viewModel.getUserTopTracks(
              consumedCount: viewModel.offset,
              limit: 5,
            );
          }
        },
        child: AppText(
          text: l10n.updatePlaylistViewRefresh,
         style:AppTextStyle.titleM,
          color: _Constants.blackColor,

        ),
      ),
    );
  }
}

class _UserTopTracksListViewBuilder extends StatelessWidget {
  const _UserTopTracksListViewBuilder({
    required this.viewModel,
    required this.widget,
  });

  final UpdatePlaylistViewModel viewModel;
  final UpdatePlaylistView widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.tracks.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final track = viewModel.tracks[index];
        return ListTile(
          title: AppText(
            text: track.trackName ?? "",
           style:AppTextStyle.titleM,
          ),
          subtitle: AppText(
            text: track.artistName ?? "",
           style:AppTextStyle.titleS,

            color: _Constants.greyColor,
          ),
          leading: ClipRRect(
            borderRadius: _Constants.radius10,
            child: Image.network(track.image ?? ""),
          ),
          trailing: IconButton(
            onPressed: () async {
              if (viewModel.isAddingTrack == false) {
                viewModel.isAddingTrack = true;
                if (!viewModel.isPressedAdd) {
                  final _index1 = viewModel.playlistInTracks.length;
                  viewModel.isPressedAdd = true;
                  await viewModel.getPlaylistTracks(
                    playlistId: widget.playlistId,
                  );
                  final String? id = track.id;
                  final bool any = viewModel.playlistInTracks.any(
                    (track) => track.id == id,
                  );
                  if (!any) {
                    await viewModel.addTracksToPlaylist(
                      playlistId: widget.playlistId,
                      trackUris: ["spotify:track:$id"],
                    );
                    viewModel.tracks.removeAt(index);
                    viewModel.offset++;
                    await viewModel.getUserTopTracks(
                      consumedCount: viewModel.offset,
                      limit: 1,
                    );
                    await viewModel.getPlaylistDetail(
                      playlistId: widget.playlistId,
                    );
                    await viewModel.getPlaylistTracks(
                      playlistId: widget.playlistId,
                    );
                    viewModel.listKey.currentState?.insertItem(_index1);
                  }
                  viewModel.isPressedAdd = false;
                }
                viewModel.isAddingTrack = false;
              }
            },
            icon: AppIcon(icon: Icons.add, //iconSize: IconSize.large
            
            ),
          ),
        );
      },
    );
  }
}

class _NullDataRecommendedSongs extends StatelessWidget {
  const _NullDataRecommendedSongs();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: AppText(
        text: l10n.updatePlaylistViewRefreshError,
        color: _Constants.greyColor,
       // textSize: TextSize.large,
      ),
    );
  }
}

class _RecommendedSongsTitleSection extends StatelessWidget {
  const _RecommendedSongsTitleSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppText(
      text: l10n.updatePlaylistViewRecommendedSongs,
      style: AppTextStyle.titleL,
    );
  }
}

class _ChangeButton extends StatelessWidget {
  const _ChangeButton({required this.widget, required this.viewModel});

  final UpdatePlaylistView widget;
  final UpdatePlaylistViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: _Constants.backgroundColor),
      onPressed: () {
        if (viewModel.isAddingTrack == false) {
          UpdatePlaylistBottomSheet().updatePlaylistBottomSheet(
            context,
            playlistId: widget.playlistId,
            viewModel: viewModel,
          );
        }
      },
      child: AppText(text: l10n.updatePlaylistViewChange),
    );
  }
}

class _ProfileRowSection extends StatelessWidget {
  const _ProfileRowSection({required String profilePhotoPath})
      : _profilePhotoPath = profilePhotoPath;

  final String _profilePhotoPath;
  final String userName = "muhammet";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: _Constants.w50,
          height: _Constants.h50,
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Positioned(
                right: _Constants.w10,
                child: Container(
                  width: _Constants.w24,
                  height: _Constants.h24,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(_profilePhotoPath),
                ),
              ),
              Positioned(
                left: 0,
                child: Container(
                  width: _Constants.w24,
                  height: _Constants.h24,
                  decoration: BoxDecoration(
                    color: _Constants.cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: AppIcon(icon: Icons.add, size: AppIconSize.small),
                ),
              ),
            ],
          ),
        ),
        AppText(
          text: userName,
          style: AppTextStyle.bodyS,
          color: Colors.white,
        ),
      ],
    );
  }
}

class _PlaylistCoverImageSection extends StatelessWidget {
  const _PlaylistCoverImageSection({required this.playlistCoverImage});

  final String playlistCoverImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: _Constants.w20),
      child: AnimatedSwitcher(
        duration: _Constants.duration1200,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: Container(
          key: ValueKey(playlistCoverImage),
          decoration: BoxDecoration(
            color: _Constants.greyColor,
            borderRadius: _Constants.radius10,
          ),
          height: _Constants.w148,
          width: _Constants.w148,
          child: playlistCoverImage.isEmpty
              ? AppIcon(
                  icon: Icons.music_note,
                  size: AppIconSize.huge,
                  color: _Constants.planColor,
                )
              : ClipRRect(
                  borderRadius: _Constants.radius10,
                  child: Image.network(playlistCoverImage, fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }
}

class _AppBarTitleSection extends StatelessWidget {
  const _AppBarTitleSection({required this.playlistName});

  final String playlistName;

  @override
  Widget build(BuildContext context) {
    return AppText(
        textAlign: TextAlign.center,
        text: playlistName,
        overflow: TextOverflow.fade,
        style: AppTextStyle.titleL);
  }
}

abstract final class _Constants {
  //Paths
  static String get profilePhotoImagePath => AppStrings.profilePhotoImage;

  //Sizes
  static double get topContainerHeight => 250.h;
  static double get h150 => 150.h;
  static double get h50 => 50.h;
  static double get h30 => 30.h;
  static double get h10 => 10.h;
  static double get h5 => 5.h;
  static double get h650 => 650.h;
  static double get h370 => 370.h;
  static double get h24 => 24.h;

  static double get w200 => 200.w;
  static double get w210 => 210.w;
  static double get w150 => 150.w;
  static double get w24 => 24.w;
  static double get w50 => 50.w;
  static double get w10 => 10.w;
  static double get w20 => 20.w;
  static double get w148 => 148.w;

  //Padding
  static EdgeInsetsGeometry get padding20h => EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsetsDirectional get paddingStart10 => EdgeInsetsDirectional.only(start: 10.w);

  //Colors
  static Color get cardColor => AppColors.cardBackground;
  static Color get backgroundColor => AppColors.background;
  static Color get greyColor => AppColors.grey;
  static Color get blackColor => AppColors.black;
  static Color get greenColor => AppColors.green;
  static Color get planColor => AppColors.cardBackground;

  //Decoration
  static BoxDecoration get topDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.cardBackground, AppColors.background],
        ),
      );

  //Radius
  static BorderRadius get radius10 => BorderRadius.circular(10.r);

  //Durations
  static Duration get duration350 => const Duration(milliseconds: 350);
  static Duration get duration300 => const Duration(milliseconds: 300);
  static Duration get duration1200 => const Duration(milliseconds: 1200);
}