import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'database_helper.dart';

class DivisionSummary extends StatefulWidget {
  const DivisionSummary({Key key}) : super(key: key);

  @override
  _DivisionSummaryState createState() => _DivisionSummaryState();
}

class _DivisionSummaryState extends State<DivisionSummary> {
  DatabaseHelper helper = DatabaseHelper.instance;

  String division;
  String percent;
  String currClass;

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

  @override
  void initState() {
    __getSummary('Rimfire Rifle Open (RFRO)');
    __getSummary('Rimfire Rifle Irons (RFRI)');
    __getSummary('Pistol-Caliber Carbine Optic (PCCO)');
    __getSummary('Pistol-Caliber Carbine Irons (PCCI)');
    __getSummary('Rimfire Pistol Open (RFPO)');
    __getSummary('Rimfire Pistol Irons (RFPI)');
    __getSummary('Open (OPN)');
    __getSummary('Carry Optics (CO)');
    __getSummary('Production (PROD)');
    __getSummary('Limited (LTD)');
    __getSummary('Single Stack (SS)');
    __getSummary('Optical Sight Revolver (OSR)');
    __getSummary('Iron Sight Revolver (ISR)');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Text('Classification Summary'),
        ),
        backgroundColor: const Color(0xFF00681B),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 20.0,
                color: const Color(0xFF00681B),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: _HeadingContainer(heading: 'Division'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: _HeadingContainer(heading: 'Current Percent'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: _HeadingContainer(heading: 'Current Class'),
                    ),
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
                          color: Color(0xFF00681B),
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
                          color: Color(0xFF00681B),
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
                        color: Color(0xFF00681B),
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
                        color: Color(0xFF00681B),
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
                        color: Color(0xFF00681B),
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
                        color: Color(0xFF00681B),
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
                        color: Color(0xFF00681B),
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
                        color: Color(0xFF00681B),
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
                        color: Color(0xFF00681B),
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
                        color: Color(0xFF00681B),
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

    int numRows = await helper.getCount(divAbbrev);

    StageTimes stageTimes = await helper.queryStageTimes(divAbbrev, numRows);
    if (numRows >= 5) {
      if (stageTimes.best5 != '' && stageTimes.best5 != null) {
        totalBest += double.parse(stageTimes.best5);
        totalPeak += peak5;
      }
      if (stageTimes.bestShow != '' && stageTimes.bestShow != null) {
        totalBest += double.parse(stageTimes.bestShow);
        totalPeak += peakShow;
      }
      if (stageTimes.bestSH != '' && stageTimes.bestSH != null) {
        totalBest += double.parse(stageTimes.bestSH);
        totalPeak += peakSH;
      }
      if (stageTimes.bestOL != '' && stageTimes.bestOL != null) {
        totalBest += double.parse(stageTimes.bestOL);
        totalPeak += peakOL;
      }
      if (stageTimes.bestAcc != '' && stageTimes.bestAcc != null) {
        totalBest += double.parse(stageTimes.bestAcc);
        totalPeak += peakAcc;
      }
      if (stageTimes.bestPend != '' && stageTimes.bestPend != null) {
        totalBest += double.parse(stageTimes.bestPend);
        totalPeak += peakPend;
      }
      if (stageTimes.bestSpeed != '' && stageTimes.bestSpeed != null) {
        totalBest += double.parse(stageTimes.bestSpeed);
        totalPeak += peakSpeed;
      }
      if (stageTimes.bestRound != '' && stageTimes.bestRound != null) {
        totalBest += double.parse(stageTimes.bestRound);
        totalPeak += peakRound;
      }

      if (totalBest > 0) {
        setState(() {
          if (div1 == '') {
            div1 = divAbbrev;
            div1Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div1Class = overriddenClass;
            } else {
              div1Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div2 == '') {
            div2 = divAbbrev;
            div2Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div2Class = overriddenClass;
            } else {
              div2Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div3 == '') {
            div3 = divAbbrev;
            div3Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div3Class = overriddenClass;
            } else {
              div3Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div4 == '') {
            div4 = divAbbrev;
            div4Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div4Class = overriddenClass;
            } else {
              div4Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div5 == '') {
            div5 = divAbbrev;
            div5Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div5Class = overriddenClass;
            } else {
              div5Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div6 == '') {
            div6 = divAbbrev;
            div6Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div6Class = overriddenClass;
            } else {
              div6Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div7 == '') {
            div7 = divAbbrev;
            div7Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div7Class = overriddenClass;
            } else {
              div7Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div8 == '') {
            div8 = divAbbrev;
            div8Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div8Class = overriddenClass;
            } else {
              div8Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div9 == '') {
            div9 = divAbbrev;
            div9Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div9Class = overriddenClass;
            } else {
              div9Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div10 == '') {
            div10 = divAbbrev;
            div10Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div10Class = overriddenClass;
            } else {
              div10Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div11 == '') {
            div11 = divAbbrev;
            div11Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div11Class = overriddenClass;
            } else {
              div11Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div12 == '') {
            div12 = divAbbrev;
            div12Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div12Class = overriddenClass;
            } else {
              div12Class = _calcClass(totalPeak, totalBest);
            }
          } else if (div13 == '') {
            div13 = divAbbrev;
            div13Pct = ((totalPeak / totalBest * 100)).toStringAsFixed(2);
            if (overriddenClass != '' && overriddenClass != null) {
              div13Class = overriddenClass;
            } else {
              div13Class = _calcClass(totalPeak, totalBest);
            }
          }
        });
      }
    }
  }

  //Get overridden class (if any) for this division from SharedPreferences
  Future<String> _getClassOverride(String div) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString(div) ?? '';
  }

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
}

//Custom container for division details
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
//                          fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00681B),
          ),
        ),
      ),
    );
  }
}

//Custom container for header row
class _HeadingContainer extends StatelessWidget {
  const _HeadingContainer({Key key, @required this.heading}) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(heading,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }
}
