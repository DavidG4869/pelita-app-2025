import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/models/renungan.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/bookmark_svc.dart';
import 'package:pelita_app/services/renungan_svc.dart';
import 'package:pelita_app/utils/widget_utils.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/grii_webview.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';
import 'package:wordpress_api/wordpress_api.dart';

class RenunganScreen extends StatefulWidget {
  final int id;

  RenunganScreen({Key key, @required this.id}) : super(key: key);

  @override
  _RenunganScreenState createState() => _RenunganScreenState();
}

class _RenunganScreenState extends State<RenunganScreen> {
  Future<Renungan> _renunganData;
  PostSchema _content;
  bool _isLoading = true;
  bool _bookmarked = null;
  BookmarkService _bookmarkSvc;
  Color _iconColor = Color(0xffAE64B4);

  @override
  void initState() {
    var wpService = svc<RenunganService>();
    _renunganData = wpService.getById(this.widget.id);
    _bookmarkSvc = svc<BookmarkService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PelitaAppBar(screenType: ScreenType.pelita_wanita, screenTitle: 'Pelita Wanita'),
        body: _buildPostLayout(),
        endDrawer: AppDrawer(
          screenType: ScreenType.pelita_wanita,
        ),
      ),
    );
  }

  Widget _buildPostLayout() {
    return FutureBuilder(
        future: _renunganData,
        builder: (context, AsyncSnapshot<Renungan> postData) {
          Renungan renungan = postData.data;

          if (postData.hasData) {
            this._content = renungan.content;
            WidgetsBinding.instance.addPostFrameCallback((_) => this.setState(() {
                  this._isLoading = false;
                }));
            var isRenungan = _content.categories.toString().contains('2');
            return Column(children: [
              Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Text(
                        _content.getTitle(),
                        //_content.categories.toString(),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                      ),
                      isRenungan
                          ? _buildRenunganNavigation(renungan, context)
                          : Column(children: [
                              SizedBox(height: 10),
                              Text(_content.getDate(),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ))
                            ]),
                    ],
                  )),
              Expanded(
                child: _buildContentLayout(context, renungan.content),
              ),
            ]);
          } else if (postData.hasError) {
            return Center(child: Text('Error happened ${postData.error}'));
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  Row _buildRenunganNavigation(Renungan renungan, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Visibility(
            visible: renungan.nextPost.id != renungan.post.id,
            child: Icon(
              CupertinoIcons.arrow_left_circle,
              color: this._iconColor,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RenunganScreen(id: renungan.nextPost.id))),
        ),
        Text(_content.getDate(addDay: const Duration(days: 0)),
            style: TextStyle(fontSize: 15, color: Color(0xff818181))),
        IconButton(
          icon: Visibility(
            visible: renungan.previousPost != null,
            child: Icon(
              CupertinoIcons.arrow_right_circle,
              color: this._iconColor,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RenunganScreen(id: renungan.previousPost.id))),
        ),
      ],
    );
  }

  Widget _buildContentLayout(BuildContext context, PostSchema post) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        shrinkWrap: false,
        children: <Widget>[
          _buildActionButtons(MainAxisAlignment.end),
          GriiWebView(content: '''<div style='${WidgetUtils.htmlTextStyle}'>${post.content['rendered']}</div>'''),
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
      icon:
          Icon((this._bookmarked ?? _content.sticky) ? Icons.bookmark : Icons.bookmark_outline, color: this._iconColor),
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
}
