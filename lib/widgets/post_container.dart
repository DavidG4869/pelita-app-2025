import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/services/wp_service.dart';

class PostContainer extends StatelessWidget {
  final onTap;
  final String title, date, image;
  final PostType type;
  final Widget trailing;

  const PostContainer({
    Key key,
    this.onTap,
    this.title,
    this.date,
    this.image,
    this.type,
    this.trailing
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: ListTile(     
        onTap: onTap,
        trailing: trailing,
        leading: (type == PostType.wanita ?? PostType.blog) ? _buildAssetImageWidget() : _buildNetworkImageWidget(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "$title",
              style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Text(
              "$date",
              style: Theme.of(context).textTheme.subtitle2.copyWith(color: Color(0xff818181)),
            ),
          ],
        ),
      ),
    );
  }

  ClipRRect _buildNetworkImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: FadeInImage.assetNetwork(
          image: "$image", fit: BoxFit.cover, width: 100, placeholder: cupertinoActivityIndicatorSmall),
    );
  }

  Widget _buildAssetImageWidget() {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.pink[200]), borderRadius: BorderRadius.circular(9)),
        child: ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.pink[50], BlendMode.dst),
            child: Image.asset(
              Resources.pelitaWanitaLogo,
              fit: BoxFit.cover,
            )));
  }
}
