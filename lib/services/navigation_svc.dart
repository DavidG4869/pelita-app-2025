import 'package:flutter/material.dart';
import 'package:pelita_app/screens/post_screen.dart';
import 'package:pelita_app/screens/wanita/renungan_screen.dart';
import 'cantatadeo_svc.dart';
import 'pelita_blog_svc.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  Future<dynamic> openPost(String uri, int postId) {
    if (uri.contains('cantatedeo')) {
      return navigatorKey.currentState
          .push(MaterialPageRoute(builder: (context) => PostScreen<CantataDeoService>(id: postId)));
    } else if (uri.contains('wanita')) {
      return navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => RenunganScreen(id: postId)));
    }
    return navigatorKey.currentState
        .push(MaterialPageRoute(builder: (context) => PostScreen<PelitaBlogService>(id: postId)));
  }
}
