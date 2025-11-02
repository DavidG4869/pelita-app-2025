import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pelita_app/obseletes/post_list_page.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';

class Pemuda2Home extends StatelessWidget {
  const Pemuda2Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
      BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Video'),
      BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Article'),
      BottomNavigationBarItem(icon: Icon(Icons.headset), label: 'Podcast'),
    ]),
    tabBuilder: (context,index){
            switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child:  PostListPage<PelitaVideoPostService>(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: PostListPage<PelitaArticlePostService>(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: PostListPage<PelitaPodcastPostService>(),
              );
            });
          default: return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: PostListPage<PelitaVideoPostService>(),
              );
            });
        }
      },);
  }
}
