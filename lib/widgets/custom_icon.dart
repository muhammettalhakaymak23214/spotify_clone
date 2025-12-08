import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key, required this.iconData, this.color = AppColors.white, this.iconSize = 22});
  final IconData iconData;
  final Color color;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return Icon(iconData, color: color, size: iconSize);
  }
}