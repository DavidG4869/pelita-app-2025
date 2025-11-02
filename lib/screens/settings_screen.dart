import 'package:flutter/material.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/provider/dark_theme_provider.dart';
import 'package:pelita_app/services/settings_svc.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../service_locator.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<bool> notificationSettings;

  getAllNotification() async {
    var allNotifs = await svc<SettingsService>().getAllNotificationSettings();
    setState(() {
      notificationSettings = allNotifs;
    });
  }

  @override
  void initState() {
    getAllNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        appBar: PelitaAppBar(screenTitle: "Settings", screenType: ScreenType.pelita_youth),
        endDrawer: AppDrawer(screenType: ScreenType.settings),
        bottomNavigationBar: PelitaBottomNavBar(),
        body: Column(children: [
          // FutureBuilder<bool>(
          //   future: subscribed(),
          //   builder: (context, snapshot) {
          //     return Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          //         child: SwitchListTile(
          //           title: Text('Post Notification'),
          //           value: snapshot.data ?? initialSetup(),
          //           onChanged: (value) {
          //             saveSettings("settingIsSubscribed", value);
          //             setState(() {
          //               OneSignal.shared.setSubscription(value);
          //             });
          //           },
          //           secondary: const Icon(Icons.notifications_active_rounded),
          //           activeTrackColor: Color.fromRGBO(253, 226, 135, 1),
          //           activeColor: Color.fromRGBO(243, 111, 33, 1),
          //           inactiveTrackColor: Colors.grey[300],
          //           inactiveThumbColor: Colors.grey,
          //         ));
          //   },
          // ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: SwitchListTile(
                title: Text('Dark Theme'),
                value: themeChange.darkTheme,
                onChanged: (value) {
                  themeChange.darkTheme = value;
                },
                secondary: Icon(themeChange.darkTheme ? Icons.brightness_2_rounded : Icons.wb_sunny_rounded),
                activeTrackColor: Color.fromRGBO(253, 226, 135, 1),
                activeColor: Color.fromRGBO(243, 111, 33, 1),
                inactiveTrackColor: Colors.grey[300],
                inactiveThumbColor: Colors.grey,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: Text('Post Notification'),
              leading: const Icon(Icons.notifications_active_rounded),
              subtitle: Text('Get Notified on new posts', style: TextStyle(color: Theme.of(context).hintColor)),
            ),
          ),
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 20),
                  child: SwitchListTile(
                    title: Text('Pelita Pemuda'),
                    value: notificationSettings[0],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings[0] = value;
                      });
                      value ? OneSignal.shared.sendTag("Youth", value) : OneSignal.shared.deleteTag("Youth");
                      svc<SettingsService>().saveSettings("settingsPostYouth", value);
                    },
                    secondary: ImageIcon(AssetImage('images/PelitaSideNavLogoApp-Black.png')),
                    activeTrackColor: Color.fromRGBO(253, 226, 135, 1),
                    activeColor: Color.fromRGBO(243, 111, 33, 1),
                    inactiveTrackColor: Colors.grey[300],
                    inactiveThumbColor: Colors.grey,
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 40, right: 20),
                  child: SwitchListTile(
                    title: Text('Pelita Wanita'),
                    value: notificationSettings[1],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings[1] = value;
                      });
                      value ? OneSignal.shared.sendTag("Wanita", value) : OneSignal.shared.deleteTag("Wanita");
                      svc<SettingsService>().saveSettings("settingsPostWanita", value);
                    },
                    secondary: ImageIcon(AssetImage('images/PelitaWanitaSideNavLogoApp-Black.png')),
                    activeTrackColor: Color.fromRGBO(253, 226, 135, 1),
                    activeColor: Color.fromRGBO(243, 111, 33, 1),
                    inactiveTrackColor: Colors.grey[300],
                    inactiveThumbColor: Colors.grey,
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 40, right: 20),
                  child: SwitchListTile(
                    title: Text('Cantatedeo'),
                    value: notificationSettings[2],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings[2] = value;
                      });
                      value ? OneSignal.shared.sendTag("Cantatedeo", value) : OneSignal.shared.deleteTag("Cantatedeo");
                      svc<SettingsService>().saveSettings("settingsPostCantatedeo", value);
                    },
                    secondary: ImageIcon(AssetImage('images/CantateDeoNavLogoApp-Black.png')),
                    activeTrackColor: Color.fromRGBO(253, 226, 135, 1),
                    activeColor: Color.fromRGBO(243, 111, 33, 1),
                    inactiveTrackColor: Colors.grey[300],
                    inactiveThumbColor: Colors.grey,
                  )),
            ],
          ),
        ]));
  }
}
