import 'package:flutter/material.dart';
import 'package:wingscape_puzzle/style/theme.dart';

class StyledText extends StatelessWidget {
  const StyledText({super.key, required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: <Widget>[
          Text(
            text,
            style: AppTheme.headings.copyWith(
              fontSize: fontSize,
              decoration: TextDecoration.none,
              color: AppTheme.pink,
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) {
              return AppTheme.pinkGradient.createShader(Rect.fromLTWH(
                  -bounds.width * 0.1,
                  -bounds.height * 0.1,
                  bounds.width * 1.2,
                  bounds.height * 1.2));
            },
            child: Text(
              text,
              style: AppTheme.headings.copyWith(
                fontSize: fontSize,
                decoration: TextDecoration.none,
                color: const Color.fromARGB(255, 238, 171, 193),
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
    });
  }
}
