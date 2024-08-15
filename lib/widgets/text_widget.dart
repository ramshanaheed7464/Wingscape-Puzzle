import 'package:wingscape_puzzle/style/theme.dart';
import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText({super.key, required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.grey, AppTheme.pink],
              stops: [0.0, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            text,
            style: AppTheme.headings.copyWith(
              fontSize: fontSize,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Text(
          text,
          style: AppTheme.headings.copyWith(
            decoration: TextDecoration.none,
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.1
              ..color = Colors.white,
          ),
        ),
      ],
    );
  }
}
