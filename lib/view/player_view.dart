import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/services/service_locator.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/widgets/bottom_sheet/listen_mode_bottom_sheet.dart';
import 'package:spotify_clone/widgets/bottom_sheet/song_bottom_sheet.dart';
import 'package:spotify_clone/widgets/progress_bars/player_view_progress_bar.dart';

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
      backgroundColor: Colors.transparent,
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
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
              final Color color = argb != null ? Color(argb) : Colors.amber;

              return Container(
                width: 1.sw,
                height: 1.sh,
                decoration: _boxDecoration(color),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      children: [
                     
                        SizedBox(height: 45.h),
                        _CustomAppBar(
                          viewModel: viewModel,
                          widget: widget,
                          track: track,
                          title: widget.title,
                        ),

                       
                        const Spacer(flex: 2),

                    
                        _CoverImage(track: track, type: widget.type),

                    
                       SizedBox(height: 60.h),

                     
                        _Row1(track: track),
                        
                        SizedBox(height: 40.h),

                  
                        PlayerViewProgresBar(
                          viewModel: viewModel,
                          leftPadding: 0,
                        ),
SizedBox(height: 40.h),
                      
                        _Row2(
                          viewModel: viewModel,
                          otoNextValue: otoNextValue,
                          otoLoopValue: otoLoopValue,
                        ),

                       
                        SizedBox(height: 40.h),
                        const _Row3(),
                        
                       
                        SizedBox(height: 20.h),
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

  BoxDecoration _boxDecoration(Color backgroundColor) {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.r),
        topRight: Radius.circular(30.r),
      ),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          backgroundColor.withOpacity(1),
          AppColors.black.withOpacity(0.95),
        ],
        stops: const [0.0, 0.85],
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
        Icon(Icons.devices, color: Colors.white, size: 22.w),
        const Spacer(),
        Icon(Icons.share, color: Colors.white, size: 22.w),
        SizedBox(width: 25.w),
        Icon(Icons.queue_music, color: Colors.white, size: 24.w),
      ],
    );
  }
}


class _Row2 extends StatelessWidget {
  final PlayerStore viewModel;
  final bool otoNextValue;
  final bool otoLoopValue;

  const _Row2({required this.viewModel, required this.otoNextValue, required this.otoLoopValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _WhiteCircleButton(
          size: 42.w,
          onTap: () => ListenModeBottomSheet.show(context, viewModel),
          child: Image.asset(
            otoNextValue ? "assets/png/active_suffle.png" : "assets/png/suffle.png",
            width: 20.w,
          ),
        ),
        _WhiteCircleButton(
          size: 48.w,
          onTap: () => viewModel.indexPrevious(),
          child: Icon(Icons.skip_previous, color: Colors.black, size: 28.w),
        ),
        StreamBuilder<bool>(
          stream: viewModel.playingStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data ?? false;
            return _WhiteCircleButton(
              size: 65.w,
              onTap: () => isPlaying ? viewModel.playerPause() : viewModel.playerPlay(),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
                size: 38.w,
              ),
            );
          },
        ),
        _WhiteCircleButton(
          size: 48.w,
          onTap: () => viewModel.indexNext(),
          child: Icon(Icons.skip_next, color: Colors.black, size: 28.w),
        ),
        _WhiteCircleButton(
          size: 42.w,
          onTap: () async {
            await viewModel.setOtoLoop();
            viewModel.getOtoLoop();
            viewModel.getOtoNext();
          },
          child: Image.asset(
            otoLoopValue ? "assets/png/active_loop.png" : "assets/png/loop.png",
            width: 20.w,
          ),
        ),
      ],
    );
  }
}

class _WhiteCircleButton extends StatelessWidget {
  final double size;
  final Widget child;
  final VoidCallback onTap;
  const _WhiteCircleButton({required this.size, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
                  Text(
                    item?.title ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item?.artist ?? "",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16.sp, fontWeight: FontWeight.w400),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle_outline, color: Colors.white, size: 30.w),
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
    double imageSize = 0.85.sw;
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final item = snapshot.data;
        final albumArt = item?.album;
        return ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: albumArt != null && albumArt.isNotEmpty
              ? (type != MediaType.downloaded
                  ? Image.network(albumArt, width: imageSize, height: imageSize, fit: BoxFit.cover)
                  : Image.file(File(albumArt), width: imageSize, height: imageSize, fit: BoxFit.cover))
              : Container(
                  width: imageSize,
                  height: imageSize,
                  color: AppColors.grey,
                  child: Icon(Icons.music_note, color: Colors.white, size: 80.w),
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

  const _CustomAppBar({required this.widget, required this.track, required this.title, required this.viewModel});

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
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 35.w),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.type.title.toUpperCase(),
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.sp, letterSpacing: 1.2),
                  ),
                  Text(
                    item?.title ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                final bool isDownloaded = await viewModel.isDownloaded(item?.genre ?? "no id");
                SongBottomSheet.show(context, viewModel, track, title, widget.type, isDownloaded, item);
              },
              icon: Icon(Icons.more_vert, color: Colors.white, size: 28.w),
            ),
          ],
        );
      },
    );
  }
}