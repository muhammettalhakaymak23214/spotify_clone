import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/view_model/player_view_model.dart';

class ProgresBar extends StatelessWidget {
  const ProgresBar({super.key, required this.player});

  final PlayerViewModel player;

  @override
  Widget build(BuildContext context) {
    final double barHeight = 3;
    final double thumbRadius = 3;

    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (context, snapshotDuration) {
        final duration = snapshotDuration.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, snapshotPosition) {
            final position = snapshotPosition.data ?? Duration.zero;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: ProgressBar(
                progress: position,
                total: duration,
                barHeight: barHeight,
                baseBarColor: AppColors.grey,
                progressBarColor: AppColors.white,
                thumbColor: AppColors.white,
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
