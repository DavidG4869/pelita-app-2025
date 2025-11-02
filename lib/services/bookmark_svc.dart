import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:pelita_app/utils/post_schema_utils.dart';

class BookmarkService {
  Future save(PostSchema post) async {
    final prefs = await SharedPreferences.getInstance();
    final key = post.getTitle();
    prefs.setString(key, json.encode(post.copyForBookMark()));
  }

  Future<List<PostSchema>> getAll() async {
    List<PostSchema> posts = List<PostSchema>();
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    keys.forEach((key) {
      // Don't add any setting shared preferences
      if (!key.contains('setting')) {
        var jsonData = Map<String, dynamic>.from(jsonDecode(prefs.getString(key)));
        posts.add(PostSchema.fromJson(jsonData));
      }
    });
    return posts;
  }

  Future<bool> isBookmarked(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
