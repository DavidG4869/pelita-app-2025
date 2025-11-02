import 'package:flutter/material.dart';
import 'package:pelita_app/services/settings_svc.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  SettingsService darkThemePreferences = SettingsService();

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreferences.saveSettings(SettingsService.DARK_THEME_SETTINGS, value);
    notifyListeners();
  }
}
