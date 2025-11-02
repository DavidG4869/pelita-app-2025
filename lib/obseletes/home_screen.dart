import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/models/renungan.dart';
import 'package:pelita_app/screens/post_screen.dart';
import 'package:pelita_app/screens/wanita/renungan_screen.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/utils/date_utils.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/blog_item_expandable.dart';
import 'package:pelita_app/widgets/overlayed_container.dart';
import 'package:pelita_app/widgets/post_container.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic _wpService;
  PelitaBlogService _blogStream;

  @override
  void didChangeDependencies() {
    _wpService = svc<dynamic>();
    _blogStream = svc<PelitaBlogService>();

    super.didChangeDependencies();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Pelita App')),
        drawer: AppDrawer(),
        body: Container(
            child: FutureBuilder(
                future: this._wpService.fetch(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return StreamBuilder(
                      stream: null,
                      builder: (context, streamData) {
                        if (snapshot.hasData) {
                          this._blogStream.loadMore(initial: true);
                          return SingleChildScrollView(
                            child: Column(children: [
                              _buildFeatureBlogLayout(context, snapshot),
                              _buildRenunganWanitaLayout(context, snapshot),
                              if (streamData.hasData) _buildVerticalLayout(context, streamData)
                            ]),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error happened ${snapshot.error}'));
                        }

                        return Center(child: CircularProgressIndicator());
                      });
                })));
  }

  Widget _buildFeatureBlogLayout(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(),
        itemCount: snapshot.data.featurePosts.length,
        itemBuilder: (context, i) {
          var posts = snapshot.data.featurePosts;
          return OverlayedContainer(
            date: "${DateTime.parse(posts[i].date).formatString(withYear: true)}",
            image: "${posts[i].embedded.media[0].sourceUrl}",
            title: "${posts[i].getTitle()}",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostScreen(id: posts[i].id)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRenunganWanitaLayout(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Renungan Wanita",
            style: Theme.of(context).textTheme.headline6,
          ),
          Container(
            height: MediaQuery.of(context).size.height * .20,
            margin: const EdgeInsets.symmetric(vertical: 15.0),
            child: ListView.builder(
              controller: PageController(viewportFraction: 0.87),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.renungans.length,
              itemBuilder: (context, i) {
                var posts = snapshot.data.renungans;
                return OverlayedContainer(
                  date: "${DateTime.parse(posts[i].date).formatString()}",
                  title: "${posts[i].getTitle()}",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RenunganScreen(id: posts[i].id)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context, AsyncSnapshot<List<PostSchema>> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "All Posts",
            style: Theme.of(context).textTheme.headline6,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length + 1,
            itemBuilder: (context, i) {
              var posts = snapshot.data;
              return (i == (posts.length))
                  ? Container(
                      color: Colors.greenAccent,
                      child: FlatButton(
                        child: Text("Load More"),
                        onPressed: () {
                          _blogStream.loadMore(initial: false);
                        },
                      ),
                    )
                  : BlogItemExpandable(post: posts[i]);
            },
          )
        ],
      ),
    );
  }
}

