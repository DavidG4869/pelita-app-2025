import 'package:flutter/material.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/provider/dark_theme_provider.dart';
import 'package:pelita_app/utils/widget_utils.dart';
import '../all_posts_page.dart';
import 'package:pelita_app/screens/post_screen.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/cantatadeo_svc.dart';
import 'package:pelita_app/utils/date_utils.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';
import 'package:pelita_app/widgets/overlayed_container.dart';
import 'package:pelita_app/widgets/post_container.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';
import 'package:provider/provider.dart';

class BlogsScreen extends StatelessWidget {
  CantataDeoService _wpService = svc<CantataDeoService>();
  bool isLoadingPost = false;

  BlogsScreen({Key key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: PelitaAppBar(screenType: ScreenType.cantatadeo, screenTitle: 'Cantate Deo'),
      bottomNavigationBar: PelitaBottomNavBar(),
      endDrawer: AppDrawer(screenType: ScreenType.cantatadeo),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 5),
                //decoration: BoxDecoration(color: Colors.white),
                child: Image.asset(themeChange.darkTheme ? Resources.cantateDeoLogoDark : Resources.cantateDeoLogo,
                    fit: BoxFit.contain)),
            FutureBuilder(
                future: Future.wait([_wpService.getPosts(page: 4, offset: 3), _wpService.getPosts(page: 6)]),
                builder: (BuildContext context, AsyncSnapshot<List<List<PostSchema>>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [
                      _buildFeatureBlogLayout(context, snapshot.data[0]),
                      _buildVerticalLayout(context, snapshot.data[1]),
                    ]);
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error happened ${snapshot.error}'));
                  }
                  return WidgetUtils.loadingIndicatorWithPaddingTop();
                })
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBlogLayout(BuildContext context, List<PostSchema> posts) {
    return Container(
      height: MediaQuery.of(context).size.height * .22,
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, i) {
          return OverlayedContainer(
            date: "${DateTime.parse(posts[i].date).formatString(withYear: true)}",
            image: "${posts[i].embedded.media[0].sourceUrl}",
            title: "${posts[i].getTitle()}",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostScreen<CantataDeoService>(id: posts[i].id)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context, List<PostSchema> posts) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Latest Videos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostListPage<CantataDeoService>(
                                screenType: ScreenType.cantatadeo,
                                screenTitle: 'Cantate Deo',
                                postType: 'Videos',
                              )),
                    );
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(87, 124, 177, 1)),
                  )),
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 0.3,
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, i) {
              return PostContainer(
                date: "${DateTime.parse(posts[i].date).formatString(withYear: true)}",
                image: "${posts[i].embedded.media[0].sourceUrl}",
                title: "${posts[i].getTitle()}",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostScreen<CantataDeoService>(id: posts[i].id)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
