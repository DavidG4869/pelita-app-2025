import 'package:flutter/widgets.dart';
import 'package:forceupdate/forceupdate.dart';

class AutoUpdateService {
  bool _initialized = false;

  Future checkUpdate(context) async {
    AppVersionStatus appStatus;

    if (!this._initialized) {
      this._initialized = true;
      final checkVersion = CheckVersion(context: context);
      appStatus = await checkVersion.getVersionStatus();
      if (appStatus.canUpdate) {
        checkVersion.showUpdaterDialog(appStatus.appStoreUrl,
            message: 'Versi baru ${appStatus.storeVersion} tersedia', titleText: 'Update App');
      }
    }
  }
}
