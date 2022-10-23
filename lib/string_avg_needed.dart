import 'package:flutter/material.dart';

import 'constants.dart';

class TimesNeeded extends StatelessWidget {
  // const TimesNeeded({Key key}) : super(key: key);
  final division;
  final stage;
  final divAbb;
  final bestAvgStr;

  TimesNeeded({
    Key key,
    this.division,
    this.stage,
    this.divAbb,
    this.bestAvgStr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Account for the different number of scored strings for Outer Limits
    int numStrings;
    stage == 'Outer Limits' ? numStrings = 3 : numStrings = 4;

    //Calculate the minimum average string times needed for each class for this stage and division
    double stagePeak = getStagePeak(stage, division);
    String gmTime = ((stagePeak / .95) / numStrings).toStringAsFixed(2);
    String mTime = ((stagePeak / .85) / numStrings).toStringAsFixed(2);
    String aTime = ((stagePeak / .75) / numStrings).toStringAsFixed(2);
    String bTime = ((stagePeak / .60) / numStrings).toStringAsFixed(2);
    String cTime = ((stagePeak / .40) / numStrings).toStringAsFixed(2);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Average String Time Goals",
          ),
          backgroundColor: Color(0xFF00681B),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$divAbb:',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00681B),
                        ),
                      ),
                      Text(
                        ' $stage',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00681B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        'Your best average string time:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00681B),
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        '${bestAvgStr.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00681B),
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        'Average string time needed for:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00681B),
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: ClassText(
                        classLetter: 'GM',
                        time: gmTime,
                      ),
                    ),
                  ],
                ),
              ),
              FittedBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClassText(
                        classLetter: 'M',
                        time: mTime,
                      ),
                    ),
                  ],
                ),
              ),
              FittedBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClassText(
                        classLetter: 'A',
                        time: aTime,
                      ),
                    ),
                  ],
                ),
              ),
              FittedBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClassText(
                        classLetter: 'B',
                        time: bTime,
                      ),
                    ),
                  ],
                ),
              ),
              FittedBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClassText(
                        classLetter: 'C',
                        time: cTime,
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

  static double getStagePeak(String stageName, String div) {
    switch (stageName) {
      case 'Five to Go':
        return Constants.getPeak5(div);

      case 'Showdown':
        return Constants.getPeakShow(div);

      case 'Smoke & Hope':
        return Constants.getPeakSH(div);

      case 'Outer Limits':
        return Constants.getPeakOL(div);

      case 'Accelerator':
        return Constants.getPeakAcc(div);

      case 'Pendulum':
        return Constants.getPeakPend(div);

      case 'Speed Option':
        return Constants.getPeakSpeed(div);

      case 'Roundabout':
        return Constants.getPeakRound(div);
    }
    return 0;
  }
}

//Custom text widget to reduce redundant code
class ClassText extends StatelessWidget {
  const ClassText({
    Key key,
    @required this.classLetter,
    this.time,
  }) : super(key: key);

  final String classLetter;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$classLetter:  $time',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00681B),
      ),
    );
  }
}
