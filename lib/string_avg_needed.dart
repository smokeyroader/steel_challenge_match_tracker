import 'package:flutter/material.dart';

import 'constants.dart';

class TimesNeeded extends StatelessWidget {
  final String division;
  final String stage;
  final String divAbb;
  final double bestAvgStr;

  const TimesNeeded({
    super.key,
    required this.division,
    required this.stage,
    required this.divAbb,
    required this.bestAvgStr,
  });

  @override
  Widget build(BuildContext context) {
    String bestStageClass;

    //Account for the different number of scored strings for Outer Limits.
    int numStrings;
    stage == 'Outer Limits' ? numStrings = 3 : numStrings = 4;

    //Calculate and show the minimum average string times needed for each class for this stage and division.
    double stagePeak = getStagePeak(stage, division);
    String gmTime = ((stagePeak / .95) / numStrings).toStringAsFixed(2);
    String mTime = ((stagePeak / .85) / numStrings).toStringAsFixed(2);
    String aTime = ((stagePeak / .75) / numStrings).toStringAsFixed(2);
    String bTime = ((stagePeak / .60) / numStrings).toStringAsFixed(2);
    String cTime = ((stagePeak / .40) / numStrings).toStringAsFixed(2);

    if (bestAvgStr <= (stagePeak / .95) / numStrings) {
      bestStageClass = 'GM';
    } else if (bestAvgStr <= (stagePeak / .85) / numStrings) {
      bestStageClass = 'M';
    } else if (bestAvgStr <= (stagePeak / .75) / numStrings) {
      bestStageClass = 'A';
    } else if (bestAvgStr <= (stagePeak / .60) / numStrings) {
      bestStageClass = 'B';
    } else if (bestAvgStr <= (stagePeak / .40) / numStrings) {
      bestStageClass = 'C';
    } else {
      bestStageClass = 'D';
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Average String Time Goals",
          ),
          backgroundColor: Constants.mtGreen,
          foregroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Card(
                elevation: 8,
                shadowColor: Constants.mtGreen,
                child: Padding(
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
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Constants.mtGreen,
                          ),
                        ),
                        Text(
                          ' $stage',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Constants.mtGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        'Your best average string time:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.mtGreen,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 4.0,
                      ),
                      child: Text(
                        bestAvgStr.toStringAsFixed(2),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.mtGreen,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: Text(
                        '($bestStageClass)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.mtGreen,
                          fontSize: 24,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        'Average string time needed for:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.mtGreen,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClassTimes(
                classLetter: 'GM',
                time: gmTime,
              ),
              const SizedBox(
                height: 10,
              ),
              ClassTimes(
                classLetter: 'M',
                time: mTime,
              ),
              const SizedBox(
                height: 10,
              ),
              ClassTimes(
                classLetter: 'A',
                time: aTime,
              ),
              const SizedBox(
                height: 10,
              ),
              ClassTimes(
                classLetter: 'B',
                time: bTime,
              ),
              const SizedBox(
                height: 10,
              ),
              ClassTimes(
                classLetter: 'C',
                time: cTime,
              ),
              const SizedBox(
                height: 70,
              ),
              const FittedBox(
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Text('Times may not be precise due to rounding.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Constants.mtGreen,
                      ),
                    ),
                  )
                ]),
              )
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

//Custom widget to reduce redundant code
class ClassTimes extends StatelessWidget {
  // const ClassTimes({
  //   Key? key,
  //   required this.classLetter,
  //   required this.time,
  // }) : super(key: key);
  const ClassTimes({
    super.key,
    required this.classLetter,
    required this.time,
  });

  final String classLetter;
  final String time;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('$classLetter:  $time',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Constants.mtGreen,
            ))
      ]),
    );
  }
}
