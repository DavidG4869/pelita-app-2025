import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/services/wp_service.dart';
import 'package:pelita_app/utils/text_utils.dart';
import 'package:pelita_app/utils/date_utils.dart';
import 'package:wordpress_api/wordpress_api.dart';

extension PostSchemaUtil on PostSchema {
  String getTitle() => TextUtils.removeAllHtmlTags(this.title['rendered']);
  FormatType getFormat() =>
      this.format == "video" ? FormatType.video : (this.format == 'standard' ? FormatType.article : FormatType.podcast);
  String getFormatText() => this.format == 'standard' ? 'article' : this.format;
  
  PostSchema copyForBookMark() => PostSchema(
      id: this.id, date: this.date, title: this.title, embedded: this.embedded, type: _getTypeByLink(this.link));

  String _getTypeByLink(String link) {
    if (link.contains('/wanita/'))
      return PostType.wanita.toString();
    else if (link.contains('cantatedeoministry.org'))
      return PostType.cantataDeo.toString();
    else
      return PostType.blog.toString();
  }

  String getSummaryText() => TextUtils.removeAllHtmlTags(this.excerpt['rendered'])?.replaceAll('\n', '');
  String getDate({Duration addDay = const Duration(days: 0)}) => DateTime.parse(this.date).add(addDay).formatString(withYear: true);
}
