import 'package:flutter/material.dart';

enum ScreenType { homepage, pelita_youth, pelita_wanita, bookmarks, cantatadeo, settings }
enum PostType { blog, wanita, cantataDeo }

enum FormatType { video, article, podcast, nonspecific }

class Resources {
  // Light Logo
  static const String cantateDeoLogo = 'images/CantateDeoLogoApp.png';
  static const String pelitaWanitaLogo = 'images/pelitaWanitaLogoApp.png';
  static const String pelitaYouthLogo = 'images/pelitaLogoApp.png';
  static const String griiAppLogo = 'images/GriiSydneyNavLogoApp-Black.png';

  // Dark Logo
  static const String cantateDeoLogoDark = 'images/DarkCantateDeoLogoApp.png';
  static const String pelitaWanitaLogoDark = 'images/DarkpelitaWanitaLogoApp.png';

  static const Color textGreyColor = Color(0xff818181);
  static double appTextScale;
}

Type typeOf<T>() => T;
