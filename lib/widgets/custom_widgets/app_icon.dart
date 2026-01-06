import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppIconSize {
  tiny,   // 16
  small,  // 20
  medium, // 24 (Default)
  large,  // 32
  huge,   // 48
}

class AppIcon extends StatelessWidget {
  final IconData icon;
  final AppIconSize size;
  final Color? color;
  final double? customSize;

  const AppIcon({
    required this.icon,
    super.key,
    this.size = AppIconSize.medium,
    this.color,
    this.customSize,
  });

  @override
  Widget build(BuildContext context) {
    final double selectedSize = customSize ?? switch (size) {
      AppIconSize.tiny => 16.sp,
      AppIconSize.small => 20.sp,
      AppIconSize.medium => 24.sp,
      AppIconSize.large => 32.sp,
      AppIconSize.huge => 48.sp,
    };

    return Icon(
      icon,
      size: selectedSize,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }
}