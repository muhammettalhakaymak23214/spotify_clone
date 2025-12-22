import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/view/main_tab_view.dart';
import 'package:spotify_clone/view/playlist_add_tracks_search_view.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';
import 'package:spotify_clone/widgets/bottom_sheet/update_playlist_bottom_sheet.dart';

class UpdatePlaylistView extends StatefulWidget {
  const UpdatePlaylistView({
    super.key,
    required this.playlistName,
    required this.playlistId,
  });

  final String playlistName;
  final String playlistId;

  @override
  State<UpdatePlaylistView> createState() => _UpdatePlaylistViewState();
}

class _UpdatePlaylistViewState extends State<UpdatePlaylistView> {
  //Variables
  final String _profilePhotoPath = "assets/png/profile_photo.png";
  late UpdatePlaylistViewModel viewModel;
  final double appBarTitleFontSize = 24;
  final double topContainerHeight = 250;
  final double height1 = 150;
  final EdgeInsetsGeometry padding1 = EdgeInsets.symmetric(horizontal: 20);

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
    //MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    //BoxDecoration
    const boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.planSectionColor, AppColors.darkToneInk],
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.planSectionColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _onBackPressed(context);
          },
        ),
        centerTitle: true,
        title: _AppBarTitleSection(
          widget: widget,
          appBarTitleFontSize: appBarTitleFontSize,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: boxDecoration,
              height: topContainerHeight,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: padding1,
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
                            width: screenWidth - (210),
                            height: height1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 150,
                                  child: Observer(
                                    builder: (context) {
                                      final String playlistName =
                                          viewModel.playlistName.value;
                                      return CustomText(
                                        data: playlistName,
                                        textSize: TextSize.large,
                                        textWeight: TextWeight.bold,
                                      );
                                    },
                                  ),
                                ),
                                _ProfileRowSection(
                                  profilePhotoPath: _profilePhotoPath,
                                ),
                                _ChangeButton(
                                  widget: widget,
                                  viewModel: viewModel,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Observer(
                    builder: (context) {
                      return viewModel.playlistInTracks.isEmpty
                          ? IconButton(
                              padding: EdgeInsets.only(left: 20),
                              onPressed: () {},
                              icon: CustomIcon(
                                iconData: Icons.public_outlined,
                                color: AppColors.grey,
                                iconSize: IconSize.medium,
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  Observer(
                    builder: (context) {
                      return viewModel.playlistInTracks.isEmpty
                          ? IconButton(
                              padding: EdgeInsets.only(left: 20),
                              onPressed: () {},
                              icon: CustomIcon(
                                iconData: Icons.more_vert_outlined,
                                color: AppColors.grey,
                                iconSize: IconSize.medium,
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  Observer(
                    builder: (context) {
                      return viewModel.playlistInTracks.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                //  color: AppColors.green,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.only(left: 20),
                                      onPressed: () {},
                                      icon: CustomIcon(
                                        iconData: Icons.public_outlined,
                                        color: AppColors.grey,
                                        iconSize: IconSize.medium,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: CustomIcon(
                                        iconData: Icons.more_vert_outlined,
                                        color: AppColors.grey,
                                        iconSize: IconSize.medium,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          //PlaylistAddTracksSearchView
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PlaylistAddTracksSearchView(
                                                    playlistId:
                                                        widget.playlistId,
                                                  ),
                                            ),
                                          );
                                          await viewModel.getPlaylistDetail(
                                            playlistId: widget.playlistId,
                                          );
                                          await viewModel.getPlaylistTracks(
                                            playlistId: widget.playlistId,
                                          );
                                        },
                                        icon: CustomIcon(
                                          iconData: Icons.add,
                                          color: AppColors.black,
                                        ),
                                        label: CustomText(
                                          data: "Ekle",
                                          color: AppColors.black,
                                          textSize: TextSize.small,
                                          textWeight: TextWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Observer(
              builder: (context) {
                return viewModel.playlistInTracks.isEmpty
                    ? SizedBox.shrink()
                    : _PlaylistAddedTracks(
                        viewModel: viewModel,
                        widget: widget,
                      );
              },
            ),
            SizedBox(
              height: 600,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Observer(
                    builder: (context) {
                      return viewModel.playlistInTracks.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth / 2 - (100),
                              ),
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    //PlaylistAddTracksSearchView
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PlaylistAddTracksSearchView(
                                              playlistId: widget.playlistId,
                                            ),
                                      ),
                                    );
                                    await viewModel.getPlaylistDetail(
                                      playlistId: widget.playlistId,
                                    );
                                    await viewModel.getPlaylistTracks(
                                      playlistId: widget.playlistId,
                                    );
                                  },
                                  icon: CustomIcon(
                                    iconData: Icons.add,
                                    color: AppColors.black,
                                  ),
                                  label: CustomText(
                                    data: AppStrings.thisPlaylistAdd,
                                    color: AppColors.black,
                                    textSize: TextSize.small,
                                    textWeight: TextWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  Observer(
                    builder: (context) {
                      final double topPadding =
                          viewModel.playlistInTracks.isEmpty ? 20 : 0;
                      return _RecommendedSongsTitleSection(
                        topPadding: topPadding,
                      );
                    },
                  ),
                  SizedBox(
                    height: 370,
                    width: double.infinity,
                    child: Observer(
                      builder: (context) {
                        return viewModel.tracks.isEmpty
                            ? _NullDataRecommendedSongs()
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

class _PlaylistAddedTracks extends StatelessWidget {
  const _PlaylistAddedTracks({required this.viewModel, required this.widget});

  final UpdatePlaylistViewModel viewModel;
  final UpdatePlaylistView widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.playlistInTracks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final track = viewModel.playlistInTracks[index];
        return ListTile(
          title: CustomText(
            data: track.trackName,
            textSize: TextSize.medium,
            textWeight: TextWeight.bold,
          ),
          subtitle: CustomText(
            data: track.artistName,
            textSize: TextSize.small,
            textWeight: TextWeight.normal,
            color: AppColors.grey,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: Image.network(track.image ?? ""),
          ),
          trailing: IconButton(
            onPressed: () async {
              if (!viewModel.isPressedRemove) {
                viewModel.isPressedRemove = true;
                List<String> trackUris = [];
                trackUris.add("spotify:track:${track.id}");
                await viewModel.deleteTracksToPlaylist(
                  playlistId: widget.playlistId,
                  trackUri: "spotify:track:${track.id}",
                );
                await viewModel.getPlaylistTracks(
                  playlistId: widget.playlistId,
                );
                await viewModel.getPlaylistDetail(
                  playlistId: widget.playlistId,
                );
                viewModel.isPressedRemove = false;
              }
            },
            icon: CustomIcon(iconData: Icons.remove, iconSize: IconSize.large),
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
    return Padding(
      padding: EdgeInsets.only(left: screenWidth / 2 - (50)),
      child: SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () async {
            viewModel.offset = viewModel.offset + 5;
            viewModel.tracks.clear();
            await viewModel.getUserTopTracks(
              consumedCount: viewModel.offset,
              limit: 5,
            );
          },
          child: CustomText(
            data: AppStrings.refresh,
            color: AppColors.black,
            textSize: TextSize.medium,
            textWeight: TextWeight.bold,
          ),
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
          title: CustomText(
            data: track.trackName,
            textSize: TextSize.medium,
            textWeight: TextWeight.bold,
          ),
          subtitle: CustomText(
            data: track.artistName,
            textSize: TextSize.small,
            textWeight: TextWeight.normal,
            color: AppColors.grey,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: Image.network(track.image ?? ""),
          ),
          trailing: IconButton(
            onPressed: () async {
              if (!viewModel.isPressedAdd) {
                viewModel.isPressedAdd = true;
                List<String> trackUris = [];
                trackUris.add("spotify:track:${track.id}");

                await viewModel.addTracksToPlaylist(
                  playlistId: widget.playlistId,
                  trackUris: trackUris,
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
                viewModel.isPressedAdd = false;
              }
            },
            icon: CustomIcon(iconData: Icons.add, iconSize: IconSize.large),
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
    return Center(
      child: CustomText(
        data: AppStrings.nullDataRecommendedSongs,
        color: AppColors.grey,
        textSize: TextSize.large,
      ),
    );
  }
}

class _RecommendedSongsTitleSection extends StatelessWidget {
  const _RecommendedSongsTitleSection({required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: topPadding, bottom: 20),
      child: CustomText(
        data: AppStrings.recommendedSongs,
        textSize: TextSize.extraLarge,
        textWeight: TextWeight.bold,
      ),
    );
  }
}

class _ChangeButton extends StatelessWidget {
  const _ChangeButton({required this.widget, required this.viewModel});

  final UpdatePlaylistView widget;
  final UpdatePlaylistViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkToneInk),
      onPressed: () {
        UpdatePlaylistBottomSheet().updatePlaylistBottomSheet(
          context,
          playlistId: widget.playlistId,
          viewModel: viewModel,
        );
      },
      child: CustomText(data: AppStrings.change, textWeight: TextWeight.bold),
    );
  }
}

class _ProfileRowSection extends StatelessWidget {
  const _ProfileRowSection({required String profilePhotoPath})
    : _profilePhotoPath = profilePhotoPath;

  final String _profilePhotoPath;
  final String userName = "muhammet";
  final double containerSize = 24;
  final double sizeBoxSize = 50;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: sizeBoxSize,
          height: sizeBoxSize,
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Positioned(
                right: 10,
                child: Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(_profilePhotoPath),
                ),
              ),
              Positioned(
                left: 0,
                child: Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    color: AppColors.blackPanther,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIcon(iconData: Icons.add),
                ),
              ),
            ],
          ),
        ),
        CustomText(
          data: userName,
          textSize: TextSize.small,
          textWeight: TextWeight.bold,
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
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 150,
        width: 150,

        child: playlistCoverImage.isEmpty
            ? CustomIcon(
                iconData: Icons.music_note,
                iconSize: IconSize.mega,
                color: AppColors.planSectionColor,
              )
            : ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.network(playlistCoverImage, fit: BoxFit.cover),
              ),
      ),
    );
  }
}

class _AppBarTitleSection extends StatelessWidget {
  const _AppBarTitleSection({
    required this.widget,
    required this.appBarTitleFontSize,
  });

  final UpdatePlaylistView widget;
  final double appBarTitleFontSize;
  final double sizedBoxWidth = 200;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizedBoxWidth,
      child: Text(
        widget.playlistName,
        overflow: TextOverflow.fade,
        style: TextStyle(
          fontSize: appBarTitleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
