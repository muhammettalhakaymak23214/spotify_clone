import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/view_model/player_view_model.dart';

class MiniPlayerProgressBar extends StatelessWidget {
  const MiniPlayerProgressBar({super.key, required this.player});

  final PlayerViewModel player;

  @override
  Widget build(BuildContext context) {
    final double barHeight = 3;
    final double thumbRadius = 3;
    final EdgeInsetsGeometry progressBarPadding = EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 2,
    );
    final Color baseBaseColor = AppColors.grey;
    final Color progressBaseColor = AppColors.white;
    final Color thumbColor = AppColors.white;

    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (context, snapshotDuration) {
        final duration = snapshotDuration.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, snapshotPosition) {
            final position = snapshotPosition.data ?? Duration.zero;

            return Padding(
              padding: progressBarPadding,
              child: ProgressBar(
                progress: position,
                total: duration,
                barHeight: barHeight,
                baseBarColor: baseBaseColor,
                progressBarColor: progressBaseColor,
                thumbColor: thumbColor,
                thumbRadius: thumbRadius,
                timeLabelLocation: TimeLabelLocation.none,
                onSeek: (newPosition) => player.seek(newPosition),
              ),
            );
          },
        );
      },
    );
  }
}
