import 'package:flutter/material.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/utils/widget_utils.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/blog_item_expandable.dart';
import 'package:wordpress_api/wordpress_api.dart';

class PostListPage<T extends PelitaBlogService> extends StatefulWidget {
  @override
  _PostListPageState createState() => _PostListPageState<T>();
}

class _PostListPageState<T extends PelitaBlogService> extends State<PostListPage<T>>
    with AutomaticKeepAliveClientMixin {
  T _wpService;
  Future<List<PostSchema>> _featurePosts;
  List<PostSchema> _allPosts;
  bool isLoadingPost = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PelitaAppBar(screenType: ScreenType.pelita_youth, screenTitle: 'Pelita Pemuda'),
        endDrawer: AppDrawer(screenType: ScreenType.pelita_youth),
        body: Container(
            child: FutureBuilder(
                future: this._featurePosts,
                builder: (BuildContext context, AsyncSnapshot<List<PostSchema>> snapshot) {
                  if (snapshot.hasData) {
                    this._allPosts = snapshot.data;
                    return _buildVerticalLayout();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error happened ${snapshot.error}'));
                  }

                  return Center(child: CircularProgressIndicator());
                })));
  }

  Widget _buildVerticalLayout() {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: this._allPosts.length + 1,
        itemBuilder: (context, i) {
          var posts = this._allPosts;
          return (i == (posts.length))
              ? (isLoadingPost
                  ? Center(child: RefreshProgressIndicator())
                  : Container(
                      decoration: BoxDecoration(gradient: WidgetUtils.linearGradientByType(ScreenType.homepage)),
                      child: FlatButton(
                        child: Text("Lebih lanjut", style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          setState(() => this.isLoadingPost = true);
                          var posts = await _wpService.loadMore(initial: false);
                          setState(() {
                            this.isLoadingPost = false;
                            this._allPosts = posts;
                          });
                        },
                      ),
                    ))
              : BlogItemExpandable(post: posts[i]);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
