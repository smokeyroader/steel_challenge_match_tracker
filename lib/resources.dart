import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'current_classification.dart';

//
class Resources extends StatefulWidget {
  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) ;
    {
      // throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            'Resources for Steel Challenge Shooters',
          ),
        ),
        backgroundColor: Color(0xFF00681B),
      ),
      body: WillPopScope(
        onWillPop: () async {
//          Hide keyboard when any back button is pressed.
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          return true;
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(6.0),
          child: FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(
                            Uri.parse(
                              'https://www.teammatchtracker.com',
                            ),
                          );
                        },
                        child: DisplayText(
                          text: 'Team Match Tracker Info and Signup',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CurrentClassification();
                              },
                            ),
                          );
                        },
                        child: DisplayText(
                          text: 'My SCSA Classification Record',
                        ),
                      ),
                    ),
//
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(
                            Uri.parse(
                              'https://www.amazon.com/You-Feel-Need-Speed-Challenge/dp/1548141046/ref=sr_1_1?s=books&ie=UTF8&qid=1510059473&sr=1-1&keywords=do+you+feel+the+need+for+speed',
                            ),
                          );
                        },
                        child: DisplayText(
                          text: 'Steel Challenge Training Manual',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(
                            Uri.parse(
                              'https://steelshootbanners.com/index.html',
                            ),
                          );
                        },
                        child: DisplayText(
                          text: 'Steel Challenge Training Aids',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(
                            Uri.parse(
                              'https://www.ssusa.org/articles/2018/7/5/steel-challenge-lets-talk-about-classification/',
                            ),
                          );
                        },
                        child: DisplayText(
                          text: 'The SCSA Classification System',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(
                            Uri.parse(
                              'https://steelchallenge.com/steel-challenge-Rules-Home.php',
                            ),
                          );
                        },
                        child: DisplayText(
                          text: 'Steel Challenge Online Rule Book',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(
                            Uri.parse(
                              'https://practiscore.com',
                            ),
                          );
                        },
                        child: DisplayText(
                          text: 'Practiscore Home',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(
                            Uri.parse(
                              'https://mysasp.com',
                            ),
                          );
                        },
                        child: DisplayText(
                          text: 'Scholastic Action Shooting Program',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayText extends StatelessWidget {
  const DisplayText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00681B),
      ),
    );
  }
}
