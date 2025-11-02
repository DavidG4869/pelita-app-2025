import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/navigation_svc.dart';
import 'package:pelita_app/services/renungan_svc.dart';
import 'package:share/share.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  NavigationService _navigator;
  ScreenType screenType;

  AppDrawer({@required this.screenType, Key key}) : super(key: key) {
    _navigator = svc<NavigationService>();
  }

  // Link to be update later
  String getShareMessage() {
    return 'Download Pelita Ministries App \n Android: https://play.google.com/store/apps/details?id=net.pelita.app&hl=en_AU&gl=US \n iOS: https://apps.apple.com/au/app/pelita-ministry-app/id1549987065';
  }

  String get _downloadLink {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=org.griisydney.app&hl=en_AU&gl=US';
    }
    return 'https://apps.apple.com/au/app/grii-sydney-app/id1525471552';
  }

  bool isScreen(ScreenType screenType) {
    return this.screenType == screenType;
  }

  _closeDrawer(context) => Scaffold.of(context).openEndDrawer();

  @override
  Widget build(BuildContext context) {
    bool isHomepage = isScreen(ScreenType.homepage);
    bool isPelitaYouth = isScreen(ScreenType.pelita_youth);
    bool isPelitaWanita = isScreen(ScreenType.pelita_wanita);
    bool isCantataDeo = isScreen(ScreenType.cantatadeo);
    bool isBookmark = isScreen(ScreenType.bookmarks);
    bool isSettings = isScreen(ScreenType.settings);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: SafeArea(
        child: Container(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .15,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Image.asset(Resources.pelitaYouthLogo, fit: BoxFit.contain),
              ),
              Container(
                  decoration: isHomepage ? BoxDecoration(color: Color(0xffF37224)) : null,
                  child: ListTile(
                      leading: Icon(Icons.home, size: 30, color: isHomepage ? Theme.of(context).hoverColor : null),
                      title: Text(
                        'Home',
                        style: TextStyle(fontSize: 16, color: isHomepage ? Theme.of(context).hoverColor : null),
                      ),
                      onTap: () => _navigator.navigateTo('/home'))),
              Container(
                  decoration: BoxDecoration(color: isPelitaYouth ? Color(0xffF37224) : null),
                  child: ListTile(
                      leading: ImageIcon(AssetImage('images/PelitaSideNavLogoApp-Black.png'),
                          size: 30, color: isPelitaYouth ? Theme.of(context).hoverColor : null),
                      title: Text(
                        'Pelita Pemuda',
                        style: TextStyle(fontSize: 16, color: isPelitaYouth ? Theme.of(context).hoverColor : null),
                      ),
                      onTap: () => this.screenType == ScreenType.pelita_youth
                          ? _closeDrawer(context)
                          : _navigator.navigateTo('/pelita_youth'))),
              Container(
                  decoration: BoxDecoration(color: isPelitaWanita ? Color(0xffF37224) : null),
                  child: ListTile(
                      leading: ImageIcon(AssetImage('images/PelitaWanitaSideNavLogoApp-Black.png'),
                          size: 30, color: isPelitaWanita ? Theme.of(context).hoverColor : null),
                      title: Text(
                        'Pelita Wanita',
                        style: TextStyle(fontSize: 16, color: isPelitaWanita ? Theme.of(context).hoverColor : null),
                      ),
                      onTap: () => isPelitaWanita ? _closeDrawer(context) : _navigator.navigateTo('/pelita_wanita'))),
              Container(
                  decoration: BoxDecoration(color: isCantataDeo ? Color(0xffF37224) : null),
                  child: ListTile(
                      leading: ImageIcon(AssetImage('images/CantateDeoNavLogoApp-Black.png'),
                          size: 30, color: isCantataDeo ? Theme.of(context).hoverColor : null),
                      title: Text('Cantate Deo',
                          style: TextStyle(fontSize: 16, color: isCantataDeo ? Theme.of(context).hoverColor : null)),
                      onTap: () => isCantataDeo ? _closeDrawer(context) : _navigator.navigateTo('/cantatadeo'))),
              Container(
                  decoration: BoxDecoration(color: isSettings ? Color(0xffF37224) : null),
                  child: ListTile(
                      leading: Icon(Icons.settings, size: 30, color: isSettings ? Theme.of(context).hoverColor : null),
                      title: Text('Settings',
                          style: TextStyle(fontSize: 16, color: isSettings ? Theme.of(context).hoverColor : null)),
                      onTap: () => isSettings ? _closeDrawer(context) : _navigator.navigateTo('/settings'))),
              Container(
                  decoration: BoxDecoration(color: isBookmark ? Color(0xffF37224) : null),
                  child: ListTile(
                      leading: Icon(Platform.isAndroid ? Icons.bookmark : CupertinoIcons.bookmark,
                          size: 27, color: isBookmark ? Theme.of(context).hoverColor : null),
                      title: Text('Bookmark',
                          style: TextStyle(fontSize: 16, color: isBookmark ? Theme.of(context).hoverColor : null)),
                      onTap: () => isBookmark ? _closeDrawer(context) : _navigator.navigateTo('/bookmarks'))),
              ListTile(
                  leading: Icon(
                    Platform.isAndroid ? Icons.share : CupertinoIcons.share,
                    size: 27,
                  ),
                  title: Text('Share', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Share.share(getShareMessage(), subject: 'Install Pelita App');
                  }),
              ListTile(
                  leading: ImageIcon(
                    AssetImage(Resources.griiAppLogo),
                    size: 33,
                  ),
                  title: Text('Buka GRII Sydney App', style: TextStyle(fontSize: 16)),
                  onTap: () async {
                    await _lauchGriiApp();
                  }),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .15),
                child: FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Text('v${snapshot.data.version}'),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _lauchGriiApp() async {
    await canLaunch('griilink://') ? await launch('griilink://') : await launch(_downloadLink);
  }
}
