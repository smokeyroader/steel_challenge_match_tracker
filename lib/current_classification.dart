import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Constants.dart';

class CurrentClassification extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  CurrentClassification({super.key});

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {}
    {
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
        title: const Text(
          'Current Classifications',
        ),
        backgroundColor: Constants.mtGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 200.0,
                child: TextField(
                  autofocus: true,
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'USPSA Member #'),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('[\\-|,\\ ]'),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(), backgroundColor: Colors.white,
                    side: const BorderSide(width: 1, color: Constants.mtGreen)),
                child: const Text(
                  'Go',
                  style: TextStyle(
                    color: Constants.mtGreen,
                  ),
                ),
                onPressed: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');

                  _saveMemberNum(_controller.text);
                  _launchUrl(Uri.parse(
                      'https://scsa.org/classification/${_controller.text}'));

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
