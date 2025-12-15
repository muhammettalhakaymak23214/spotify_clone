import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';

class CustomDragHandle extends StatelessWidget {
  const CustomDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final double dragHeight = 5;
    final double dragWidth = 40;
    final BorderRadiusGeometry borderRadius = BorderRadius.circular(10);

    return Center(
      child: Container(
        width: dragWidth,
        height: dragHeight,
        decoration: BoxDecoration(
          color: AppColors.dragColor,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
