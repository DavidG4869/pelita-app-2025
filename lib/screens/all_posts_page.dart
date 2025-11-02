import 'package:flutter/material.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/screens/post_screen.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/cantatadeo_svc.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/utils/widget_utils.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';
import 'package:pelita_app/widgets/post_container.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/date_utils.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';

class PostListPage<T extends PelitaBlogService> extends StatefulWidget {
  ScreenType screenType;
  String screenTitle;
  String postType;

  PostListPage({Key key, @required this.screenType, @required this.screenTitle, @required this.postType})
      : super(key: key) {}
  @override
  _PostListPageState createState() => _PostListPageState<T>();
}

class _PostListPageState<T extends PelitaBlogService> extends State<PostListPage<T>>
    with AutomaticKeepAliveClientMixin {
  T _wpService;
  Future<List<PostSchema>> _featurePosts;
  List<PostSchema> _allPosts;
  bool _isLoadingPost = false;
  bool _noMorePosts = false;

  @override
  void initState() {
    _wpService = svc<T>();
    _featurePosts = this._wpService.loadMore(initial: true);

    super.initState();
  }

  @override
  void dispose() {
    _wpService.clear();

    super.dispose();
  }

  Color getLoadButtonColor() {
    if (this.widget.screenType == ScreenType.pelita_youth) {
      return Color(0xffF37224);
    } else if (this.widget.screenType == ScreenType.pelita_wanita) {
      return Color.fromRGBO(148, 69, 154, 1);
    }
    return Color.fromRGBO(87, 124, 177, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PelitaAppBar(screenType: this.widget.screenType, screenTitle: this.widget.screenTitle),
      endDrawer: AppDrawer(screenType: this.widget.screenType),
      body: Container(
          child: FutureBuilder(
              future: this._featurePosts,
              builder: (BuildContext context, AsyncSnapshot<List<PostSchema>> snapshot) {
                if (snapshot.hasData) {
                  this._allPosts = snapshot.data;
                  return SingleChildScrollView(child: _buildVerticalLayout());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error happened ${snapshot.error}'));
                }
                return Center(child: CircularProgressIndicator());
              })),
      bottomNavigationBar: PelitaBottomNavBar(),
    );
  }

  Widget _buildVerticalLayout() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "All " + this.widget.postType,
              //style: Theme.of(context).textTheme.headline6,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 0.3,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: this._allPosts.length + 1,
            itemBuilder: (context, i) {
              var posts = this._allPosts;
              return (i == (posts.length))
                  ? (_isLoadingPost ? Center(child: RefreshProgressIndicator()) : _buildLoadMorebutton())
                  : PostContainer(
                      date: "${DateTime.parse(posts[i].date).formatString(withYear: true)}",
                      image: "${posts[i].embedded.media[0].sourceUrl}",
                      title: "${posts[i].getTitle()}",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          if (this.widget.screenType == ScreenType.pelita_youth) {
                            return PostScreen<PelitaBlogService>(id: posts[i].id);
                          }
                          return PostScreen<CantataDeoService>(id: posts[i].id);
                        }),
                      ),
                    );
            },
          )
        ],
      ),
    );
  }

  Widget _buildLoadMorebutton() {
    return Offstage(
        offstage: _noMorePosts,
        child: Container(
          decoration: BoxDecoration(gradient: WidgetUtils.linearGradientByType(this.widget.screenType)),
          child: FlatButton(
            child: Text("Lebih lanjut", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              setState(() => this._isLoadingPost = true);
              var posts = await _wpService.loadMore();

              setState(() {
                _noMorePosts = ! _wpService.hasMore;
                this._isLoadingPost = false;
                this._allPosts = posts;
              });
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
