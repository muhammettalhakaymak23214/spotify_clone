import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';

class Point extends StatelessWidget {
  const Point({
    super.key,
    this.paddingValue = 0,
    this.color = AppColors.white,
    this.pointSize = 4,
  });
  final double paddingValue;
  final Color color;
  final double pointSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(paddingValue),
      child: Container(
        height: pointSize,
        width: pointSize,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
