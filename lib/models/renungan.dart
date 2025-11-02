import 'package:flutter/foundation.dart';
import 'package:wordpress_api/wordpress_api.dart';

class Renungan {
  PostSchema post;
  PostSchema prevId;
  PostSchema nextId;
  DateTime renunganDate;

  Renungan({@required this.post, @required this.prevId, @required this.nextId, @required renunganDate});

  PostSchema get content => this.post;
  PostSchema get previousPost => this.prevId;
  PostSchema get nextPost => this.nextId;
  DateTime get date => this.renunganDate;
}
