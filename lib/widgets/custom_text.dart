import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, 
    required this.data,
    this.color = AppColors.white,
    this.fontSize = 12,
    this.fontWeight = FontWeight.normal,
    this.padding,
  });
  final Color color;
  final String? data;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? AppPaddings.horizontal10,
      child: Text(
        data ?? "No data",
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}