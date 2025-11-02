import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/screens/post_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';

class BlogItemExpandable extends StatelessWidget {
  const BlogItemExpandable({
    Key key,
    @required this.post,
  }) : super(key: key);

  final PostSchema post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(7),
        color: Colors.white38),
      child: Column(children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostScreen(id: post.id)),
          ),
          child: Container(
              //padding: EdgeInsets.only(top:10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Stack(
                children: [
                  Center(child: Image.asset(cupertinoActivityIndicatorSmall)),
                  ClipRRect(borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    image: post.embedded.media[0].sourceUrl,
                    placeholder: kTransparentImage,
                  ),
                ),]
              )),
        ),
        Theme(data: Theme.of(context).copyWith(accentColor: Colors.black87),
          child: ExpansionTile(
            childrenPadding: EdgeInsets.zero,
            title: Text(post.getTitle(), style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 18))),
            leading: Icon(getIcon(post.getFormat())),
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      post.getSummaryText(),
                      style: Theme.of(context).textTheme.subtitle1,
                    )),
                Align(
                  alignment: Alignment.center,
                  //heightFactor: 0.9,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: MaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minWidth: 0,
                      color: Colors.white70,
                      child: Icon(
                        Icons.read_more,
                        color: Colors.black87,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostScreen(id: post.id)),
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
      ]),
    );
  }

  IconData getIcon(FormatType formatType) {
    return formatType == FormatType.video
        ? Icons.videocam
        : (formatType == FormatType.article ? Icons.article : Icons.headset);
  }
}
