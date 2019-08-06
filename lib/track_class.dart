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
  String forGM = '';
  String forM = '';
  String forA = '';
  String forB = '';
  String forC = '';
  @override
  Widget build(BuildContext context) {
    showTimes();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Steel Challenge Class Tracker',
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
                  child: Text(
                    '${widget.division}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00681B),
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
                '$forGM',
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
                '$forM',
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
                '$forA',
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
                '$forB',
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
                '$forC',
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
    );
  }

  void showTimes() {
    switch (widget.currClass) {
      case 'D':
        setState(() {
          forC =
              'C:    ${((double.parse(widget.totPeak) / .40) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forB =
              'B:    ${((double.parse(widget.totPeak) / .60) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forA =
              'A:    ${((double.parse(widget.totPeak) / .75) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forM =
              'M:    ${((double.parse(widget.totPeak) / .85) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forGM =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
        });

        break;

      case 'C':
        setState(() {
          forC = '';
          forB =
              'B:    ${((double.parse(widget.totPeak) / .60) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forA =
              'A:    ${((double.parse(widget.totPeak) / .75) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forM =
              'M:    ${((double.parse(widget.totPeak) / .85) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forGM =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
        });

        break;

      case 'B':
        setState(() {
          forC = '';
          forB = '';
          forA =
              'A:    ${((double.parse(widget.totPeak) / .75) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forM =
              'M:    ${((double.parse(widget.totPeak) / .85) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forGM =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
        });

        break;

      case 'A':
        setState(() {
          forC = '';
          forB = '';
          forA = '';
          forM =
              'M:    ${((double.parse(widget.totPeak) / .85) - double.parse(widget.totTime)).toStringAsFixed(2)}';
          forGM =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
        });

        break;

      case 'M':
        setState(() {
          forGM =
              'GM:    ${((double.parse(widget.totPeak) / .95) - double.parse(widget.totTime)).toStringAsFixed(2)}';
        });
        break;

      case 'GM':
        setState(() {
          forC = '';
          forB = '';
          forA = '';
          forM = '';
          forGM = '';
          timeCuts = 'Congratulations on your achievement!';
        });
        break;
    }
  }
}
