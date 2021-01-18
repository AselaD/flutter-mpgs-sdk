import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'parameters.dart';

class Check3DSWebView extends StatefulWidget {
  final String title = "Verify 3DS Authentication";
  final String html;

  Check3DSWebView({@required this.html});

  @override
  State<StatefulWidget> createState() => _Check3DSWebView();
}

class _Check3DSWebView extends State<Check3DSWebView> {
  Map parsedACSResult;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print(url);
      _handleUriChange(url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
//        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context).pop(this.parsedACSResult);
            },
          ),
          title: new Text(
            this.widget.title,
            textAlign: TextAlign.center,
          ),
        ),
        url: new Uri.dataFromString(this.widget.html, mimeType: 'text/html')
            .toString(),
//      initialChild: Center(
//        child: CircularProgressIndicator(),
//      ),
//        body: WebView(
//          onPageFinished: (url) {
//            this._handleUriChange(url);
//          },
//          javascriptMode: JavascriptMode.unrestricted,
//          onWebViewCreated: (WebViewController webViewController) {
//            _controller.complete(webViewController);
//          },
//          initialUrl:
//              Uri.dataFromString(this.widget.html, mimeType: 'text/html')
//                  .toString(),
//        )
    );
  }

  void _handleUriChange(String url) {
    print("URL :" + url);
    final Uri uri = Uri.parse(url);
    if (uri.isScheme(GatewayResponse.REDIRECT_SCHEMA) && uri.host == GatewayResponse.REDIRECT_HOST) {
      final params = uri.queryParameters;
      params.forEach((key, value) {
        if (key == GatewayResponse.ACS_RESULT) {
          this.parsedACSResult = json.decode(value);
          Navigator.of(context).pop(this.parsedACSResult);
          return;
        }
      });
    }
  }
}
