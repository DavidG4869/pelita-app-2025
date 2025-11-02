import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pelita_app/services/autoupdate_svc.dart';
import 'package:pelita_app/services/bookmark_svc.dart';
import 'package:pelita_app/services/cantatadeo_svc.dart';
import 'package:pelita_app/services/email_svc.dart';
import 'package:pelita_app/services/navigation_svc.dart';
import 'package:pelita_app/services/onesignal_svc.dart';
import 'package:pelita_app/services/pelita_blog_svc.dart';
import 'package:pelita_app/services/renungan_svc.dart';
import 'package:pelita_app/services/settings_svc.dart';

import 'models/enums.dart';

final svc = GetIt.instance;

void initContainer() {
  svc.registerLazySingleton(() => OneSignalService(svc(), svc()));
  svc.registerLazySingleton(() => EmailService());
  svc.registerLazySingleton(() => AutoUpdateService());
  svc.registerLazySingleton(() => SettingsService());
  svc.registerLazySingleton(() => BookmarkService());
  svc.registerLazySingleton(() => NavigationService());
  svc.registerLazySingleton(() => RenunganService(svc(), svc(), '2,8'));
  svc.registerLazySingleton(() => PWRenunganService(svc(), svc()));
  svc.registerLazySingleton(() => PWArticleService(svc(), svc()));
  svc.registerLazySingleton(() => PelitaBlogService(svc(), svc(), FormatType.nonspecific));
  svc.registerLazySingleton(() => CantataDeoService(svc(), svc()));
  svc.registerLazySingleton(() => PelitaVideoPostService(svc(), svc()));
  svc.registerLazySingleton(() => PelitaArticlePostService(svc(), svc()));
  svc.registerLazySingleton(() => PelitaPodcastPostService(svc(), svc()));
  svc.registerLazySingleton(() => Dio());
}
