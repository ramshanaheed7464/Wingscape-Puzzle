import 'package:flutter/material.dart';

class AppTheme {
  static const Color blur = Color(0xFF2C2C2C);
  static const Color pinkBorder = Color(0xFFFF8AB7);
  static const Color purpleBorder = Color(0xFFB48EFF);
  static const Color grey = Color(0xFFD6D6D6);
  static const Color pink = Color(0xFFDA3C78);
  static const Color purple = Color(0xFF8C52FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color peach = Color(0xFFFBE6EE);

  static const Gradient pinkGradient = LinearGradient(
    colors: [grey, pink],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Gradient line = LinearGradient(
    colors: [grey, pink],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );
  static const Gradient purpleGradient = LinearGradient(
    colors: [grey, purple],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient text = RadialGradient(
    colors: [grey, grey],
    center: Alignment.center,
    radius: 0.5,
  );
  static const TextStyle headings = TextStyle(
    fontFamily: 'Lobster',
    fontWeight: FontWeight.w900,
  );

  static const TextStyle textTheme = TextStyle(
    fontFamily: 'Lobster',
    fontWeight: FontWeight.w900,
    fontSize: 15,
    color: Colors.white,
  );
}
