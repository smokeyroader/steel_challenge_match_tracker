import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'current_classification.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class Resources extends StatefulWidget {
  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: true, forceWebView: false, enableJavaScript: true);
    } else {
      print('can\'t launch $url');
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
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _teamMT();
                        },
                        child: GestureDetector(
                          onTap: () {
                            launchURL("http://www.teammatchtracker.com");
                          },
                          child: Text(
                            'Team Match Tracker Info and Signup',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00681B),
                            ),
                          ),
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
                        child: Text(
                          'My SCSA Classification Record',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00681B),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          launchURL(
                              "http://www.ultimatesteelshooter.libsyn.com/website");
                        },
                        child: Text(
                          'The Ultimate Steel Shooter Podcast',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00681B),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          launchURL(
                              "https://www.amazon.com/You-Feel-Need-Speed-Challenge/dp/1548141046/ref=sr_1_1?s=books&ie=UTF8&qid=1510059473&sr=1-1&keywords=do+you+feel+the+need+for+speed");
                        },
                        child: Text(
                          'Steel Challenge Training Manual',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00681B),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          launchURL(
                              "http://www.steelshootbanners.com/index.html");
                        },
                        child: Text(
                          'Steel Challenge Training Aids',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00681B),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          launchURL(
                              "https://www.ssusa.org/articles/2018/7/5/steel-challenge-lets-talk-about-classification/");
                        },
                        child: Text(
                          'The SCSA Classification System',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00681B),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          launchURL(
                              "https://steelchallenge.com/steel-challenge-Rules-Home.php");
                        },
                        child: Text(
                          'Steel Challenge Online Rule Book',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00681B),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          launchURL("https://practiscore.com");
                        },
                        child: Text(
                          'Practiscore Home',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00681B),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          launchURL(
                              "https://teammatchtracker.com/upcoming-matches");
                        },
                        child: Text(
                          'Upcoming Major SCSA Matches',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00681B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  Future launchURL(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url, forceSafariVC: false);
//    } else {
//      print('can\'t launch $url');
//    }
//  }
}

//class Resources extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      appBar: AppBar(
//        title: Text(
//          'Useful Links for Steel Challenge',
//        ),
//        backgroundColor: Color(0xFF00681B),
//      ),
//      body: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(top: 16.0),
//                child: GestureDetector(
//                  onTap: () {
//                    _teamMT();
//                  },
//                  child: Text(
//                    'Team Match Tracker Info and Signup',
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontSize: 16,
//                      fontWeight: FontWeight.bold,
//                      color: Color(0xFF00681B),
//                    ),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(top: 16, bottom: 8.0),
//                child: Text(
//                  'My Current Classifications',
//                  style: TextStyle(
//                    fontSize: 16,
//                    fontWeight: FontWeight.bold,
//                    color: Color(0xFF00681B),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  'The Ultimate Steel Shooter Podcast',
//                  style: TextStyle(
//                    fontSize: 16,
//                    fontWeight: FontWeight.bold,
//                    color: Color(0xFF00681B),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  'The First Steel Challenge Training Manual',
//                  style: TextStyle(
//                    fontSize: 16,
//                    fontWeight: FontWeight.bold,
//                    color: Color(0xFF00681B),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  'Steel Challenge Training Aids',
//                  style: TextStyle(
//                    fontSize: 16,
//                    fontWeight: FontWeight.bold,
//                    color: Color(0xFF00681B),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  'How the SCSA Classification System Works',
//                  style: TextStyle(
//                    fontSize: 16,
//                    fontWeight: FontWeight.bold,
//                    color: Color(0xFF00681B),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  'Steel Challenge Online Rule Book',
//                  style: TextStyle(
//                    fontSize: 16,
//                    fontWeight: FontWeight.bold,
//                    color: Color(0xFF00681B),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  'Steel Challenge World Records',
//                  style: TextStyle(
//                    fontSize: 16,
//                    fontWeight: FontWeight.bold,
//                    color: Color(0xFF00681B),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  'Practiscore Home',
//                  style: TextStyle(
//                    fontSize: 16,
//                    fontWeight: FontWeight.bold,
//                    color: Color(0xFF00681B),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }

_teamMT() async {
  const url = '"http://www.teammatchtracker.com"';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
//}
