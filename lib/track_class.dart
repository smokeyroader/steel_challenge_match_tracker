// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'constants.dart';

class ClassTracker extends StatelessWidget {
  final String division;
  final String totTime;
  final String totPeak;
  final String currClass;

  ClassTracker({
    super.key,
    required this.division,
    required this.totTime,
    required this.totPeak,
    required this.currClass,
  });

  late String class1;
  late String class2;
  late String class3;
  late String class4;
  late String class5;

  late String timeCuts;

  @override
  Widget build(BuildContext context) {
    if (currClass == 'GM') {
      timeCuts = 'Congratulations on your achievement';
    } else {
      timeCuts = 'Time cuts needed to advance to:';
    }
    showTimes();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              'Steel Challenge Class Tracker',
            ),
          ),
          backgroundColor: Constants.mtGreen,
          foregroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50.0,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Card(
                        elevation: 8,
                        shadowColor: Constants.mtGreen,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 8, right: 8),
                          child: Text(
                            division,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Constants.mtGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Card(
                      elevation: 8,
                      shadowColor: Constants.mtGreen,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        child: Text(
                          'Current Class:  $currClass',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Constants.mtGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
              _ClassText(
                contents: timeCuts,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _ClassText(
                  contents: class1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _ClassText(
                  contents: class2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _ClassText(
                  contents: class3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _ClassText(
                  contents: class4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _ClassText(
                  contents: class5,
                ),
              ),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Note: At least four classifier stages are required for a valid SCSA classification. The above times will be most valid after all classifier stages have been completed.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Constants.mtGreen,
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
    switch (currClass) {
      case 'D':
        class1 =
            'C:    ${((double.parse(totPeak) / .40) - double.parse(totTime)).toStringAsFixed(2)}';
        class2 =
            'B:    ${((double.parse(totPeak) / .60) - double.parse(totTime)).toStringAsFixed(2)}';
        class3 =
            'A:    ${((double.parse(totPeak) / .75) - double.parse(totTime)).toStringAsFixed(2)}';
        class4 =
            'M:    ${((double.parse(totPeak) / .85) - double.parse(totTime)).toStringAsFixed(2)}';
        class5 =
            'GM:    ${((double.parse(totPeak) / .95) - double.parse(totTime)).toStringAsFixed(2)}';

        break;

      case 'C':
        class1 =
            'B:    ${((double.parse(totPeak) / .60) - double.parse(totTime)).toStringAsFixed(2)}';
        class2 =
            'A:    ${((double.parse(totPeak) / .75) - double.parse(totTime)).toStringAsFixed(2)}';
        class3 =
            'M:    ${((double.parse(totPeak) / .85) - double.parse(totTime)).toStringAsFixed(2)}';
        class4 =
            'GM:    ${((double.parse(totPeak) / .95) - double.parse(totTime)).toStringAsFixed(2)}';
        class5 = '';

        break;

      case 'B':
        class1 =
            'A:    ${((double.parse(totPeak) / .75) - double.parse(totTime)).toStringAsFixed(2)}';
        class2 =
            'M:    ${((double.parse(totPeak) / .85) - double.parse(totTime)).toStringAsFixed(2)}';
        class3 =
            'GM:    ${((double.parse(totPeak) / .95) - double.parse(totTime)).toStringAsFixed(2)}';
        class4 = '';
        class5 = '';

        break;

      case 'A':
        class1 =
            'M:    ${((double.parse(totPeak) / .85) - double.parse(totTime)).toStringAsFixed(2)}';
        class2 =
            'GM:    ${((double.parse(totPeak) / .95) - double.parse(totTime)).toStringAsFixed(2)}';
        class3 = '';
        class4 = '';
        class5 = '';

        break;

      case 'M':
        class1 =
            'GM:    ${((double.parse(totPeak) / .95) - double.parse(totTime)).toStringAsFixed(2)}';
        class2 = '';
        class3 = '';
        class4 = '';
        class5 = '';

        break;

      case 'GM':
        class1 = '';
        class2 = '';
        class3 = '';
        class4 = '';
        class5 = '';

        break;
    }
  }
}

//Custom widget for displaying time cuts needed for advancement
class _ClassText extends StatelessWidget {
  const _ClassText({required this.contents});

  final String contents;

  @override
  Widget build(BuildContext context) {
    return Text(
      contents,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Constants.mtGreen,
      ),
    );
  }
}
