import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'database_helper.dart';

//This probably should have been set up as a Stateless Widget since it simply
// displays info with no user interaction. However, after setting it up initially
// as Stateful, I later attempted to convert it to Stateless but could not get
// it to work. Decided to leave it alone.

class ClassificationSummary extends StatefulWidget {
  const ClassificationSummary({Key key}) : super(key: key);

  @override
  _ClassificationSummaryState createState() => _ClassificationSummaryState();
}

class _ClassificationSummaryState extends State<ClassificationSummary> {
  DatabaseHelper helper = DatabaseHelper.instance;

  String div1 = '';
  String div1Pct = '';
  String div1Class = '';

  String div2 = '';
  String div2Pct = '';
  String div2Class = '';

  String div3 = '';
  String div3Pct = '';
  String div3Class = '';

  String div4 = '';
  String div4Pct = '';
  String div4Class = '';

  String div5 = '';
  String div5Pct = '';
  String div5Class = '';

  String div6 = '';
  String div6Pct = '';
  String div6Class = '';

  String div7 = '';
  String div7Pct = '';
  String div7Class = '';

  String div8 = '';
  String div8Pct = '';
  String div8Class = '';

  String div9 = '';
  String div9Pct = '';
  String div9Class = '';

  String div10 = '';
  String div10Pct = '';
  String div10Class = '';

  String div11 = '';
  String div11Pct = '';
  String div11Class = '';

  String div12 = '';
  String div12Pct = '';
  String div12Class = '';

  String div13 = '';
  String div13Pct = '';
  String div13Class = '';

  //Call method to find and display all of the user's current classifications
  @override
  void initState() {
    __getSummary('Carry Optics (CO)');
    __getSummary('Iron Sight Revolver (ISR)');
    __getSummary('Limited (LTD)');
    __getSummary('Open (OPN)');
    __getSummary('Optical Sight Revolver (OSR)');
    __getSummary('Pistol-Caliber Carbine Irons (PCCI)');
    __getSummary('Pistol-Caliber Carbine Optic (PCCO)');
    __getSummary('Production (PROD)');
    __getSummary('Rimfire Pistol Irons (RFPI)');
    __getSummary('Rimfire Pistol Open (RFPO)');
    __getSummary('Rimfire Rifle Irons (RFRI)');
    __getSummary('Rimfire Rifle Open (RFRO)');
    __getSummary('Single Stack (SS)');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Text('Classification Summary'),
        ),
        backgroundColor: Constants.mtGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 20.0,
                color: Constants.mtGreen,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: SizedBox(
                        height: 20,
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: _HeadingContainer(heading: 'Division')),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: SizedBox(
                        height: 20,
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: _HeadingContainer(heading: 'Current %')),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: SizedBox(
                        height: 20,
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: _HeadingContainer(heading: 'Current Class')),
                      ),
                    ),
                    // SizedBox(
                    //   width: 30,
                    // )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div1Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(
                      contents: div1Class,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(
                      contents: div2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(
                      contents: div2Pct,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(
                      contents: div2Class,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div3),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(
                      contents: div3Pct,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(
                      contents: div3Class,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div4),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div4Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div4Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div5),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div5Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div5Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div6),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(
                      contents: div6Pct,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div6Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div7),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div7Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div7Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div8),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div8Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div8Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(
                      contents: div9,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div9Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div9Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div10Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div10Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div11),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div11Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div11Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div12Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(contents: div12Class),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: DivisionContainer(contents: div13),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DivisionContainer(contents: div13Pct),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: DivisionContainer(
                      contents: div13Class,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    width: 50.0,
                    height: 22.0,
                    child: FittedBox(
                      child: Text(
                        'GM',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Constants.mtGreen,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 85.0,
                    height: 20.0,
                    child: FittedBox(
                      child: Text(
                        '>= 95%',
                        style: TextStyle(
                          color: Constants.mtGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  width: 50.0,
                  height: 20.0,
                  child: FittedBox(
                    child: Text(
                      'M',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Constants.mtGreen,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 85.0,
                  height: 20.0,
                  child: FittedBox(
                    child: Text(
                      '>= 85%',
                      style: TextStyle(
                        color: Constants.mtGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  width: 50.0,
                  height: 20.0,
                  child: FittedBox(
                    child: Text(
                      'A',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Constants.mtGreen,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 85.0,
                  height: 20.0,
                  child: FittedBox(
                    child: Text(
                      '>= 75%',
                      style: TextStyle(
                        color: Constants.mtGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  width: 50.0,
                  height: 20.0,
                  child: FittedBox(
                    child: Text(
                      'B',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Constants.mtGreen,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 85.0,
                  height: 20.0,
                  child: FittedBox(
                    child: Text(
                      '>= 60%',
                      style: TextStyle(
                        color: Constants.mtGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  width: 50.0,
                  height: 20.0,
                  child: FittedBox(
                    child: Text(
                      'C',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Constants.mtGreen,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 85.0,
                  height: 20.0,
                  child: FittedBox(
                    child: Text(
                      '>= 40%',
                      style: TextStyle(
                        color: Constants.mtGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  __getSummary(String div) async {
    double peak5 = Constants.getPeak5(div);
    double peakShow = Constants.getPeakShow(div);
    double peakSH = Constants.getPeakSH(div);
    double peakOL = Constants.getPeakOL(div);
    double peakAcc = Constants.getPeakAcc(div);
    double peakPend = Constants.getPeakPend(div);
    double peakSpeed = Constants.getPeakSpeed(div);
    double peakRound = Constants.getPeakRound(div);

    String divAbbrev;
    String overriddenClass;

    double totalBest = 0.0;
    double totalPeak = 0.0;

    int numClassifiers = 0;

    //Check to see if user has overridden his calculated class and, if so,
    // use this class instead of the one calculated based on current best times.
    switch (div) {
      case 'Rimfire Rifle Open (RFRO)':
        divAbbrev = 'RFRO';
        _getClassOverride('Rimfire Rifle Open (RFRO)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        divAbbrev = 'RFRI';
        _getClassOverride('Rimfire Rifle Irons (RFRI)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        divAbbrev = 'PCCO';
        _getClassOverride('Pistol-Caliber Carbine Optic (PCCO)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        divAbbrev = 'PCCI';
        _getClassOverride('Pistol-Caliber Carbine Irons (PCCI)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Rimfire Pistol Open (RFPO)':
        divAbbrev = 'RFPO';
        _getClassOverride('Rimfire Pistol Open (RFPO)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        divAbbrev = 'RFPI';
        _getClassOverride('Rimfire Pistol Irons (RFPI)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Open (OPN)':
        divAbbrev = 'OPN';
        _getClassOverride('Open (OPN)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Carry Optics (CO)':
        divAbbrev = 'CO';
        _getClassOverride('Carry Optics (CO)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Production (PROD)':
        divAbbrev = 'PROD';
        _getClassOverride('Production (PROD)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Limited (LTD)':
        divAbbrev = 'LTD';
        _getClassOverride('Limited (LTD)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Single Stack (SS)':
        divAbbrev = 'SS';
        _getClassOverride('Single Stack (SS)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Optical Sight Revolver (OSR)':
        divAbbrev = 'OSR';
        _getClassOverride('Optical Sight Revolver (OSR)').then((value) {
          overriddenClass = value;
        });
        break;

      case 'Iron Sight Revolver (ISR)':
        divAbbrev = 'ISR';
        _getClassOverride('Iron Sight Revolver (ISR)').then((value) {
          overriddenClass = value;
        });
        break;
    }

    // Get the number of rows in the division table to avoid a null result and
    //to make sure we're querying the last row in the table.
    int numRows = await helper.getCount(divAbbrev);

    //Get stage times from the last (most recently added) row in the table.
    StageTimes stageTimes = await helper.queryStageTimes(divAbbrev, numRows);

    //Make sure the table itself is not null (has at least one row).
    if (numRows >= 1) {
      if (stageTimes.best5 != '') {
        totalBest += double.parse(stageTimes.best5);
        totalPeak += peak5;
        numClassifiers += 1;
      }
      if (stageTimes.bestShow != '') {
        totalBest += double.parse(stageTimes.bestShow);
        totalPeak += peakShow;
        numClassifiers += 1;
      }
      if (stageTimes.bestSH != '') {
        totalBest += double.parse(stageTimes.bestSH);
        totalPeak += peakSH;
        numClassifiers += 1;
      }
      if (stageTimes.bestOL != '') {
        totalBest += double.parse(stageTimes.bestOL);
        totalPeak += peakOL;
        numClassifiers += 1;
      }
      if (stageTimes.bestAcc != '') {
        totalBest += double.parse(stageTimes.bestAcc);
        totalPeak += peakAcc;
        numClassifiers += 1;
      }
      if (stageTimes.bestPend != '') {
        totalBest += double.parse(stageTimes.bestPend);
        totalPeak += peakPend;
        numClassifiers += 1;
      }
      if (stageTimes.bestSpeed != '') {
        totalBest += double.parse(stageTimes.bestSpeed);
        totalPeak += peakSpeed;
        numClassifiers += 1;
      }
      if (stageTimes.bestRound != '') {
        totalBest += double.parse(stageTimes.bestRound);
        totalPeak += peakRound;
        numClassifiers += 1;
      }
    }
    //Show only divisions in which at least 4 classifier stages have been shot.
    if (numClassifiers >= 4) {
      //Find the next open spot in the list and show this division along with
      // overidden class (if any); otherwise call _calcClass() to get class.
      setState(() {
        if (div1 == '') {
          div1 = divAbbrev;
          div1Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);

          if (overriddenClass != '') {
            div1Class = overriddenClass;
          } else {
            div1Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div2 == '') {
          div2 = divAbbrev;
          div2Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div2Class = overriddenClass;
          } else {
            div2Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div3 == '') {
          div3 = divAbbrev;
          div3Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div3Class = overriddenClass;
          } else {
            div3Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div4 == '') {
          div4 = divAbbrev;
          div4Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div4Class = overriddenClass;
          } else {
            div4Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div5 == '') {
          div5 = divAbbrev;
          div5Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div5Class = overriddenClass;
          } else {
            div5Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div6 == '') {
          div6 = divAbbrev;
          div6Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div6Class = overriddenClass;
          } else {
            div6Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div7 == '') {
          div7 = divAbbrev;
          div7Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div7Class = overriddenClass;
          } else {
            div7Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div8 == '') {
          div8 = divAbbrev;
          div8Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div8Class = overriddenClass;
          } else {
            div8Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div9 == '') {
          div9 = divAbbrev;
          div9Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div9Class = overriddenClass;
          } else {
            div9Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div10 == '') {
          div10 = divAbbrev;
          div10Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div10Class = overriddenClass;
          } else {
            div10Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div11 == '') {
          div11 = divAbbrev;
          div11Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);

          if (overriddenClass != '') {
            div11Class = overriddenClass;
          } else {
            div11Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div12 == '') {
          div12 = divAbbrev;
          div12Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div12Class = overriddenClass;
          } else {
            div12Class = _calcClass(totalPeak, totalBest);
          }
        } else if (div13 == '') {
          div13 = divAbbrev;
          div13Pct = ((totalPeak / totalBest) * 100).toStringAsFixed(2);
          if (overriddenClass != '') {
            div13Class = overriddenClass;
          } else {
            div13Class = _calcClass(totalPeak, totalBest);
          }
        }
      });
    }
  }
}

//Get overridden class (if any) for this division from SharedPreferences.
Future<String> _getClassOverride(String div) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  //if getString result is null (class not overidden), return empty string.
  return preferences.getString(div) ?? '';
}

//If class hasn't been overidden, calculate class based on best times vs. peak times.
String _calcClass(double peak, double best) {
  double peakPct = (peak / best) * 100;
  if (peakPct < 40.0) {
    return 'D';
  } else if (peakPct < 60.0) {
    return 'C';
  } else if (peakPct < 75.0) {
    return 'B';
  } else if (peakPct < 85.0) {
    return 'A';
  } else if (peakPct < 95.0) {
    return 'M';
  } else {
    return 'GM';
  }
}

//Custom container widget for division details
class DivisionContainer extends StatelessWidget {
  const DivisionContainer({
    Key key,
    @required this.contents,
  }) : super(key: key);

  final String contents;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95.0,
      height: 22.0,
      child: FittedBox(
        child: Text(
          contents,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Constants.mtGreen,
          ),
        ),
      ),
    );
  }
}

//Custom container widget for header row
class _HeadingContainer extends StatelessWidget {
  const _HeadingContainer({Key key, @required this.heading}) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Text(heading,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }
}
