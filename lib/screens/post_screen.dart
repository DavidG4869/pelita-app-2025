import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom_parsing.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/bookmark_svc.dart';
import 'package:pelita_app/services/cantatadeo_svc.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/services/wp_service.dart';
import 'package:pelita_app/utils/widget_utils.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';
import 'package:pelita_app/widgets/grii_webview.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:pelita_app/utils/post_schema_utils.dart';
import 'package:pelita_app/widgets/app_drawer.dart';

class PostScreen<T extends PelitaBlogService> extends StatefulWidget {
  final int id;
  PostType type;

  PostScreen({Key key, @required this.id}) : super(key: key) {}

  @override
  _PostScreenState<T> createState() => _PostScreenState<T>();
}

class _PostScreenState<T extends PelitaBlogService> extends State<PostScreen<T>> {
  Future<PostSchema> _data;
  bool _bookmarked = null;
  PostSchema _content;

  BookmarkService _bookmarkSvc;
  bool isCantataDeo;
  Color get _iconColor => this.isCantataDeo ? Color.fromRGBO(87, 124, 177, 1) : Color(0xffF37224);

  @override
  void initState() {
    var wpService = svc<T>();
    _data = wpService.getById(this.widget.id);
    _bookmarkSvc = svc<BookmarkService>();
    isCantataDeo = T == typeOf<CantataDeoService>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PelitaAppBar(
            screenType: isCantataDeo ? ScreenType.cantatadeo : ScreenType.pelita_youth,
            screenTitle: isCantataDeo ? 'Cantate Deo' : 'Pelita Pemuda'),
        endDrawer: AppDrawer(
          screenType: isCantataDeo ? ScreenType.cantatadeo : ScreenType.pelita_youth,
        ),
        bottomNavigationBar: PelitaBottomNavBar(),
        body: FutureBuilder(
            future: _data,
            builder: (context, AsyncSnapshot<PostSchema> postData) {
              if (postData.hasData) {
                _content = postData.data;
                return buildPostLayout();
              } else if (postData.hasError) {
                return Center(child: Text('Error happened ${postData.error}'));
              }

              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget buildPostLayout() {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 15),
            //color: Color(0xfff5f5f5),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  _content.getTitle(),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ),
              SizedBox(height: 5),
              Text(_content.getDate(),
                  style: TextStyle(
                    fontSize: 15,
                  )),
            ])),
        _buildContentLayout(context)
      ]),
    );
  }

  Widget _buildContentLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          _buildActionButtons(MainAxisAlignment.end),
          GriiWebView(content: '''<div style='${WidgetUtils.htmlTextStyle}'>${_content.content['rendered']}</div>'''),
          _buildActionButtons(MainAxisAlignment.start),
        ],
      ),
    );
  }

  Row _buildActionButtons(MainAxisAlignment alignment) {
    return Row(mainAxisAlignment: alignment, children: [
      _buildBookmarkButton(),
      _buildShareButton(),
    ]);
  }

  Widget _buildBookmarkButton() {
    return FlatButton.icon(
      label: Text('Bookmark'),
      textColor: this._iconColor,
      icon: Icon(this._hasBookMark ? Icons.bookmark : Icons.bookmark_outline, color: this._iconColor),
      onPressed: () async {
        if (_bookmarked == null) _bookmarked = _content.sticky;

        if (!_bookmarked)
          await this._bookmarkSvc.save(_content);
        else
          await this._bookmarkSvc.remove(_content.getTitle());

        setState(() {
          this._bookmarked = !this._bookmarked;
        });
      },
    );
  }

  Widget _buildShareButton() {
    return FlatButton.icon(
        label: Text('Share'),
        textColor: this._iconColor,
        icon: Platform.isAndroid
            ? Icon(Icons.share, color: this._iconColor)
            : Icon(CupertinoIcons.share, color: this._iconColor),
        onPressed: () {
          Share.share(_content.link, subject: _content.getTitle());
        });
  }

  bool get _hasBookMark => this._bookmarked ?? _content.sticky;
}
