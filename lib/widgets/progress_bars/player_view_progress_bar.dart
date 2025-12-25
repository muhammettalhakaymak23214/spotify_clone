import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/view_model/player_view_model.dart';

class PlayerViewProgresBar extends StatelessWidget {
  const PlayerViewProgresBar({
    super.key,
    required this.viewModel,
    required this.leftPadding,
  });

  final PlayerViewModel viewModel;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    //Variables
    final double barHeight = 5;
    final double thumbRadius = 5;
    final double timeLabelPadding = 10;
    final Color baseBaseColor = AppColors.grey;
    final Color progressBaseColor = AppColors.white;
    final Color thumbColor = AppColors.white;
    final textStyle = TextStyle(
      color: AppColors.grey,
      fontSize: AppSizes.fontSize,
    );

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
                baseBarColor: baseBaseColor,
                progressBarColor: progressBaseColor,
                thumbColor: thumbColor,
                thumbRadius: thumbRadius,
                timeLabelPadding: timeLabelPadding,
                timeLabelTextStyle: textStyle,
                onSeek: (newPosition) => viewModel.seek(newPosition),
              ),
            );
          },
        );
      },
    );
  }
}
