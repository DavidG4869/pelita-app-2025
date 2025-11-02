import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  final String username = "griisydney.org@gmail.com ";
  final String password = 'Reformed_21';
  final String recipient = 'info@pelita.net';
  SmtpServer _smtpServer;

  EmailService() {
    _smtpServer = gmail(username, password);
  }

  Future sendFeedback({@required String subject, String name, String from, String text}) async {
    String deviceInfo = await _getDeviceInfo();

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add(this.recipient) //recipent email
      ..ccRecipients.add('dbudi.darma@gmail.com') //cc Recipents emails
      //..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject = subject //subject of the email
      ..text = '''
         Pelita App Feedback:
            Device: $deviceInfo
            Locale: ${Platform.localeName}
            Timezone: ${DateTime.now().timeZoneOffset}
            Name: $name
            Email: $from
            Feedback: $text  ''';

    try {
      final sendReport = await send(message, _smtpServer);
      print('Message sent: ' + sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  Future<String> _getDeviceInfo() async {
    String deviceInfo;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      deviceInfo = 'Android $release (SDK $sdkInt), $manufacturer $model';
      // Android 9 (SDK 28), Xiaomi Redmi Note 7
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.utsname;
      var model = iosInfo.model;
      deviceInfo = '$systemName $version, $name $model';
      // iOS 13.1, iPhone 11 Pro Max iPhone
    }
    return deviceInfo;
  }
}
