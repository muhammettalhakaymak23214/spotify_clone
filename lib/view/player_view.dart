import 'dart:io';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/view_model/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';
import 'package:spotify_clone/widgets/bottom_sheet/listen_mode_bottom_sheet.dart';
import 'package:spotify_clone/widgets/bottom_sheet/song_bottom_sheet.dart';

class PlayerView extends StatefulWidget {
  final String title;
  final List<PlayTrackItem> playlist;
  final int currentIndex;
  final MediaType type;

  const PlayerView({
    super.key,
    required this.title,
    required this.type,
    required this.playlist,
    required this.currentIndex,
  });

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late PlayerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = PlayerViewModel();
    viewModel.currentType = widget.type;
    viewModel.initPlayer();
    viewModel.playlist.addAll(widget.playlist);
    viewModel.currentIndex.value = widget.currentIndex;
    viewModel.selectAlbumUrlOrPath(widget.type);
    viewModel.startSong(widget.type);
  }

  @override
  void dispose() {
    viewModel.stopSong();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double leftPadding = (screenWidth - 350) / 2;

    final double sizedBoxHeightOne = 70;
    final double sizedBoxHeightTwo = 20;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Observer(
          builder: (context) {
            final track = viewModel.playlist[viewModel.currentIndex.value];
            final color = viewModel.bgColor;
            return _CustomAppBar(
              viewModel: viewModel,
              backgroundColor: color.value,
              widget: widget,
              track: track,
              title: widget.title,
            );
          },
        ),
      ),
      body: Observer(
        builder: (context) {
          final track = viewModel.playlist[viewModel.currentIndex.value];
          final otoNextValue = viewModel.otoNext.value;
          final otoLoopValue = viewModel.otoLoop.value;
          final backgroundColor = viewModel.bgColor.value;

          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: _boxDecoration(backgroundColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CoverImage(
                  leftPadding: leftPadding,
                  track: track,
                  type: widget.type,
                ),
                SizedBox(height: sizedBoxHeightOne),
                _Row1(leftPadding: leftPadding, track: track),
                SizedBox(height: sizedBoxHeightTwo),
                _ProgresBar(viewModel: viewModel, leftPadding: leftPadding),
                _Row2(
                  leftPadding: leftPadding,
                  viewModel: viewModel,
                  otoNextValue: otoNextValue,
                  otoLoopValue: otoLoopValue,
                ),
                SizedBox(height: 20),
                _Row3(leftPadding: leftPadding),
              ],
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _boxDecoration(Color backgroundColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          backgroundColor.withValues(alpha: 1),
          AppColors.black.withValues(alpha: 0.5),
        ],
        stops: [0.3, 0.9],
      ),
    );
  }
}

class _ProgresBar extends StatelessWidget {
  const _ProgresBar({required this.viewModel, required this.leftPadding});

  final PlayerViewModel viewModel;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    final double barHeight = 5;
    final double thumbRadius = 5;
    final double timeLabelPadding = 10;

    return StreamBuilder<Duration?>(
      stream: viewModel.durationStream,
      builder: (context, snapshotDuration) {
        final duration = snapshotDuration.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: viewModel.positionStream,
          builder: (context, snapshotPosition) {
            final position = snapshotPosition.data ?? Duration.zero;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: leftPadding),
              child: ProgressBar(
                progress: position,
                total: duration,
                barHeight: barHeight,
                baseBarColor: AppColors.grey,
                progressBarColor: AppColors.white,
                thumbColor: AppColors.white,
                thumbRadius: thumbRadius,
                timeLabelPadding: timeLabelPadding,
                timeLabelTextStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: AppSizes.fontSize,
                ),
                onSeek: (newPosition) => viewModel.seek(newPosition),
              ),
            );
          },
        );
      },
    );
  }
}

class _Row3 extends StatelessWidget {
  const _Row3({required this.leftPadding});

  final double leftPadding;
  final double containerWidth = 250;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: containerWidth,
            child: CustomIcon(iconData: Icons.devices),
          ),
          CustomIcon(iconData: Icons.share),
          CustomIcon(iconData: Icons.queue_music),
        ],
      ),
    );
  }
}

class _Row2 extends StatelessWidget {
  _Row2({
    required this.leftPadding,
    required this.viewModel,
    required this.otoNextValue,
    required this.otoLoopValue,
  });

  final double leftPadding;
  final PlayerViewModel viewModel;
  final bool otoNextValue;
  final bool otoLoopValue;

  final String activeSuffleIconPath = "assets/png/active_suffle.png";
  final String suffleIconPath = "assets/png/suffle.png";
  final String activeLoopIconPath = "assets/png/active_loop.png";
  final String loopIconPath = "assets/png/loop.png";

  final double smallContainerSize = 40;
  final double mediumContainerSize = 50;
  final BorderRadiusGeometry borderRadius = BorderRadius.circular(50);
  final double smallSpaceWidth = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: smallContainerSize,
            width: smallContainerSize,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: borderRadius,
            ),
            child: IconButton(
              icon: SizedBox(
                height: 30,
                child: otoNextValue
                    ? Image.asset(activeSuffleIconPath)
                    : Image.asset(suffleIconPath),
              ),
              onPressed: () {
                ListenModeBottomSheet.show(context, viewModel);
              },
            ),
          ),
          SizedBox(width: smallSpaceWidth),
          Container(
            height: mediumContainerSize,
            width: mediumContainerSize,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: borderRadius,
            ),
            child: IconButton(
              onPressed: () {
                viewModel.indexPrevious();
              },
              icon: CustomIcon(
                color: AppColors.black,
                iconData: Icons.skip_previous,
                iconSize: IconSize.extraLarge,
              ),
            ),
          ),

          StreamBuilder<bool>(
            stream: viewModel.playingStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;

              return IconButton(
                icon: CustomIcon(
                  iconData: isPlaying ? Icons.pause_circle : Icons.play_circle,
                  iconSize: IconSize.mega,
                ),
                onPressed: () {
                  if (isPlaying) {
                    viewModel.playerPause();
                  } else {
                    viewModel.playerPlay();
                  }
                },
              );
            },
          ),
          Container(
            height: mediumContainerSize,
            width: mediumContainerSize,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: borderRadius,
            ),
            child: IconButton(
              onPressed: () {
                viewModel.indexNext();
              },
              icon: CustomIcon(
                color: AppColors.black,
                iconData: Icons.skip_next,
                iconSize: IconSize.extraLarge,
              ),
            ),
          ),
          SizedBox(width: smallSpaceWidth),
          Container(
            height: smallContainerSize,
            width: smallContainerSize,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: borderRadius,
            ),
            child: IconButton(
              icon: SizedBox(
                child: viewModel.otoLoop.value
                    ? Image.asset(activeLoopIconPath)
                    : Image.asset(loopIconPath),
              ),
              onPressed: () {
                viewModel.setOtoLoop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Row1 extends StatelessWidget {
  const _Row1({required this.leftPadding, required this.track});

  final double leftPadding;
  final PlayTrackItem track;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                data: track.trackName,
                textSize: TextSize.large,
                textWeight: TextWeight.bold,
              ),
              CustomText(
                data: track.artistName,
                textSize: TextSize.large,
                textWeight: TextWeight.normal,
              ),
            ],
          ),
          CustomIcon(
            iconData: Icons.add_circle_outline,
            iconSize: IconSize.extraLarge,
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.leftPadding,
    required this.track,
    required this.type,
  });

  final MediaType type;
  final double leftPadding;
  final PlayTrackItem track;
  final double size = 350;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: type != MediaType.downloaded
          ? ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: track.albumImage != null && track.albumImage!.isNotEmpty
                  ? Image.network(
                      track.albumImage!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: size,
                      height: size,
                      color: AppColors.grey,
                      child: CustomIcon(
                        iconData: Icons.music_note,
                        iconSize: IconSize.extraLarge,
                      ),
                    ),
            )
          : ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child:
                  track.albumImagePath != null &&
                      track.albumImagePath!.isNotEmpty
                  ? Image.file(
                      File(track.albumImagePath!),
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: size,
                      height: size,
                      color: AppColors.grey,
                      child: CustomIcon(
                        iconData: Icons.music_note,
                        iconSize: IconSize.extraLarge,
                      ),
                    ),
            ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  _CustomAppBar({
    required this.widget,
    required this.backgroundColor,
    required this.track,
    required this.title,
    required this.viewModel,
  });
  final PlayerViewModel viewModel;
  final PlayTrackItem track;
  final Color backgroundColor;
  final PlayerView widget;
  final EdgeInsetsGeometry actionPadding = EdgeInsets.only(right: 20);
  final double leadingWidth = 80;
  final double backgroundColorAlphaValue = 0.8;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: backgroundColor.withValues(
        alpha: backgroundColorAlphaValue,
      ),
      title: Column(
        children: [
          CustomText(data: widget.type.title, textWeight: TextWeight.light),
          CustomText(
            data: widget.title,
            textWeight: TextWeight.normal,
            textSize: TextSize.medium,
          ),
        ],
      ),
      leadingWidth: leadingWidth,
      actionsPadding: actionPadding,
      actions: [
        IconButton(
          onPressed: () async {
            final bool isDowloaded = await viewModel.isDownloaded(
              track.id ?? "no id",
            );

            SongBottomSheet.show(
              context,
              viewModel,
              track,
              title,
              widget.type,
              isDowloaded,
            );
          },
          icon: CustomIcon(iconData: Icons.more_vert_outlined),
        ),
      ],
    );
  }
}
