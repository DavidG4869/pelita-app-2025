import 'package:dio/dio.dart';
import 'package:dio/src/dio.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/services/bookmark_svc.dart';
import 'package:pelita_app/services/wp_service.dart';
import 'package:wordpress_api/wordpress_api.dart';

class PelitaBlogService extends WPService {
  final int _page = 10;
  int _currentOffset = 0;
  List<PostSchema> _postList;
  final FormatType formatType;
  PostType postType;

  bool _canLoadMore = true;

  PelitaBlogService(Dio httpClient, BookmarkService bkmSvc, this.formatType, {this.postType = PostType.blog})
      : _postList = List(),
        super(httpClient, bkmSvc);

  Future<List<PostSchema>> getPosts({int page, int offset}) async {
    var args = new Map<String, String>.from(featurePostsArgs);
    if (page != null) args['per_page'] = page.toString();

    if (offset != null) args['page'] = ((offset ~/ page) + 1).toString();
    try {
      return await getPostsInternal(this.postType, args: args, formatType: formatType);
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        return [];
      } else
        throw e;
    }
  }

  Future<PostSchema> getById(int id) async {
    return await super.getPostByIdInternal(id, type: this.postType);
  }

  Future<List<PostSchema>> loadMore({bool initial, int initialOffset = 0}) async {
    if (!_canLoadMore) {
      return this._postList;
    }
    if (initial == true) {
      _currentOffset = initialOffset;
    } else {
      _currentOffset += _page;
    }

    var posts = await getPosts(page: _page, offset: _currentOffset);
    this._canLoadMore = posts.length > 0;
    posts.forEach((item) => this._postList.add(item));
    return this._postList;
  }

  Future<PostSchema> getContactForm() async {
    var res = await this.getAsyncInternal(endpoint: "pages", args: {'slug': 'kontak', '_fields': 'id,title,content'});
    var pages = (res.data as List).cast<Map<String, dynamic>>().map((e) => PostSchema.fromJson(e)).toList();
    return pages[0];
  }

  bool get hasMore => _canLoadMore;
  
  clear() {
    _postList.clear();
    _canLoadMore = true;
  }
}

class PelitaVideoPostService extends PelitaBlogService {
  final int _page = 10;
  int _currentOffset = 0;
  List<PostSchema> _postList;

  PelitaVideoPostService(Dio httpClient, BookmarkService bkmSvc)
      : _postList = List(),
        super(httpClient, bkmSvc, FormatType.video);
}

class PelitaArticlePostService extends PelitaBlogService {
  final int _page = 10;
  int _currentOffset = 0;
  List<PostSchema> _postList;

  PelitaArticlePostService(Dio httpClient, BookmarkService bkmSvc)
      : _postList = List(),
        super(httpClient, bkmSvc, FormatType.article);
}

class PelitaPodcastPostService extends PelitaBlogService {
  final int _page = 10;
  int _currentOffset = 0;
  List<PostSchema> _postList;

  PelitaPodcastPostService(Dio httpClient, BookmarkService bkmSvc)
      : _postList = List(),
        super(httpClient, bkmSvc, FormatType.podcast);
}
