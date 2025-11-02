import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pelita_app/services/navigation_svc.dart';
import 'settings_svc.dart';
import 'deeplink_svc.dart';
import 'dart:async';

class OneSignalService {
  NavigationService navService;
  SettingsService setService;

  OneSignalService(this.navService, this.setService);

  Future init() async {
    //disable location
    OneSignal.shared.setLocationShared(false);

    // OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    //   if (!changes.from.subscribed && changes.to.subscribed) {
    //     // sendTags here will only be called once, when the user becomes subscribed to push.
    //     OneSignal.shared.sendTags({
    //       'Youth': true,
    //       'Wanita': true,
    //       'Cantatedeo': true,
    //     });
    //   }
    // });

    //update the tags based on the notification setting
    List<bool> boolSettings = await setService.getAllNotificationSettings();
    Map<String, bool> notificationSettings = {
      'Youth': boolSettings[0],
      'Wanita': boolSettings[1],
      'Cantatedeo': boolSettings[2],
    };
    notificationSettings.forEach((k, v) => OneSignal.shared.sendTag(k, v));

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    // control what page to open when notification clicked
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult pushData) {
      pushData.notification.payload.launchUrl = "";
      var wpData = pushData.notification.payload.additionalData;

      if (pushData.notification.payload.title == 'Cantate Deo') {
        openPostUrl('cantatedeo', wpData['postId']);
      } else if (pushData.notification.payload.title.contains('Wanita')) {
        openPostUrl('wanita', wpData['postId']);
      } else {
        openPostUrl('youth', wpData['postId']);
      }

      // a notification has been received
    });

    // Initialize Onesignal push (USING APP ID FOR NOW)
    await OneSignal.shared.init("efa1d558-95a4-44ca-b9b6-28f3b15ee59b", iOSSettings: {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.inAppLaunchUrl: true,
    });
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    OSPermissionSubscriptionState status = await OneSignal.shared.getPermissionSubscriptionState();
    var canReceiveNotification =
        status.subscriptionStatus.subscribed && status.subscriptionStatus.userSubscriptionSetting;
    print("One Signal Notification status: $canReceiveNotification");
  }
}
