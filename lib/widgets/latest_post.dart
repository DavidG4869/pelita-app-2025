import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:pelita_app/screens/post_screen.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';
import 'package:pelita_app/models/enums.dart';

class LatestPostWidget extends StatelessWidget {
  final PostSchema post;
  const LatestPostWidget({@required this.post, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          child: Stack(children: [
            Positioned.fill(child: Center(child: Image.asset(cupertinoActivityIndicatorSmall))),
            Positioned.fill(
                child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
              child: FadeInImage.memoryNetwork(
                  image: this.post.embedded.media[0].sourceUrl, placeholder: kTransparentImage, fit: BoxFit.cover),
            )),
            Positioned(
              right: 10,
              bottom: 5,
              child: FlatButton(
                  onPressed: () => _openPost(context),
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      decoration:
                          BoxDecoration(gradient: LinearGradient(colors: [Color(0xfffdbe69), Color(0xffdf7326)])),
                      child: Text(
                        'Latest Post',
                        //style: TextStyle(color: Colors.white),
                      ))),
            )
          ]),
        ),
        InkWell(
          onTap: () => _openPost(context),
          child: Container(
            height: Resources.appTextScale * 120,
            width: MediaQuery.of(context).size.width,
            //color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 15, left: 20, right: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.getFormatText().toUpperCase(),
                    style: TextStyle(color: Resources.textGreyColor),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(this.post.getTitle(),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5))),
                  Text('Pelita Pemuda, ${post.getDate()}', style: TextStyle(color: Resources.textGreyColor))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future _openPost(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostScreen<PelitaArticlePostService>(id: post.id)),
    );
  }
}
