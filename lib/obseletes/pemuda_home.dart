import 'package:flutter/material.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/obseletes/post_list_page.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/navigation_svc.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/utils/widget_utils.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';

class PemudaHome extends StatefulWidget {
  const PemudaHome({Key key}) : super(key: key);

  @override
  _PemudaHomeState createState() => _PemudaHomeState();
}

class _PemudaHomeState extends State<PemudaHome> {
  PageController _pageController;

  @override
  initState() {
    _pageController = PageController();
    super.initState();
  }

  List<Widget> _screens = [
    PostListPage<PelitaVideoPostService>(),
    PostListPage<PelitaArticlePostService>(),
    PostListPage<PelitaPodcastPostService>()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
      ),
      endDrawer: AppDrawer(screenType: ScreenType.pelita_youth),
      bottomNavigationBar: PelitaBottomNavBar(),
    );
  }
}
