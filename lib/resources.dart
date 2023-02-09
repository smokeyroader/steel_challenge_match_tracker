import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'current_classification.dart';
import 'Constants.dart';

//
class Resources extends StatefulWidget {
  const Resources({Key key}) : super(key: key);

  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {}
    {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const FittedBox(
          child: Text(
            'Resources for Steel Challenge Shooters',
          ),
        ),
        backgroundColor: Constants.mtGreen,
      ),
      body: WillPopScope(
        onWillPop: () async {
//          Hide keyboard when any back button is pressed.
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          return true;
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(6.0),
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
                        child: const DisplayText(
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
                        child: const DisplayText(
                          text: 'My SCSA Classification Record',
                        ),
                      ),
                    ),


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
                        child: const DisplayText(
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
                        child: const DisplayText(
                          text: 'Steel Challenge Dry Fire Banners',
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       _launchUrl(
                    //         Uri.parse(
                    //           'https://gofastdontsuck.net/swag-store/search?keyword=steel%20challenge',
                    //         ),
                    //       );
                    //     },
                    //     child: const DisplayText(
                    //       text: 'Steel Challenge Dry Fire Stickers',
                    //     ),
                    //   ),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       _launchUrl(
                    //         Uri.parse(
                    //           'https://www.lasershot.com/products/product/81-steel-challenge',
                    //         ),
                    //       );
                    //     },
                    //     child: const DisplayText(
                    //       text: 'Steel Challenge Laser Dry Fire',
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(
                            Uri.parse(
                              'https://www.lasrapp.com',
                            ),
                          );
                        },
                        child: const DisplayText(
                          text: 'LASR Dynamic Dry Fire',
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
                        child: const DisplayText(
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
                        child: const DisplayText(
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
                        child: const DisplayText(
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
                        child: const DisplayText(
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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Constants.mtGreen,
      ),
    );
  }
}
