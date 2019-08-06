//import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/services.dart';
//import 'constants.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
//import 'database_helper.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:shared_preferences/shared_preferences.dart';
////import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//
//class CurrentClassifications extends StatefulWidget {
//  @override
//  _CurrentClassificationsState createState() => _CurrentClassificationsState();
//}
//
//class _CurrentClassificationsState extends State<CurrentClassifications> {
//  TextEditingController _controller = TextEditingController();
//
//  Future launchURL(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url,
//          forceSafariVC: true, forceWebView: false, enableJavaScript: true);
//    } else {
//      print('can\'t launch $url');
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _getMemberNum().then((value) {
//      final String memberNum = value;
//      _controller.text = memberNum;
//    });
////    return WebviewScaffold(
//      appBar: AppBar(
//        backgroundColor: Color(0xFF00681B),
//        title: TextField(
//          autofocus: true,
//          controller: _controller,
//          decoration: InputDecoration(
//              hintText: 'Enter USPSA Member #',
//              hintStyle: TextStyle(color: Colors.white)),
//          style: TextStyle(color: Colors.white, fontSize: 24.0),
//          keyboardType: TextInputType.text,
//          inputFormatters: [
//            BlacklistingTextInputFormatter(
//              RegExp('[\\-|,\\ ]'),
//            ),
//          ],
////                    decoration:
////                        InputDecoration.collapsed(hintText: 'USPSA Member #:'),
//        ),
//        actions: <Widget>[
//          InkWell(
//            child: Padding(
//              padding: const EdgeInsets.only(right: 24.0),
//              child: GestureDetector(
//                child: Icon(Icons.arrow_forward_ios),
//                onTap: () {
//                  SystemChannels.textInput.invokeMethod('TextInput.hide');
////                  memberNum = _controller.text;
//                  _saveMemberNum('${_controller.text}');
//                  launchURL(
//                      "https://www.steelchallenge.com/steel-challenge-classification.php?action=lookup&scsa=${_controller.text}");
//                },
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  Future<void> _saveMemberNum(String value) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    preferences.setString('memberNumber', value);
//  }
//
//  Future<String> _getMemberNum() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    return preferences.getString('memberNumber') ?? '';
//  }
//}
