import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class ClassTracker extends StatefulWidget {
  final String division;
  final String totTime;
  final String totPeak;
  final String currClass;

  ClassTracker({
    Key key,
    this.division,
    this.totTime,
    this.totPeak,
    this.currClass,
  }) : super(key: key);

  @override
  _ClassTrackerState createState() => _ClassTrackerState();
}

class _ClassTrackerState extends State<ClassTracker> {
  String timeCuts = 'Time cuts needed to advance to:';

  String class1;
  String class2;
  String class3;
  String class4;
  String class5;

  @override
  Widget build(BuildContext context) {
    showTimes();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Text(
              'Steel Challenge Class Tracker',
            ),
          ),
          backgroundColor: Color(0xFF00681B),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: FittedBox(
                      child: Text(
                        '${widget.division}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00681B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
//          Center(
//            child: Text(
//              '${widget.division}',
//              style: TextStyle(
//                fontSize: 18.0,
//                fontWeight: FontWeight.bold,
//                color: Color(0xFF00681B),
//              ),
//            ),
//          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Current Class:  ${widget.currClass}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00681B),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 75.0,
              ),
              Text(
                '$timeCuts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00681B),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  '$class1',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00681B),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  '$class2',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00681B),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  '$class3',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00681B),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  '$class4',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00681B),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  '$class5',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00681B),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Note: At least four classifier stages are required for a valid SCSA classification. The above times will be most valid after all classifier stages have been completed.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00681B),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showTimes() {
    switch (widget.currClass) {
      case 'D':
        setState(() {
          class1 =
              'C:    ${((double.parse(widget.totPeak) / .40) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class2 =
              'B:    ${((double.parse(widget.totPeak) / .60) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class3 =
              'A:    ${((double.parse(widget.totPeak) / .75) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class4 =
              'M:    ${((double.parse(widget.totPeak) / .85) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class5 =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
        });

        break;

      case 'C':
        setState(() {
          class1 =
              'B:    ${((double.parse(widget.totPeak) / .60) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class2 =
              'A:    ${((double.parse(widget.totPeak) / .75) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class3 =
              'M:    ${((double.parse(widget.totPeak) / .85) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class4 =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class5 = '';
        });

        break;

      case 'B':
        setState(() {
          class1 =
              'A:    ${((double.parse(widget.totPeak) / .75) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class2 =
              'M:    ${((double.parse(widget.totPeak) / .85) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class3 =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class4 = '';
          class5 = '';
        });

        break;

      case 'A':
        setState(() {
          class1 =
              'M:    ${((double.parse(widget.totPeak) / .85) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class2 =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class3 = '';
          class4 = '';
          class5 = '';
        });

        break;

      case 'M':
        setState(() {
          class1 =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          class2 = '';
          class3 = '';
          class4 = '';
          class5 = '';
        });
        break;

      case 'GM':
        setState(() {
          class1 = '';
          class2 = '';
          class3 = '';
          class4 = '';
          class5 = '';
          timeCuts = 'Congratulations on your achievement!';
        });
        break;
    }
  }
}
