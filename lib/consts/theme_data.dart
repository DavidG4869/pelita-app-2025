import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        accentColor: Colors.orange,
        backgroundColor: isDarkTheme ? Colors.grey[800] : Colors.transparent,
        disabledColor: Colors.grey,
        indicatorColor: isDarkTheme ? Colors.white : Colors.black,
        textSelectionColor: isDarkTheme ? Colors.orange[800] : Colors.black,
        brightness: Brightness.dark,
        canvasColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
        appBarTheme: AppBarTheme(elevation: 0, centerTitle: true),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.robotoTextTheme().apply(bodyColor: isDarkTheme ? Color(0xFFFFFFFF) : Color(0xFF000000)),
        cardColor: isDarkTheme ? Colors.grey[850] : Colors.white,
        buttonColor: isDarkTheme ? Colors.white : Colors.black,
        iconTheme: IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
        hintColor: Colors.grey,
        hoverColor: Colors.white);
  }
}
