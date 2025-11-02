import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/autoupdate_svc.dart';
import 'package:pelita_app/services/deeplink_svc.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/utils/widget_utils.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';
import 'package:pelita_app/widgets/home_card.dart';
import 'package:pelita_app/widgets/latest_post.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:provider/provider.dart';
import 'package:pelita_app/provider/dark_theme_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key) {
    WidgetUtils.portraitModeOnly();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<PostSchema>> _futureData;
  PelitaBlogService _blogSvc;
  AutoUpdateService _autoUpdateSvc;

  @override
  void initState() {
    _blogSvc = svc<PelitaBlogService>();
    _autoUpdateSvc = svc<AutoUpdateService>();
    _futureData = _blogSvc.getPosts(page: 1, offset: 0);
    initDeeplinkLauncher();
    this._autoUpdateSvc.checkUpdate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
        appBar: PelitaAppBar(screenTitle: 'Pelita Ministries', screenType: ScreenType.homepage),
        endDrawer: AppDrawer(
          screenType: ScreenType.homepage,
        ),
        bottomNavigationBar: PelitaBottomNavBar(
          selectedIndex: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                height: (1 + Resources.appTextScale) * 120,
                margin: EdgeInsets.only(bottom: 20),
                child: FutureBuilder(
                    future: _futureData,
                    builder: (BuildContext context, AsyncSnapshot<List<PostSchema>> snapshot) {
                      if (snapshot.hasData) {
                        return LatestPostWidget(post: snapshot.data.first);
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error happened ${snapshot.error}'));
                      }
                      return Center(child: CircularProgressIndicator());
                    })),
            Center(
              child: Container(
                //color: Color(0xffF5F5F5),
                width: MediaQuery.of(context).size.width * 0.85,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    HomeCard(title: 'Pelita Pemuda', imagePath: Resources.pelitaYouthLogo, launchPath: '/pelita_youth'),
                    HomeCard(
                        title: 'Pelita Wanita',
                        imagePath: themeChange.darkTheme ? Resources.pelitaWanitaLogoDark : Resources.pelitaWanitaLogo,
                        launchPath: '/pelita_wanita'),
                    HomeCard(
                        title: 'Cantate Deo',
                        imagePath: themeChange.darkTheme ? Resources.cantateDeoLogoDark : Resources.cantateDeoLogo,
                        launchPath: '/cantatadeo')
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
