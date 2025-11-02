import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pelita_app/screens/home_screen.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/navigation_svc.dart';
import 'package:uni_links/uni_links.dart' as UniLink;
import 'package:pelita_app/utils/post_schema_utils.dart';

StreamSubscription<Uri> deepLinkSub;
String uri;

Future initDeeplinkLauncher() async {
  try {
    //singleton
    if (deepLinkSub == null) {
      deepLinkSub = UniLink.getUriLinksStream().listen((Uri url) async {
        await openPelitaUrl(url.toString());
      }, onError: (err) => print('some error $err'));
    }

    //should be opened once
    if (uri == null) {
      uri = await UniLink.getInitialLink();

      await openPelitaUrl(uri);
    }
  } on PlatformException {
    print("PlatformException");
  } on Exception {
    print('Exception thrown');
  }
}

dynamic openPelitaUrl(String uri) async {
  if (uri != null) {
    var nav = svc<NavigationService>();
    if (uri.contains('youth')) {
      return nav.navigateTo('/pelita_youth');
    } else if (uri.contains('wanita')) {
      return nav.navigateTo('/pelita_wanita');
    } else if (uri.contains('cantate')) {
      return nav.navigateTo('/cantatadeo');
    } else if (uri.contains('kontak')) {
      return nav.navigateTo('/kontak');
    }
  }
  return HomeScreen();
}

dynamic openPostUrl(String channel, int postId) {
  if (postId != null) {
    var nav = svc<NavigationService>();
    nav.openPost(channel, postId);
  }
}
