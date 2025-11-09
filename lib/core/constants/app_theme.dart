import 'package:flutter/material.dart';

class AppTheme {
  static const Color white = Color(0xFFFFFFFF);
  static const Color Black = Colors.black;
  static const Color Black54 = Colors.black54;
  static const Color Black87 = Colors.black87;
  static const Color ScaffoldBackGroundColor = Color(0xFFFFF8E7);
  static const Color BoxColor1 = Color(0xFFFFF1E6);
  static const Color BoxColor2 = Color(0xFFFFE7D1);
  static ThemeData buildLightTheme() {
    final ColorScheme colorScheme = const ColorScheme.light().copyWith();
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: Color(0xFFC69320),
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),

      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      platform: TargetPlatform.iOS,
    );
  }
}

Widget verticalSpace(double h) => SizedBox(height: h);
