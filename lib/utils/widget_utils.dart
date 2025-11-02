import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pelita_app/models/enums.dart';

class WidgetUtils {
  static LinearGradient linearGradientByType(ScreenType screenType) {
    return LinearGradient(
        tileMode: TileMode.clamp,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _getColor(screenType));
  }

  static List<Color> _getColor(ScreenType screenType) {
    if (screenType == ScreenType.pelita_wanita) {
      return [Color.fromRGBO(242, 181, 247, 1), Color.fromRGBO(148, 69, 154, 1)];
    } else if (screenType == ScreenType.cantatadeo) {
      return [Color.fromRGBO(129, 163, 209, 1), Color.fromRGBO(87, 124, 177, 1)];
    }
    return [Color.fromRGBO(253, 226, 135, 1), Color.fromRGBO(243, 111, 33, 1)];
  }

  static LinearGradient linearGradientBackground() {
    return LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.blue[900], Colors.green[900], Colors.red[900]]);
  }

  static Widget loadingIndicatorWithPaddingTop() =>
      Padding(padding: EdgeInsets.only(top: 180), child: Center(child: CircularProgressIndicator()));

  static String get htmlTextStyle => 'font-family:"-apple-system","sans-serif";font-size:12pt;text-align:justify';

  static Future portraitModeOnly() async => await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
  static Future enableRotationMode() async => await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
}
