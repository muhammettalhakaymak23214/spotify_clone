import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart'; 
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/helpers/color_extension.dart';
import 'package:spotify_clone/core/services/service_locator.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/view/player_view.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/progress_bars/mini_player_progress_bar.dart';

class MiniPlayer extends StatelessWidget {
  final player = getIt<PlayerStore>();
  MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
     
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final item = snapshot.data;
        if (item == null) {
          return Container(
            height: 60.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          );
        }

        final int? argb = item.extras?['color'] as int?;
        final Color bgColor = argb != null
            ? Color(argb).darken(0.50)
            : Colors.black;

        return GestureDetector(
          onTap: () => _openPlayer(context),
          child: Container(
            height: 60.h, 
            margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10.r), 
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 4.w),
                    child: Row(
                      children: [
                        _buildAlbumArt(item, 40.w), 
                        SizedBox(width: 12.w), 

                        Expanded(
                          child: SwipeableTextArea(
                            player: player,
                            currentItem: item,
                          ),
                        ),

                        _buildButtons(player),
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

  Widget _buildAlbumArt(MediaItem item, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: (getIt<PlayerStore>().currentType != MediaType.downloaded)
          ? Image.network(
              item.album!,
              height: size,
              width: size,
              fit: BoxFit.cover,
            )
          : Image.file(
              File(item.album!),
              height: size,
              width: size,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildButtons(PlayerStore player) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _icon(Icons.devices_outlined),
        _icon(Icons.add_circle_outline),
        StreamBuilder<bool>(
          stream: player.playingStream,
          builder: (_, s) {
            final playing = s.data ?? false;
            return _icon(
              playing ? Icons.pause : Icons.play_arrow,
              onTap: () => playing ? player.playerPause() : player.playerPlay(),
            );
          },
        ),
      ],
    );
  }

  Widget _icon(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: CustomIcon(iconData: icon, iconSize: IconSize.medium),
      ),
    );
  }

  void _openPlayer(BuildContext context) {
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerView(
          title: player.playlist[player.currentIndex.value].trackName ?? "",
          type: player.currentType,
          playlist: player.playlist,
          currentIndex: player.currentIndex.value,
        ),
      ),
    );*/
    PlayerView.show(
  context,
  title: player.playlist[player.currentIndex.value].trackName ?? "",
  playlist: player.playlist,
  currentIndex:player.currentIndex.value,
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
    if (oldWidget.currentItem.id != widget.currentItem.id) {
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
          onHorizontalDragUpdate: (d) {
            if (_isSwiping) return;
            setState(() {
              _drag += d.delta.dx / width;
              _drag = _drag.clamp(-1.0, 1.0);
            });
          },
          onHorizontalDragEnd: (d) {
            if (_drag.abs() > 0.25) {
              setState(() {
                _isSwiping = true;
                _helperText = _drag < 0 ? "Sonraki parça" : "Önceki parça";
              });

              _controller.forward(from: 0.0).then((_) {
                if (_helperText == "Sonraki parça") {
                  widget.player.indexNext();
                } else {
                  widget.player.indexPrevious();
                }
              });
            } else {
              setState(() => _drag = 0);
            }
          },
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                double mainX = _drag * width;
                if (_isSwiping) {
                  mainX = _drag * width * (1 - _controller.value) -
                      (_controller.value * (_drag < 0 ? width : -width));
                }

                double helperX;
                if (_drag < 0) {
                  helperX = (width + mainX).clamp(0.0, width);
                } else {
                  helperX = (-width + mainX).clamp(-width, 0.0);
                }

                return Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(helperX, 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _drag < 0 ? "Sonraki parça" : "Önceki parça",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp, 
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(mainX, 0),
                      child: Opacity(
                        opacity: (1 - _drag.abs()).clamp(0.0, 1.0),
                        child: _buildTrackInfo(widget.currentItem),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrackInfo(MediaItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.h, 
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final textStyle = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp, 
              );

              final TextPainter textPainter = TextPainter(
                text: TextSpan(text: item.title, style: textStyle),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();

              if (textPainter.width > maxWidth) {
                return Marquee(
                  text: item.title,
                  style: textStyle,
                  blankSpace: 50.w,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 2),
                  startAfter: const Duration(seconds: 1),
                );
              } else {
                return Text(item.title, style: textStyle, maxLines: 1);
              }
            },
          ),
        ),
        SizedBox(
          height: 16.h, 
          child: LayoutBuilder(
            builder: (context, constraints) {
              final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 11.sp, 
                  ) ?? TextStyle(color: Colors.white70, fontSize: 9.sp);

              final TextPainter textPainter = TextPainter(
                text: TextSpan(text: item.artist ?? "", style: textStyle),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();

              if (textPainter.width > constraints.maxWidth) {
                return Marquee(
                  text: item.artist ?? "",
                  style: textStyle,
                  blankSpace: 40.w,
                  velocity: 25.0,
                  pauseAfterRound: const Duration(seconds: 2),
                );
              } else {
                return Text(item.artist ?? "", style: textStyle, maxLines: 1);
              }
            },
          ),
        ),
      ],
    );
  }
}


abstract final class _Constants {

  static EdgeInsets get progressBarPadding => EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h);

}