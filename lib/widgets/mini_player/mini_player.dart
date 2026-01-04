import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/helpers/color_extension.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/services/service_locator.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/view/player_view.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/auto_scrolling_text.dart';
import 'package:spotify_clone/widgets/progress_bars/mini_player_progress_bar.dart';

class MiniPlayer extends StatelessWidget {
  final player = getIt<PlayerStore>();
  MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem.distinct(
        (prev, next) => prev?.title == next?.title,
      ),
      builder: (context, snapshot) {
        final item = snapshot.data;
        if (item == null) {
          return Container(
            height: _Constants.miniPlayerHeight,
            margin: _Constants.emptyMargin,
          );
        }

        return GestureDetector(
          onTap: () => _openPlayerView(context),
          child: _MiniPlayerBackground(
            item: item,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: _Constants.contentPadding,
                    child: Row(
                      children: [
                        _MiniPlayerAlbumArt(
                          item: item,
                          currentType: player.currentType,
                        ),
                        SizedBox(width: _Constants.gapWidth),
                        Expanded(
                          child: SwipeableTextArea(
                           
                            player: player,
                            currentItem: item,
                          ),
                        ),
                        _MiniPlayerControls(player: player),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: _Constants.progressBarPadding,
                  child: MiniPlayerProgressBar(player: player),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPlayerView(BuildContext context) {
    PlayerView.show(
      context,
      title: player.playlist[player.currentIndex.value].trackName ?? "",
      playlist: player.playlist,
      currentIndex: player.currentIndex.value,
      type: player.currentType,
    );
  }
}

class SwipeableTextArea extends StatefulWidget {
  final PlayerStore player;
  final MediaItem currentItem;
  const SwipeableTextArea({
    super.key,
    required this.player,
    required this.currentItem,
  });

  @override
  State<SwipeableTextArea> createState() => _SwipeableTextAreaState();
}

class _SwipeableTextAreaState extends State<SwipeableTextArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _drag = 0.0;
  bool _isSwiping = false;
  String _helperText = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(SwipeableTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentItem.title != widget.currentItem.title) {
      setState(() {
        _isSwiping = false;
        _drag = 0;
        _controller.reset();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (d) => _onDragUpdate(d, width),
          onHorizontalDragEnd: (d) => _onDragEnd(width),
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => _buildSwipeContent(width),
            ),
          ),
        );
      },
    );
  }

  void _onDragUpdate(DragUpdateDetails d, double width) {
    if (_isSwiping) return;
    setState(() {
      _drag += d.delta.dx / width;
      _drag = _drag.clamp(-1.0, 1.0);
    });
  }

  void _onDragEnd(double width) {
    if (_drag.abs() > _Constants.swipeThresholdRatio) {
      setState(() {
        _isSwiping = true;
        _helperText = _drag < 0 ? AppLocalizations.of(context)!.miniPlayerNextTrack : AppLocalizations.of(context)!.miniPlayerPreviousTrack;
      });

      _controller.forward(from: 0.0).then((_) {
        if (_helperText == AppLocalizations.of(context)!.miniPlayerNextTrack) {
          widget.player.indexNext();
        } else {
          widget.player.indexPrevious();
        }
      });
    } else {
      setState(() => _drag = 0);
    }
  }

  Widget _buildSwipeContent(double width) {
    double mainX = _drag * width;
    if (_isSwiping) {
      mainX =
          _drag * width * (1 - _controller.value) -
          (_controller.value * (_drag < 0 ? width : -width));
    }

    final helperX = _drag < 0
        ? (width + mainX).clamp(0.0, width)
        : (-width + mainX).clamp(-width, 0.0);

    return Stack(
      children: [
        _SwipeActionLabel(
          xOffset: helperX,
          text: _isSwiping
              ? _helperText
              : (_drag < 0 ? AppLocalizations.of(context)!.miniPlayerNextTrack : AppLocalizations.of(context)!.miniPlayerPreviousTrack),
        ),
        Transform.translate(
          offset: Offset(mainX, 0),
          child: Opacity(
            opacity: (1 - _drag.abs()).clamp(0.0, 1.0),
            child: _TrackInfo(item: widget.currentItem),
          ),
        ),
      ],
    );
  }
}

class _MiniPlayerAlbumArt extends StatelessWidget {
  final MediaItem item;
  final MediaType currentType;

  const _MiniPlayerAlbumArt({required this.item, required this.currentType});

  @override
  Widget build(BuildContext context) {
    final String? albumArt = item.album;

    return ClipRRect(
      borderRadius: _Constants.albumRadius,
      child: SizedBox(
        height: _Constants.albumSize,
        width: _Constants.albumSize,
        child: albumArt == null || albumArt.isEmpty
            ? const ColoredBox(
                color: Colors.grey,
                child: Icon(Icons.music_note),
              )
            : currentType != MediaType.downloaded
            ? Image.network(
                albumArt,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildErrorWidget(),
              )
            : Image.file(
                File(albumArt),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildErrorWidget(),
              ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const ColoredBox(color: Colors.grey, child: Icon(Icons.music_note));
  }
}

class _MiniPlayerControls extends StatelessWidget {
  final PlayerStore player;

  const _MiniPlayerControls({required this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _MiniPlayerIconButton(icon: Icons.devices_outlined),
        const _MiniPlayerIconButton(icon: Icons.add_circle_outline),
        StreamBuilder<bool>(
          stream: player.playingStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data ?? false;
            return _MiniPlayerIconButton(
              icon: isPlaying ? Icons.pause : Icons.play_arrow,
              onTap: () =>
                  isPlaying ? player.playerPause() : player.playerPlay(),
            );
          },
        ),
      ],
    );
  }
}

class _MiniPlayerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _MiniPlayerIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: CustomIcon(iconData: icon, iconSize: IconSize.medium),
      ),
    );
  }
}

class _TrackInfo extends StatelessWidget {
  const _TrackInfo({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final trackStyle = _Constants.trackNameStyle(context);
    final artistStyle = _Constants.artistNameStyle(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoScrollingText(
          text: item.title,
          style: trackStyle,
          height: _Constants.astTrackNameHeight.h,
          blankSpace: _Constants.astBlankSpace,
          velocity: _Constants.astTrackNameVelocity,
        ),
        AutoScrollingText(
          text: item.artist ?? "",
          style: artistStyle,
          height: _Constants.astArtistNameHeight.h,
          blankSpace: _Constants.astBlankSpace,
          velocity: _Constants.astArtistNameNameVelocity,
        ),
      ],
    );
  }
}

class _MiniPlayerBackground extends StatelessWidget {
  final MediaItem item;
  final Widget child;

  const _MiniPlayerBackground({required this.item, required this.child});

  @override
  Widget build(BuildContext context) {
    final int? argb = item.extras?['color'] as int?;
    final Color bgColor = argb != null
        ? Color(argb).darken(0.50)
        : Colors.black;

    return Container(
      height: _Constants.miniPlayerHeight,
      margin: _Constants.playerMargin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: _Constants.playerRadius,
      ),
      child: child,
    );
  }
}

class _SwipeActionLabel extends StatelessWidget {
  final double xOffset;
  final String text;

  const _SwipeActionLabel({required this.xOffset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(xOffset, 0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ),
    );
  }
}

abstract final class _Constants {
  //Padding
  static EdgeInsets get progressBarPadding =>
      EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h);
  static EdgeInsets get contentPadding =>
      EdgeInsets.only(left: 10.w, right: 4.w);
  //Margin
  static EdgeInsets get emptyMargin =>
      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h);
  static EdgeInsets get playerMargin =>
      EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h);
  //Radius
  static BorderRadius get playerRadius => BorderRadius.circular(10.r);
  static BorderRadius get albumRadius => BorderRadius.circular(5.r);
  //Size
  static double get miniPlayerHeight => 60.h;
  static double get albumSize => 40.w;
  static double get gapWidth => 12.w;
  //Style
  static TextStyle trackNameStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!;
  static TextStyle artistNameStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!;
  //Auto Scrolling Text
  static double get astBlankSpace => 50.w;
  static const double astTrackNameVelocity = 30.0;
  static const double astArtistNameNameVelocity = 25.0;
  static const double astTrackNameHeight = 20;
  static const double astArtistNameHeight = 16;
  //Swipe Threshold Ratio
  static double get swipeThresholdRatio => 0.25;
}
