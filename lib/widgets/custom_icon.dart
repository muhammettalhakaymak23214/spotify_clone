import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.iconData,
    this.color = AppColors.white,
    this.iconSize = IconSize.medium,
  });
  final IconData iconData;
  final Color color;
  final IconSize iconSize;
  @override
  Widget build(BuildContext context) {
    return Icon(iconData, color: color, size: iconSize.value );
  }
}

enum IconSize { extraSmall, small, medium, large, extraLarge ,xxLarge, mega }

extension IconSizeValue on IconSize {
  double get value {
    switch (this) {
      case IconSize.extraSmall:
        return 12.0;
      case IconSize.small:
        return 16.0;
      case IconSize.medium:
        return 20.0;
      case IconSize.large:
        return 24.0;
      case IconSize.extraLarge:
        return 32.0;
      case IconSize.xxLarge:
        return 48.0;
      case IconSize.mega:
        return 70.0;
    }
  }
}
