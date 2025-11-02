import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pelita_app/provider/dark_theme_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GriiWebView extends StatefulWidget {
  const GriiWebView({Key key, @required this.content}) : super(key: key);

  final String content;

  @override
  _GriiWebViewState createState() => _GriiWebViewState();
}

class _GriiWebViewState extends State<GriiWebView> {
  WebViewController _wvController;
  double _height = 50;
  String stylingCSS;
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreferences.getDarkThemeSettings();
    if (themeChangeProvider.darkTheme) {
      stylingCSS = 'body{background-color: #151515;color: white;} a{color: white}';
    }
  }

  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  Future<bool> _willPopCallback(WebViewController controller) async {
    controller.loadUrl('https://www.google.com/'); /* or you can use controller.reload() to just reload the page */
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    return WillPopScope(
      onWillPop: () => _willPopCallback(_wvController),
      child: Container(
        height: _height,
        child: WebView(
          initialUrl: widget.content,
          //debuggingEnabled: true,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          onWebViewCreated: (controller) async {
            this._wvController = controller;
            var html = """<!DOCTYPE html>
        <html>
          <head>
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <style>
                $stylingCSS

                p{
                  font-size: 18px;
                  text-align: left;
                  line-height: 150%;
                }
              </style>
          </head>
          <body style='"margin: 0; padding: 0;'>
            <div>
              ${widget.content}
            </div>
          </body>
        </html>""";
            await this._wvController.loadUrl(
                Uri.dataFromString(html, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
          },
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (String url) async {
            //remove any comment
            double height =
                double.parse(await this._wvController.evaluateJavascript('document.documentElement.scrollHeight;'));
            setState(() {
              _height = height;
            });
            try {
              await _wvController.evaluateJavascript('''
                 var audio = document.getElementsByTagName("audio");
                 var iframe = document.getElementsByTagName("iframe");
                 var featureImage = document.getElementsByTagName("img");

                 if(featureImage.length > 0){
                   featureImage[0].style.width = '100%';
                   featureImage[0].style.height = '50%';
                   //featureImage[0].style.aspectRatio = '4';
                 }
                 if(iframe.length > 0){
                   iframe[0].width = '100%';
                   //iframe[0].setAttribute('webkitallowfullscreen', '');
                 }
                 if(audio.length > 0){
                     audio[0].autoPlay = true;
                     audio[0].play();
                  }
                  ''');
            } on PlatformException catch (e) {
              print(e);
            }
          },
        ),
      ),
    );
  }
}
