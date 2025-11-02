import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const DARK_THEME_SETTINGS = 'settingDarkTheme';

  saveSettings(String settingKey, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(settingKey, value);
  }

  Future<List<bool>> getAllNotificationSettings() async {
    List<bool> notifList = List<bool>();
    final prefs = await SharedPreferences.getInstance();
    final keys = ['settingsPostYouth', 'settingsPostWanita', 'settingsPostCantatedeo'];
    keys.forEach((key) {
      notifList.add(prefs.getBool(key) ?? true);
    });
    return notifList;
  }

  Future<bool> getDarkThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(
          DARK_THEME_SETTINGS,
        ) ??
        false;
  }
}
