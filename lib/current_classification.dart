import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentClassification extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)
    // mode: LaunchMode.externalApplication,
    ); {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    _getMemberNum().then((value) {
      final String memberNum = value;
      _controller.text = memberNum;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Current Classifications',
        ),
        backgroundColor: Color(0xFF00681B),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 200.0,
                child: TextField(
                  autofocus: true,
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'USPSA Member #'),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,

                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('[\\-|,\\ ]'),
                    ),
                  ],
//                    decoration:
//                        InputDecoration.collapsed(hintText: 'USPSA Member #:'),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(width: 1, color: Color(0xFF00681B)),
                    primary: Colors.white),
                child: Text(
                  'Go',
                  style: TextStyle(
                    color: Color(0xFF00681B),
                  ),
                ),
                onPressed: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');

                  _saveMemberNum('${_controller.text}');
                  _launchUrl(Uri.parse('https://scsa.org/classification/${_controller.text}'));

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveMemberNum(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('memberNumber', value);
  }

  Future<String> _getMemberNum() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('memberNumber') ?? '';
  }
}
