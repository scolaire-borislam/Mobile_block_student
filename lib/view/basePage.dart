import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobile_block_student_adm/common/CommonSetting.dart';
import '../model/application.dart';



abstract class BasePageFragment extends StatefulWidget {
  Function(String, Map<String, dynamic>)
      callbackNavigate; // Notice the variable type

  BasePageFragment({super.key, required this.callbackNavigate});
}

abstract class BasePageFramentState<T extends StatefulWidget> extends State<T>
    with CommonSetting {
  //String get pageTitle; // Abstract getter for the page title

  bool isReadOnlyApplication(Application app) {

    if (RegExp(r"SUBMITTED|APPROVED|REJECTED").hasMatch(app.status ?? "")) {
      return true;
    }
    // if (app.status=="SUBMITTED" ||
    //     app.status=="APPROVED" ||
    //     app.status=="REJECTED")
    //   {
    //    return true;
    //   }

    return false;
  }
  void openImagePreviewSheet(String url ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          color: Colors.white,
          child: Center(
            child:
              Image(
                  image:NetworkImage(
                    url!,
                  ),
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Text('Failed to load image');
                },
                height: 300
              )
          ),
        );
      },
    );
  }

  void openInAppBrowser(String url) {
    //String imageUrl = 'https://picsum.photos/250?image=9';

    // WebView webView = WebView(
    //   initialUrl: imageUrl,
    // );

    WebViewController wvController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    WebViewWidget webView = WebViewWidget(controller: wvController);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Scaffold(body: webView)),
    );
  }


}
