import 'package:flutter/material.dart';

enum AppTextStyle {
  display,
  h1,
  h2,
  h3,
  titleL,
  titleM,
  titleS,
  bodyL,
  bodyM,
  bodyS,
  labelL,
  labelM,
  labelS,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration; 
  final Color? decorationColor;

  const AppText({
    required this.text,
    super.key,
    this.style = AppTextStyle.bodyM,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
    this.overflow,
    this.softWrap,
    this.decoration,
    this.decorationColor
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final TextStyle? selectedStyle = switch (style) {
      AppTextStyle.display => textTheme.displayLarge,
      AppTextStyle.h1 => textTheme.headlineLarge,
      AppTextStyle.h2 => textTheme.headlineMedium,
      AppTextStyle.h3 => textTheme.headlineSmall,
      AppTextStyle.titleL => textTheme.titleLarge,
      AppTextStyle.titleM => textTheme.titleMedium,
      AppTextStyle.titleS => textTheme.titleSmall,
      AppTextStyle.bodyL => textTheme.bodyLarge,
      AppTextStyle.bodyM => textTheme.bodyMedium,
      AppTextStyle.bodyS => textTheme.bodySmall,
      AppTextStyle.labelL => textTheme.labelLarge,
      AppTextStyle.labelM => textTheme.labelMedium,
      AppTextStyle.labelS => textTheme.labelSmall,
    };

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      softWrap: softWrap,
      style: selectedStyle?.copyWith(color: color, fontWeight: fontWeight , decoration: decoration,decorationColor: decorationColor,),
    );
  }
}
