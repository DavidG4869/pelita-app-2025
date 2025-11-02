import 'package:dio/src/dio.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/services/bookmark_svc.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/services/wp_service.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CantataDeoService extends PelitaBlogService {
  CantataDeoService(Dio httpClient, BookmarkService bkmSvc)
      : super(httpClient, bkmSvc, FormatType.nonspecific, postType: PostType.cantataDeo);

  @override
  Future<List<PostSchema>> getPosts({
    int page,
    int offset,
  }) async {
    var args = new Map<String, String>.from(featurePostsArgs);
    if (page != null) args['per_page'] = page.toString();
    if (offset != null) args['offset'] = offset.toString();
    final posts = await getPostsInternal(this.postType, args: args);
    return posts;
  }
}
