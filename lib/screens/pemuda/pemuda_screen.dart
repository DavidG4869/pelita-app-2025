import 'package:flutter/material.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/screens/all_posts_page.dart';
import 'package:pelita_app/screens/post_screen.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/utils/widget_utils.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';
import 'package:pelita_app/widgets/overlayed_container.dart';
import 'package:pelita_app/widgets/post_container.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';

class PemudaScreen extends StatelessWidget {
  PelitaBlogService _videoSvc;
  PelitaBlogService _articleSvc;
  PelitaBlogService _pcastSvc;
  Radius _radius = Radius.circular(5);
  Color _txtColor = Color(0xffF37224);
  ScrollController _controller;

  PemudaScreen({Key key})
      : _videoSvc = svc<PelitaVideoPostService>(),
        _articleSvc = svc<PelitaArticlePostService>(),
        _pcastSvc = svc<PelitaPodcastPostService>(),
        _controller = ScrollController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PelitaAppBar(screenTitle: 'Pelita Pemuda', screenType: ScreenType.pelita_youth),
      bottomNavigationBar: PelitaBottomNavBar(),
      endDrawer: AppDrawer(screenType: ScreenType.pelita_youth),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(children: [
          Container(
              height: 100,
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(Resources.pelitaYouthLogo), fit: BoxFit.contain))),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                    onTap: () => _controller.jumpTo(280),
                    child: _buildTopButton(context, 'Video', BorderRadius.only(topLeft: _radius, bottomLeft: _radius))),
                InkWell(
                    onTap: () => _controller.jumpTo(580),
                    child: _buildTopButton(context, 'Podcast', BorderRadius.zero)),
                InkWell(
                    onTap: () => _controller.jumpTo(930),
                    child: _buildTopButton(
                        context, 'Article', BorderRadius.only(topRight: _radius, bottomRight: _radius))),
              ],
            ),
          ),
          FutureBuilder(
            future:
                Future.wait([_videoSvc.getPosts(page: 3), _articleSvc.getPosts(page: 3), _pcastSvc.getPosts(page: 3)]),
            builder: (context, AsyncSnapshot<List<List<PostSchema>>> snapshot) {
              if (snapshot.hasData) {
                var features = [snapshot.data[0][0], snapshot.data[1][0], snapshot.data[2][0]];
                var videos = snapshot.data[0];
                var articles = snapshot.data[1];
                var podcasts = snapshot.data[2];
                return Column(children: [
                  _buildFeatureBlogsLayout(context, features),
                  SizedBox(height: 15),
                  _buildVerticalLayout(context, videos, 'Latest Videos'),
                  SizedBox(height: 15),
                  _buildVerticalLayout(context, podcasts, 'Latest Podcasts'),
                  SizedBox(height: 15),
                  _buildVerticalLayout(context, articles, 'Latest Articles'),
                ]);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error happened ${snapshot.error}'));
              }

              return WidgetUtils.loadingIndicatorWithPaddingTop();
            },
          )
        ]),
      ),
    );
  }

  Widget _buildTopButton(BuildContext context, String text, BorderRadius bradius) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(border: Border.all(color: _txtColor), borderRadius: bradius),
        child: Center(
          child: Text(text,
              style: TextStyle(
                fontSize: 20,
                color: _txtColor,
              )),
        ));
  }

  Widget _buildFeatureBlogsLayout(BuildContext context, List<PostSchema> features) {
    return Container(
      height: MediaQuery.of(context).size.height * .22,
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(),
        itemCount: features.length,
        itemBuilder: (context, i) {
          var posts = features;
          return OverlayedContainer(
            date: "${features[i].getDate()}",
            image: "${features[i].embedded.media[0].sourceUrl}",
            title: "${features[i].getTitle()}",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostScreen(id: posts[i].id)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context, List<PostSchema> data, String title) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  String pageTitle = title.split(" ")[1];
                  if (pageTitle[0] == 'A') {
                    return PostListPage<PelitaArticlePostService>(
                        screenType: ScreenType.pelita_youth, screenTitle: 'Pelita Ministries', postType: pageTitle);
                  } else if (pageTitle[0] == 'V') {
                    return PostListPage<PelitaVideoPostService>(
                        screenType: ScreenType.pelita_youth, screenTitle: 'Pelita Ministries', postType: pageTitle);
                  }
                  return PostListPage<PelitaPodcastPostService>(
                      screenType: ScreenType.pelita_youth, screenTitle: 'Pelita Ministries', postType: pageTitle);
                }),
              ),
              child: Text(
                "View All",
                style: TextStyle(fontWeight: FontWeight.bold, color: this._txtColor),
              ),
            ),
          ]),
          Divider(
            thickness: 0.3,
            color: Colors.grey,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, i) => PostContainer(
                    date: "${data[i].getDate()}",
                    image: "${data[i].embedded.media[0].sourceUrl}",
                    title: "${data[i].getTitle()}",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostScreen(id: data[i].id)),
                    ),
                  ))
        ],
      ),
    );
  }
}
