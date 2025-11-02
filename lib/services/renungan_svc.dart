import 'package:dio/src/dio.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/models/renungan.dart';
import 'package:pelita_app/services/bookmark_svc.dart';
import 'package:pelita_app/services/wp_service.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/date_utils.dart';

class RenunganService extends WPService {
  final int _page = 20;
  bool _canLoadMore = true;
  int _currentOffset = 0;
  List<PostSchema> _postList;
  //final String _quietPlaceCategory = '2';
  final String postCategory;
  //final FormatType formatType;

  RenunganService(Dio httpClient, BookmarkService bkmSvc, this.postCategory)
      : _postList = List(),
        super(httpClient, bkmSvc);

  Future<List<PostSchema>> _getByDate(DateTime date, PostType type) async {
    DateTime publishDate = date.getPublishDate();

    var posts = await this._getByRange(publishDate, publishDate.getNextDate(1).subtract(Duration(minutes: 1)), type);

    return posts;
  }

  Future<List<PostSchema>> _getByRange(DateTime fromDate, DateTime toDate, PostType type) async {
    var posts = await this.getPostsInternal(type, args: {
      "_fields": "id,title,date",
      'after': '${fromDate.toIso8601String()}',
      'before': '${toDate.toIso8601String()}',
      'categories': postCategory
    });

    return posts;
  }

  Future<List<PostSchema>> getLatest() async {
    var today = DateTime.now().getDate();
    var posts = await _getByRange(today.getPrevDate(10), today, PostType.wanita);
    return posts;
  }

  Future<PostSchema> getSummaryByDate(DateTime date) async {
    var posts = await _getByDate(date, PostType.wanita);

    //get previous day
    if (posts.length < 1) {
      date = date.getPrevDate(1);
      posts = await _getByDate(date, PostType.wanita);
    }

    return posts.length > 0 ? posts[0] : null;
  }

  Future<Renungan> getById(int id) async {
    PostSchema post = await super.getPostByIdInternal(id, type: PostType.wanita);

    var renunganDate = DateTime.parse(post.date).getDate().getNextDate(1);

    var posts = await Future.wait<PostSchema>(
        [getSummaryByDate(renunganDate.getPrevDate(1)), getSummaryByDate(renunganDate.getNextDate(1))]);
    return Renungan(post: post, prevId: posts[0], nextId: posts[1], renunganDate: renunganDate);
  }

  Future<List<PostSchema>> getPosts({int page, int offset}) async {
    var args = new Map<String, String>.from(featurePostsArgs);
    if (page != null) args['per_page'] = page.toString();
    if (offset != null) args['offset'] = offset.toString();
    args['categories'] = postCategory;
    final posts = await getPostsInternal(PostType.wanita, args: args);
    return posts;
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

  clear() {
    _postList.clear();
    _canLoadMore = true;
  }

  bool get hasMore => _canLoadMore;
}

class PWRenunganService extends RenunganService {
  List<PostSchema> _postList;

  PWRenunganService(Dio httpClient, BookmarkService bkmSvc)
      : _postList = List(),
        super(httpClient, bkmSvc, '2');
}

class PWArticleService extends RenunganService {
  List<PostSchema> _postList;

  PWArticleService(Dio httpClient, BookmarkService bkmSvc)
      : _postList = List(),
        super(httpClient, bkmSvc, '8');
}
