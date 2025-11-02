import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pelita_app/consts/theme_data.dart';
import 'package:pelita_app/provider/dark_theme_provider.dart';
import 'package:pelita_app/screens/cantatedeo/blogs_screen.dart';
import 'package:pelita_app/screens/bookmark_screen.dart';
import 'package:pelita_app/screens/contact_page.dart';
import 'package:pelita_app/screens/home_screen.dart';
import 'package:pelita_app/screens/pemuda/pemuda_screen.dart';
import 'package:pelita_app/screens/wanita/pwanita_home.dart';
import 'package:pelita_app/screens/settings_screen.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/autoupdate_svc.dart';
import 'package:pelita_app/services/navigation_svc.dart';
import 'package:pelita_app/services/onesignal_svc.dart';
import 'models/enums.dart';
import 'package:provider/provider.dart';

void main() {
  initContainer();
  //initDeeplinkLauncher();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreferences.getDarkThemeSettings();
  }

  // getCanUpdate() async {
  //   final checkVersion = CheckVersion(context: context);
  //   final appStatus = await checkVersion.getVersionStatus();
  //   if (appStatus.canUpdate) {
  //     checkVersion.showUpdateDialog("net.pelita.app", "id1549987065", message: 'Hi');
  //   }
  //   print("canUpdate ${appStatus.canUpdate}");
  //   print("localVersion ${appStatus.localVersion}");
  //   print("appStoreLink ${appStatus.appStoreUrl}");
  //   print("storeVersion ${appStatus.storeVersion}");
  // }

  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    svc<OneSignalService>().init();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return themeChangeProvider;
          })
        ],
        child: Consumer<DarkThemeProvider>(builder: (context, themeData, child) {
          return MaterialApp(
            title: 'Pelita',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: HomeScreen(),
            builder: (context, child) {
              final currentScale = MediaQuery.of(context).textScaleFactor;
              Resources.appTextScale = max(0.5, min(1.1, currentScale));
              return MediaQuery(
                child: child,
                data: MediaQuery.of(context).copyWith(textScaleFactor: Resources.appTextScale),
              );
            },
            navigatorKey: svc<NavigationService>().navigatorKey,
            routes: <String, WidgetBuilder>{
              '/home': (BuildContext context) => HomeScreen(),
              '/pelita_youth': (BuildContext context) => PemudaScreen(),
              '/pelita_wanita': (BuildContext context) => PWanitaHome(),
              '/bookmarks': (BuildContext context) => BookmarkScreen(),
              '/cantatadeo': (BuildContext context) => BlogsScreen(),
              '/settings': (BuildContext context) => SettingScreen(),
              '/kontak': (BuildContext context) => ContactPage()
            },
          );
        }));
  }
}
