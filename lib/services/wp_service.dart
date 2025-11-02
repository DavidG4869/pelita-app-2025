import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/services/bookmark_svc.dart';
import 'package:pelita_app/utils/text_utils.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WPService {
  final _baseSite = "https://pelita.net/";
  final _apiPath = "wp-json/wp/v2/";
  final _cantataDeoSite = "https://www.cantatedeoministry.org";

  final Dio httpClient;
  final BookmarkService bookmarkService;

  WPService(this.httpClient, this.bookmarkService);

  final postsArgs = {"_fields": "id,link,title,featured_media,_links", "_embed": "wp:featuredmedia"};

  final featurePostsArgs = {
    "_fields": "id,link,title,featured_media,_links,date,excerpt,format",
    "_embed": "wp:featuredmedia"
  };

  @protected
  Future<PostSchema> getPostByIdInternal(int id, {PostType type = PostType.blog}) async {
    final post = await getAsyncInternal(endpoint: "posts/$id", args: {'_embed': 'wp:featuredmedia'}, type: type);
    var rawJson = post.data as Map<String, dynamic>;
    final cleanTitle = TextUtils.removeAllHtmlTags(rawJson['title']['rendered']);
    rawJson['sticky'] = await bookmarkService.isBookmarked(cleanTitle);
    return PostSchema.fromJson(rawJson);
  }

  String _subsite(PostType type) {
    switch (type) {
      case PostType.wanita:
        return "wanita";
      default:
        return "";
    }
  }

  @protected
  Future<List<PostSchema>> getPostsInternal(PostType type, {Map<String, dynamic> args, FormatType formatType}) async {
    var endpoint = 'posts';
    switch (formatType) {
      case FormatType.video:
        endpoint = 'videos';
        break;
      case FormatType.article:
        endpoint = 'articles';
        break;
      case FormatType.podcast:
        endpoint = 'podcasts';
        break;
    }
    final res = await getAsyncInternal(endpoint: endpoint, args: args, type: type);
    return (res.data as List).cast<Map<String, dynamic>>().map((e) => PostSchema.fromJson(e)).toList();
  }

  @protected
  Future<WPResponse> getAsyncInternal({@required String endpoint, PostType type, Map<String, dynamic> args}) async {
    if (type == PostType.cantataDeo) {
      httpClient.options.baseUrl = '$_cantataDeoSite/';
    } else {
      httpClient.options.baseUrl = '$_baseSite/${_subsite(type)}/';
    }
 
    final res = await httpClient.get('$_apiPath/$endpoint', queryParameters: args);


    return WPResponse(
      data: res.data,
      statusCode: res.statusCode,
    );
  }
}
