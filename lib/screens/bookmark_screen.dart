import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/screens/post_screen.dart';
import 'package:pelita_app/screens/wanita/renungan_screen.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/bookmark_svc.dart';
import 'package:pelita_app/services/cantatadeo_svc.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';
import 'package:pelita_app/widgets/post_container.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';
import 'package:pelita_app/utils/date_utils.dart';

class BookmarkScreen extends StatefulWidget {
  BookmarkScreen({Key key}) : super(key: key) {}

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  Future<List<PostSchema>> bookmarks;
  Color _iconColor(PostType postType) => postType == PostType.cantataDeo
      ? Color.fromRGBO(87, 124, 177, 1)
      : (postType == PostType.blog ? Color(0xffF37224) : Color(0xffAE64B4));

  @override
  void initState() {
    bookmarks = svc<BookmarkService>().getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: PelitaAppBar(screenType: ScreenType.bookmarks, screenTitle: 'Pelita Ministries'),
            endDrawer: AppDrawer(
              screenType: ScreenType.bookmarks,
            ),
            bottomNavigationBar: PelitaBottomNavBar(
              selectedIndex: 1,
            ),
            body: Container(
              margin: EdgeInsets.all(10),
              child: FutureBuilder(
                  future: this.bookmarks,
                  builder: (context, AsyncSnapshot<List<PostSchema>> snapshot) {
                    if (snapshot.hasData) {
                      var posts = snapshot.data;
                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'Bookmarks Items (${snapshot.data?.length ?? 0})',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.3,
                        ),
                        Expanded(child: _buildVerticalListView(posts)),
                      ]);
                    } else {
                      Column(children: [
                        Text(
                          'Bookmarks 0',
                          //style: Theme.of(context).textTheme.headline6,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.3,
                        ),
                      ]);
                    }
                  }),
            )));
  }

  Widget _buildVerticalListView(List<PostSchema> posts) {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, i) {
          if (posts.length == 0)
            return Center(child: Text("Tidak ada bookmark"));
          else {
            PostType postType = PostType.values.firstWhere((element) => element.toString() == posts[i].type);
            return PostContainer(
                date: "${DateTime.parse(posts[i].date).formatString(withYear: true)}",
                image: posts[i].embedded != null ? "${posts[i].embedded?.media[0].sourceUrl}" : null,
                title: "${posts[i].getTitle()}",
                type: postType,
                trailing: Padding(
                  padding: EdgeInsets.all(0),
                  child: IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: _iconColor(postType),
                      ),
                      onPressed: () async {
                        await svc<BookmarkService>().remove(posts[i].getTitle());
                        posts.removeWhere((element) => element.getTitle() == posts[i].getTitle());

                        setState(() {});
                      }),
                ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => postType == PostType.wanita
                            ? RenunganScreen(id: posts[i].id)
                            : (postType == PostType.cantataDeo
                                ? PostScreen<CantataDeoService>(id: posts[i].id)
                                : PostScreen<PelitaBlogService>(id: posts[i].id)),
                      ),
                    ));
          }
        });
  }
}
