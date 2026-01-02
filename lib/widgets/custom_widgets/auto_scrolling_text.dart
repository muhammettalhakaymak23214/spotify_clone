import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';

class AutoScrollingText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double height;
  final double blankSpace;
  final double velocity;
  final Duration startAfter;
  final Duration pauseAfterRound;
  final Duration accelerationDuration;
  final Curve accelerationCurve;

  const AutoScrollingText({
    super.key,
    required this.text,
    required this.style,
    required this.height,
    this.blankSpace = 50.0,
    this.velocity = 30.0,
    this.startAfter = const Duration(seconds: 1),
    this.pauseAfterRound = const Duration(seconds: 2),
    this.accelerationDuration = const Duration(seconds: 1),
    this.accelerationCurve = Curves.linear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;

          final TextPainter textPainter = TextPainter(
            text: TextSpan(text: text, style: style),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout();

          if (textPainter.width <= maxWidth) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(text, style: style, maxLines: 1, softWrap: false),
            );
          }

          return Marquee(
            text: text,
            style: style,
            blankSpace: blankSpace.w,
            velocity: velocity,
            pauseAfterRound: pauseAfterRound,
            startAfter: startAfter,
            accelerationDuration: accelerationDuration,
            accelerationCurve: accelerationCurve,
          );
        },
      ),
    );
  }
}
