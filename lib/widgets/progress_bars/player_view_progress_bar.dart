import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/models/progress_bar_state.dart';

class PlayerViewProgresBar extends StatelessWidget {
  const PlayerViewProgresBar({super.key, required this.player});

  final PlayerStore player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProgressBarState>(
      stream: player.progressBarStream,
      initialData: ProgressBarState(
        position: Duration.zero,
        total: Duration.zero,
      ),
      builder: (context, snapshot) {
        final state = snapshot.data!;

        return ProgressBar(
          progress: state.position,
          total: state.total,
          barHeight: _Constants.barHeight,
          baseBarColor: _Constants.baseBarColor,
          progressBarColor: _Constants.progressBarColor,
          thumbColor: _Constants.thumbColor,
          thumbRadius: _Constants.thumbRadius,
          timeLabelPadding: _Constants.timeLabelPadding,
          timeLabelTextStyle: _Constants.textStyle,
          onSeek: (newPosition) => player.seek(newPosition),
        );
      },
    );
  }
}

abstract final class _Constants {
  //Size
  static double get barHeight => 4.h;
  static double get thumbRadius => 6.r;
  static const double timeLabelPadding = 8.0;
  //TextStyle
  static final TextStyle textStyle = TextStyle(
    color: AppColors.grey,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
  //Color
  static final Color baseBarColor = AppColors.white.withValues(alpha: 0.2);
  static const Color progressBarColor = AppColors.white;
  static const Color thumbColor = AppColors.white;
}
