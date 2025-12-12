import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, 
    required this.data,
    this.color = AppColors.white,
    this.textSize = TextSize.small,
    this.textWeight = TextWeight.normal,
 this.textAlign = TextAlign.start,
  });
  final Color color;
  final String? data;
  final TextSize textSize;
  final TextWeight textWeight;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      data ?? "No data",
      style: TextStyle(
        color: color,
        fontSize: textSize.value,
        fontWeight: textWeight.value,
      ),
    );
  }
}

enum TextSize { small, medium, large, extraLarge }

extension TextSizeValue on TextSize {
  double get value {
    switch (this) {
      case TextSize.small:
        return 12.0;
      case TextSize.medium:
        return 14.0;
      case TextSize.large:
        return 18.0;
      case TextSize.extraLarge:
        return 24.0;
    }
  }
}

enum TextWeight { light, regular, normal, bold }

extension TextWeightValue on TextWeight {
  FontWeight get value {
    switch (this) {
      case TextWeight.light:
        return FontWeight.w300;
      case TextWeight.regular:
        return FontWeight.w400;
      case TextWeight.normal:
        return FontWeight.w500;
      case TextWeight.bold:
        return FontWeight.w700;
    }
  }
}