import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/palette.dart';

final kLightTheme = ThemeData(
  fontFamily: 'Inter',
  appBarTheme: AppBarTheme(backgroundColor: Palette.darkGrey, elevation: 0),
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black, // color for text and everything
  primaryColorLight: Palette.lightGrey,
  accentColor: Palette.darkGrey,
);

final kDarkTheme = kLightTheme.copyWith(
  appBarTheme: AppBarTheme(backgroundColor: Palette.lightGrey, elevation: 0),
  backgroundColor: Color(0xFF111111),
  scaffoldBackgroundColor: Color(0xFF111111),
  primaryColor: Colors.white, // color for text and everything
  primaryColorLight: Palette.darkGrey,
  accentColor: Palette.lightGrey,
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  primaryIconTheme: IconThemeData(color: Colors.white),
);
