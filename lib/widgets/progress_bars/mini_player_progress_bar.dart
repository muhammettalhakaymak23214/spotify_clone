import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/models/progress_bar_state.dart';

class MiniPlayerProgressBar extends StatelessWidget {
  const MiniPlayerProgressBar({super.key, required this.player});

  final PlayerStore player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProgressBarState>(
      stream: player.progressBarStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final position = state?.position ?? Duration.zero;
        final total =
            state?.total ??
            Duration.zero; 

        return ProgressBar(
          progress: position,
          total: total,
          barHeight: _Constants.barHeight,
          baseBarColor: _Constants.baseBarColor,
          progressBarColor: _Constants.progressBarColor,
          thumbColor: _Constants.thumbColor,
          thumbRadius: _Constants.thumbRadius,
          timeLabelLocation: TimeLabelLocation.none,
          onSeek: (newPosition) => player.seek(newPosition),
        );
      },
    );
  }
}

abstract final class _Constants {
  // Size
  static double get barHeight => 3.h;
  static double get thumbRadius => 0;
  // Color
  static final Color baseBarColor = AppColors.white.withValues(alpha: 0.2);
  static const Color progressBarColor = AppColors.white;
  static const Color thumbColor = AppColors.white;
}
