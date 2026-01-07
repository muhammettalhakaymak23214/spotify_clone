import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/services/service_locator.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/widgets/bottom_sheet/listen_mode_bottom_sheet.dart';
import 'package:spotify_clone/widgets/bottom_sheet/song_bottom_sheet.dart';
import 'package:spotify_clone/widgets/progress_bars/player_view_progress_bar.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_icon.dart';

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

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<PlayTrackItem> playlist,
    required int currentIndex,
    required MediaType type,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _Constants.backgroundColor,
      barrierColor: _Constants.barrierColor,

      enableDrag: true,
      builder: (context) => PlayerView(
        title: title,
        playlist: playlist,
        currentIndex: currentIndex,
        type: type,
      ),
    );
  }

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  final viewModel = getIt<PlayerStore>();

  @override
  void initState() {
    super.initState();
    viewModel.getOtoLoop();
    viewModel.getOtoMode();
    viewModel.getOtoNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: _Constants.backgroundColor,
      body: Observer(
        builder: (context) {
          final track = viewModel.playlist[viewModel.currentIndex.value];
          final otoNextValue = viewModel.otoNext.value;
          final otoLoopValue = viewModel.otoLoop.value;

          return StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem,
            builder: (context, snapshot) {
              final item = snapshot.data;
              final int? argb = item?.extras?['color'] as int?;
              final Color color = argb != null
                  ? Color(argb)
                  : _Constants.defaultThemeColor;

              return Container(
                width: 1.sw,
                height: 1.sh,
                decoration: _Constants.boxDecoration(color),
                child: SafeArea(
                  child: Padding(
                    padding: _Constants.pagePadding,
                    child: Column(
                      children: [
                        SizedBox(height: _Constants.appBarTopGap),
                        _CustomAppBar(
                          viewModel: viewModel,
                          widget: widget,
                          track: track,
                          title: widget.title,
                        ),
                        const Spacer(flex: _Constants.spacerFlex),
                        _CoverImage(track: track, type: widget.type),
                        SizedBox(height: _Constants.sectionGapLarge),
                        _Row1(track: track),
                        SizedBox(height: _Constants.sectionGapMedium),
                        PlayerViewProgresBar(player: viewModel),
                        SizedBox(height: _Constants.sectionGapMedium),
                        _Row2(
                          viewModel: viewModel,
                          otoNextValue: otoNextValue,
                          otoLoopValue: otoLoopValue,
                        ),
                        SizedBox(height: _Constants.sectionGapMedium),
                        const _Row3(),
                        SizedBox(height: _Constants.bottomGap),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Row3 extends StatelessWidget {
  const _Row3();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(
          icon: Icons.devices,
          color: Colors.white,
          customSize: _Constants.smallIconSize,
        ),
        const Spacer(),
        AppIcon(
          icon: Icons.share,
          color: Colors.white,
          customSize: _Constants.smallIconSize,
        ),
        SizedBox(width: _Constants.row3IconGap),
        AppIcon(
          icon: Icons.queue_music,
          color: Colors.white,
          customSize: _Constants.mediumIconSize,
        ),
      ],
    );
  }
}

class _Row2 extends StatelessWidget {
  final PlayerStore viewModel;
  final bool otoNextValue;
  final bool otoLoopValue;

  const _Row2({
    required this.viewModel,
    required this.otoNextValue,
    required this.otoLoopValue,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _WhiteCircleButton(
            size: _Constants.controlBtnSizeSmall,
            onTap: () => ListenModeBottomSheet.show(context, viewModel),
            child: Image.asset(
              otoNextValue
                  ? _Constants.pathActiveShuffle
                  : _Constants.pathShuffle,
              width: _Constants.shuffleIconWidth,
            ),
          ),
          _WhiteCircleButton(
            size: _Constants.controlBtnSizeMedium,
            onTap: () => viewModel.indexPrevious(),
            child: AppIcon(
              icon: Icons.skip_previous,
              color: Colors.black,
              customSize: _Constants.skipIconSize,
            ),
          ),
          StreamBuilder<bool>(
            stream: viewModel.playingStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;
              return _WhiteCircleButton(
                size: _Constants.controlBtnSizeLarge,
                onTap: () => isPlaying
                    ? viewModel.playerPause()
                    : viewModel.playerPlay(),
                child: AppIcon(
                  icon: isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                  customSize: _Constants.playIconSize,
                ),
              );
            },
          ),
          _WhiteCircleButton(
            size: _Constants.controlBtnSizeMedium,
            onTap: () => viewModel.indexNext(),
            child: AppIcon(
              icon: Icons.skip_next,
              color: Colors.black,
              customSize: _Constants.skipIconSize,
            ),
          ),
          _WhiteCircleButton(
            size: _Constants.controlBtnSizeSmall,
            onTap: () async {
              await viewModel.setOtoLoop();
              viewModel.getOtoLoop();
              viewModel.getOtoNext();
            },
            child: Image.asset(
              otoLoopValue ? _Constants.pathActiveLoop : _Constants.pathLoop,
              width: _Constants.shuffleIconWidth,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteCircleButton extends StatelessWidget {
  final double size;
  final Widget child;
  final VoidCallback onTap;
  const _WhiteCircleButton({
    required this.size,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: _Constants.circleDecoration,
        child: Center(child: child),
      ),
    );
  }
}

class _Row1 extends StatelessWidget {
  final PlayTrackItem track;
  const _Row1({required this.track});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final item = snapshot.data;
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: item?.title ?? "",
                    style: AppTextStyle.h2,
                    color: Colors.white,
                    maxLines: 1,
                  ),
                  AppText(
                    text: item?.artist ?? "",
                    style: AppTextStyle.bodyL,
                    color: Colors.white.withOpacity(0.7),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            AppIcon(
              icon: Icons.add_circle_outline,
              color: Colors.white,
              customSize: _Constants.addIconSize,
            ),
          ],
        );
      },
    );
  }
}

class _CoverImage extends StatelessWidget {
  final MediaType type;
  final PlayTrackItem track;
  const _CoverImage({required this.track, required this.type});

  @override
  Widget build(BuildContext context) {
    final double imageSize = _Constants.albumArtSize;
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final item = snapshot.data;
        final albumArt = item?.album;
        return ClipRRect(
          borderRadius: _Constants.albumArtRadius,
          child: albumArt != null && albumArt.isNotEmpty
              ? (type != MediaType.downloaded
                    ? Image.network(
                        albumArt,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(albumArt),
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ))
              : Container(
                  width: imageSize,
                  height: imageSize,
                  color: AppColors.grey,
                  child: AppIcon(
                    icon: Icons.music_note,
                    color: Colors.white,
                    customSize: _Constants.placeholderIconSize,
                  ),
                ),
        );
      },
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final PlayerStore viewModel;
  final PlayTrackItem track;
  final PlayerView widget;
  final String title;

  const _CustomAppBar({
    required this.widget,
    required this.track,
    required this.title,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final item = snapshot.data;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: AppIcon(
                icon: Icons.keyboard_arrow_down,
                color: Colors.white,
                customSize: _Constants.appBarArrowSize,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: widget.type.title(context).toUpperCase(),
                    style: AppTextStyle.labelS,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  AppText(
                    text: item?.title ?? "",
                    style: AppTextStyle.titleS,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                final bool isDownloaded = await viewModel.isDownloaded(
                  item?.genre ?? "no id",
                );
                SongBottomSheet.show(
                  context,
                  viewModel,
                  track,
                  title,
                  widget.type,
                  isDownloaded,
                  item,
                );
              },
              icon: AppIcon(
                icon: Icons.more_vert,
                color: Colors.white,
                customSize: _Constants.appBarMoreSize,
              ),
            ),
          ],
        );
      },
    );
  }
}

abstract final class _Constants {
  // Colors & Decorations
  static Color get  backgroundColor => AppColors.transparent;
  static Color get  barrierColor => AppColors.black;
  static const Color scaffoldBgColor = Color.fromARGB(255, 0, 0, 0);
  static const Color defaultThemeColor = Colors.amber;
  static BoxDecoration boxDecoration(Color color) => BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30.r),
      topRight: Radius.circular(30.r),
    ),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color, AppColors.black.withOpacity(0.95)],
      stops: const [0.0, 0.85],
    ),
  );
  static const BoxDecoration circleDecoration = BoxDecoration(
    color: Colors.white,
    shape: BoxShape.circle,
  );

  // Paddings & Gaps
  static EdgeInsets get pagePadding => EdgeInsets.symmetric(horizontal: 25.w);
  static double get appBarTopGap => 45.h;
  static double get sectionGapLarge => 60.h;
  static double get sectionGapMedium => 40.h;
  static double get bottomGap => 20.h;
  static double get row3IconGap => 25.w;
  static const int spacerFlex = 2;

  // Icon & Button Sizes
  static double get appBarArrowSize => 35.w;
  static double get appBarMoreSize => 28.w;
  static double get smallIconSize => 22.w;
  static double get mediumIconSize => 24.w;
  static double get addIconSize => 30.w;
  static double get placeholderIconSize => 80.w;
  static double get skipIconSize => 28.w;
  static double get playIconSize => 38.w;
  static double get shuffleIconWidth => 20.w;

  static double get controlBtnSizeSmall => 42.w;
  static double get controlBtnSizeMedium => 48.w;
  static double get controlBtnSizeLarge => 65.w;

  // Album Art
  static double get albumArtSize => 0.85.sw;
  static BorderRadius get albumArtRadius => BorderRadius.circular(20.r);

  //Paths
  static String pathShuffle = AppStrings.suffleImage;
  static String pathActiveShuffle = AppStrings.activeSuffleImage;
  static String pathLoop = AppStrings.loopImage;
  static String pathActiveLoop = AppStrings.activeLoopImage;

}
