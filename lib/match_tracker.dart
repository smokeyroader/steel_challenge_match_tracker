import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steel_challenge_match_tracker/string_avg_needed.dart';

import 'best_strings.dart';
import 'constants.dart';
import 'database_helper.dart';
import 'track_class.dart';
import 'stage_diagrams.dart';
import 'today_text_field.dart';

class MatchTracker extends StatefulWidget {
  //Set current division sent from mt_home_page.dart
  final String currentDivision;

  const MatchTracker({
    Key key,
    this.currentDivision,
  }) : super(key: key);

  @override
  _MatchTrackerState createState() => _MatchTrackerState();
}

class _MatchTrackerState extends State<MatchTracker> {
  //Establish connection with MatchTracker.db
  DatabaseHelper helper = DatabaseHelper.instance;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  //Set controllers to retrieve stage times from TextFields

  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controllerShow = TextEditingController();
  final TextEditingController _controllerSH = TextEditingController();
  final TextEditingController _controllerOL = TextEditingController();
  final TextEditingController _controllerAcc = TextEditingController();
  final TextEditingController _controllerPend = TextEditingController();
  final TextEditingController _controllerSpeed = TextEditingController();
  final TextEditingController _controllerRound = TextEditingController();

  //Declare focusNodes to detect change in focus of TextFields

  FocusNode _focus5;
  FocusNode _focusShow;
  FocusNode _focusSH;
  FocusNode _focusOL;
  FocusNode _focusAcc;
  FocusNode _focusPend;
  FocusNode _focusSpeed;
  FocusNode _focusRound;

  String showToday;
  String overriddenClass = '';

  String stageName;

  String best5 = '';
  String bestShow = '';
  String bestSH = '';
  String bestOL = '';
  String bestAcc = '';
  String bestPend = '';
  String bestSpeed = '';
  String bestRound = '';

  String bestClass5 = '';
  String bestClassShow = '';
  String bestClassSH = '';
  String bestClassOL = '';
  String bestClassAcc = '';
  String bestClassPend = '';
  String bestClassSpeed = '';
  String bestClassRound = '';

  double peak5;
  double peakShow;
  double peakSH;
  double peakOL;
  double peakAcc;
  double peakPend;
  double peakSpeed;
  double peakRound;

  double diff;
  double timeShaved = 0.0;

  String todayPct5 = '';
  String todayPctShow = '';
  String todayPctSH = '';
  String todayPctOL = '';
  String todayPctAcc = '';
  String todayPctPend = '';
  String todayPctSpeed = '';
  String todayPctRound = '';

  String todayTime = '';
  String overallTime = '';
  String todayPeak = '';
  String overallPeak = '';
  String todayPct = '';
  String overallPct = '';
  String todayClass = '';
  String overallClass = '';

  String timeCuts = '';

// Permit changing today time font to green and bold if a new personal
//best is entered
  Color newBestColor5;
  Color newBestColorShow;
  Color newBestColorSH;
  Color newBestColorOL;
  Color newBestColorAcc;
  Color newBestColorPend;
  Color newBestColorSpeed;
  Color newBestColorRound;

  String divAbbrev;

  @override
  void initState() {
    super.initState();

    _focus5 = FocusNode();
    _focusShow = FocusNode();
    _focusSH = FocusNode();
    _focusOL = FocusNode();
    _focusAcc = FocusNode();
    _focusPend = FocusNode();
    _focusSpeed = FocusNode();
    _focusRound = FocusNode();

    //Check if today times are shown (true) or hidden (false)
    _getShowHide().then((value) {
      showToday = value;
    });

    //Check if class has been overridden
    _getClassOverride(widget.currentDivision).then((value) {
      overriddenClass = value;
    });

    //Set division abbreviation to be used to access the correct table when
    //saving and retrieving times
    divAbbrev = Constants.getDivAbbrev(widget.currentDivision);

    //Get and set best and today times from database
    _getStageTimes();

    //Call method to calculate and show all current total times after
    //retrieval from database
    _calcTotals();

    //Assign listeners to each TextField to detect changes.

    _focus5.addListener(_focus5Listener);
    _focusShow.addListener(_focusShowListener);
    _focusSH.addListener(_focusSHListener);
    _focusOL.addListener(_focusOLListener);
    _focusAcc.addListener(_focusAccListener);
    _focusPend.addListener(_focusPendListener);
    _focusSpeed.addListener(_focusSpeedListener);
    _focusRound.addListener(_focusRoundListener);
  }

  @override
  void dispose() {
    _focus5.dispose();
    _focusShow.dispose();
    _focusSH.dispose();
    _focusOL.dispose();
    _focusAcc.dispose();
    _focusPend.dispose();
    _focusSpeed.dispose();
    _focusRound.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Get peak times for the division from constants class
    peak5 = Constants.getPeak5(widget.currentDivision);
    peakShow = Constants.getPeakShow(widget.currentDivision);
    peakSH = Constants.getPeakSH(widget.currentDivision);
    peakOL = Constants.getPeakOL(widget.currentDivision);
    peakAcc = Constants.getPeakAcc(widget.currentDivision);
    peakPend = Constants.getPeakPend(widget.currentDivision);
    peakSpeed = Constants.getPeakSpeed(widget.currentDivision);
    peakRound = Constants.getPeakRound(widget.currentDivision);

    //Display UI
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Match Tracker',
        ),
        backgroundColor: Constants.mtGreen,
        //Create popup menu (stacked dots at the right of AppBar)
        //Menu is populated with a list from the Constants.dart file
        actions: <Widget>[
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: _matchMenuChoiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.matchMenuChoices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      key: scaffoldState,

      //GestureDetector to dismiss keyboard by tapping outside any text field
      // (to account for ios keyboard that does not have a "Done" or check key).
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        //Override both back buttons to also save data when tapped
        child: WillPopScope(
          onWillPop: () async {
            _saveStageTimes();
            // SystemChannels.textInput.invokeMethod('TextInput.hide');
            return true;
          },
          //Add ScrollView so that keyboard doesn't cover data fields
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(
                            2.0,
                          ),
                          child: FittedBox(
                            child: Text(
                              widget.currentDivision,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Constants.mtGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20.0,
                    color: Constants.mtGreen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        SizedBox(
                          width: 65.0,
                          child: _HeadText(
                            text: 'Stage',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 24.0,
                          ),
                          child: SizedBox(
                            width: 60.0,
                            child: _HeadText(
                              text: 'Best',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60.0,
                          child: _HeadText(
                            text: 'Today',
                          ),
                        ),
                        SizedBox(
                          width: 85.0,
                          child: _HeadText(
                            text: '%/Class',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 70.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Constants.mtGreen,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const StageDiagram(
                                          'Five to Go',
                                          'images/five_to_go.jpg',
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const FittedBox(
                                  child: Text(
                                    '5 to Go',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '101 ($peak5)',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: SizedBox(
                            width: 80.0,
                            child: (Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                bestStage('Five to Go', best5),
                                bestClass('Five to Go', best5, bestClass5),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TodayTime(
                            newBestColor5,
                            _controller5,
                            _focus5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: Text(
                              todayPct5,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 75.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Constants.mtGreen,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const StageDiagram(
                                          'Showdown',
                                          'images/showdown.jpg',
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const FittedBox(
                                  child: Text(
                                    'Showdown',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '102 ($peakShow)',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: (Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                bestStage('Showdown', bestShow),
                                bestClass('Showdown', bestShow, bestClassShow),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TodayTime(
                            newBestColorShow,
                            _controllerShow,
                            _focusShow,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: Text(
                              todayPctShow,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 75.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Constants.mtGreen,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const StageDiagram(
                                          'Smoke & Hope',
                                          'images/smoke_n_hope.jpg',
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const FittedBox(
                                  child: Text(
                                    'Smoke&Hope',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '103 ($peakSH)',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: (Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                bestStage('Smoke & Hope', bestSH),
                                bestClass('Smoke & Hope', bestSH, bestClassSH),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TodayTime(
                            newBestColorSH,
                            _controllerSH,
                            _focusSH,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: Text(
                              todayPctSH,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 75.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Constants.mtGreen,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const StageDiagram(
                                          'Outer Limits',
                                          'images/outer_limits.jpg',
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const FittedBox(
                                  child: Text(
                                    'Outer Limits',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '104 ($peakOL)',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: (Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                bestStage('Outer Limits', bestOL),
                                bestClass('Outer Limits', bestOL, bestClassOL),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TodayTime(
                            newBestColorOL,
                            _controllerOL,
                            _focusOL,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: Text(
                              todayPctOL,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 75.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Constants.mtGreen,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const StageDiagram(
                                          'Accelerator',
                                          'images/accelerator.jpg',
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const FittedBox(
                                  child: Text(
                                    'Accelerator',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '105 ($peakAcc)',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: (Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                bestStage('Accelerator', bestAcc),
                                bestClass('Accelerator', bestAcc, bestClassAcc),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TodayTime(
                            newBestColorAcc,
                            _controllerAcc,
                            _focusAcc,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: Text(
                              todayPctAcc,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 75.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Constants.mtGreen,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const StageDiagram(
                                          'The Pendulum',
                                          'images/pendulum.jpg',
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const FittedBox(
                                  child: Text(
                                    'Pendulum',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '106 ($peakPend)',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: (Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                bestStage('Pendulum', bestPend),
                                bestClass('Pendulum', bestPend, bestClassPend),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TodayTime(
                            newBestColorPend,
                            _controllerPend,
                            _focusPend,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: Text(
                              todayPctPend,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 75.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Constants.mtGreen,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const StageDiagram(
                                          'Speed Option',
                                          'images/speed_option.jpg',
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const FittedBox(
                                  child: Text(
                                    'Speed Option',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '107 ($peakSpeed)',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: (Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                bestStage('Speed Option', bestSpeed),
                                bestClass(
                                    'Speed Option', bestSpeed, bestClassSpeed),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TodayTime(
                            newBestColorSpeed,
                            _controllerSpeed,
                            _focusSpeed,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: Text(
                              todayPctSpeed,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 75.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Constants.mtGreen,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const StageDiagram(
                                          'Roundabout',
                                          'images/roundabout.jpg',
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const FittedBox(
                                  child: Text(
                                    'Roundabout',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '108 ($peakRound)',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: (Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                bestStage('Roundabout', bestRound),
                                bestClass(
                                    'Roundabout', bestRound, bestClassRound),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TodayTime(
                            newBestColorRound,
                            _controllerRound,
                            _focusRound,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          child: SizedBox(
                            width: 75.0,
                            child: Text(
                              todayPctRound,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 65.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 18.0,
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 20.0,
                                ),
                                child: const Text(
                                  'Time',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60.0,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 18.0,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 20,
                                  ),
                                  child: const Text(
                                    'Peak',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70.0,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 20.0,
                                  ),
                                  child: const Text(
                                    '%Peak',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 65.0,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 20,
                                  ),
                                  child: const Text(
                                    'Class',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox(
                              width: 60.0,
                              child: Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              width: 58.0,
                              child: Text(
                                todayTime,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 58.0,
                              child: Text(
                                todayPeak,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 58.0,
                              child: Text(
                                todayPct,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 55.0,
                              child: Text(
                                todayClass,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox(
                              width: 65.0,
                              child: Text(
                                'Overall',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              width: 60.0,
                              child: Text(
                                overallTime,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60.0,
                              child: Text(
                                overallPeak,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 65.0,
                              child: Text(
                                overallPct,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 55.0,
                              child: Text(
                                overallClass,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 48.0,
                        ),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4.0,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      side: const BorderSide(
                                        width: 1,
                                        color: Constants.mtGreen,
                                      ),
                                      primary: Colors.white),
                                  child: const Text(
                                    'Change Gun',
                                    style: TextStyle(
                                      color: Constants.mtGreen,
                                    ),
                                  ),
                                  onPressed: () {
                                    //Hide keypad when leaving the page.
                                    //Navigator.pop(context)] automatically
                                    //saves the data.
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 120.0,
                                child: Text(
                                  timeCuts,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 4.0,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      side: const BorderSide(
                                        width: 1,
                                        color: Constants.mtGreen,
                                      ),
                                      primary: Colors.white),
                                  child: const Text(
                                    'Clear Today',
                                    style: TextStyle(
                                      color: Constants.mtGreen,
                                    ),
                                  ),
                                  onPressed: () {
                                    _confirmClearToday();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//Update today and total times when TextFields lose focus.

  Future<void> _focus5Listener() async {
    if (_focus5.hasFocus) {
      _controller5.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller5.text.length);
    } else {
      if (_controller5.text == '') {
        todayPct5 = '';
      } else {
        todayPct5 = _calcTodayPercent(peak5, _controller5.text);

        if (best5 == '') {
          best5 = _controller5.text;
          bestClass5 = _calcBestClass(peak5, _controller5.text);
        } else if ((double.parse(_controller5.text) < double.parse(best5))) {
          _confirmNewBestTime(context, '5 to Go', _controller5.text, '5');

          _calcBestClass(peak5, best5);
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<void> _focusShowListener() async {
    if (_focusShow.hasFocus) {
      _controllerShow.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerShow.text.length);
    } else {
      if (_controllerShow.text == '') {
        todayPctShow = '';
      } else {
        todayPctShow = _calcTodayPercent(peakShow, _controllerShow.text);

        if (bestShow == '') {
          bestShow = _controllerShow.text;
          bestClassShow = _calcBestClass(peakShow, _controllerShow.text);
        } else if ((double.parse(_controllerShow.text) <
            double.parse(bestShow))) {
          _confirmNewBestTime(
              context, 'Showdown', _controllerShow.text, 'Show');

          _calcBestClass(peakShow, bestShow);
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<void> _focusSHListener() async {
    if (_focusSH.hasFocus) {
      _controllerSH.selection =
          TextSelection(baseOffset: 0, extentOffset: _controllerSH.text.length);
    } else {
      if (_controllerSH.text == '') {
        todayPctSH = '';
      } else {
        todayPctSH = _calcTodayPercent(peakSH, _controllerSH.text);

        if (bestSH == '') {
          bestSH = _controllerSH.text;
          bestClassSH = _calcBestClass(peakSH, _controllerSH.text);
        } else if ((double.parse(_controllerSH.text) < double.parse(bestSH))) {
          _confirmNewBestTime(
              context, 'Smoke & Hope', _controllerSH.text, 'SH');

          _calcBestClass(peakSH, bestSH);
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<void> _focusOLListener() async {
    if (_focusOL.hasFocus) {
      _controllerOL.selection =
          TextSelection(baseOffset: 0, extentOffset: _controllerOL.text.length);
    } else {
      if (_controllerOL.text == '') {
        todayPctOL = '';
      } else {
        todayPctOL = _calcTodayPercent(peakOL, _controllerOL.text);

        if (bestOL == '') {
          bestOL = _controllerOL.text;
          bestClassOL = _calcBestClass(peakOL, _controllerOL.text);
        } else if ((double.parse(_controllerOL.text) < double.parse(bestOL))) {
          _confirmNewBestTime(
              context, 'Outer Limits', _controllerOL.text, 'OL');

          _calcBestClass(peakOL, bestOL);
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<void> _focusAccListener() async {
    if (_focusAcc.hasFocus) {
      _controllerAcc.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerAcc.text.length);
    } else {
      if (_controllerAcc.text == '') {
        todayPctAcc = '';
      } else {
        todayPctAcc = _calcTodayPercent(peakAcc, _controllerAcc.text);

        if (bestAcc == '') {
          bestAcc = _controllerAcc.text;
          bestClassAcc = _calcBestClass(peakAcc, _controllerAcc.text);
        } else if ((double.parse(_controllerAcc.text) <
            double.parse(bestAcc))) {
          _confirmNewBestTime(
              context, 'Accelerator', _controllerAcc.text, 'Acc');

          _calcBestClass(peakAcc, bestAcc);
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<void> _focusPendListener() async {
    if (_focusPend.hasFocus) {
      _controllerPend.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerPend.text.length);
    } else {
      if (_controllerPend.text == '') {
        todayPctPend = '';
      } else {
        todayPctPend = _calcTodayPercent(peakPend, _controllerPend.text);

        if (bestPend == '') {
          bestPend = _controllerPend.text;
          bestClassPend = _calcBestClass(peakPend, _controllerPend.text);
        } else if ((double.parse(_controllerPend.text) <
            double.parse(bestPend))) {
          _confirmNewBestTime(
              context, 'Pendulum', _controllerPend.text, 'Pend');

          _calcBestClass(peakPend, bestPend);
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<void> _focusSpeedListener() async {
    if (_focusSpeed.hasFocus) {
      _controllerSpeed.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerSpeed.text.length);
    } else {
      if (_controllerSpeed.text == '') {
        todayPctSpeed = '';
      } else {
        todayPctSpeed = _calcTodayPercent(peakSpeed, _controllerSpeed.text);

        if (bestSpeed == '') {
          bestSpeed = _controllerSpeed.text;
          bestClassSpeed = _calcBestClass(peakSpeed, _controllerSpeed.text);
        } else if ((double.parse(_controllerSpeed.text) <
            double.parse(bestSpeed))) {
          _confirmNewBestTime(
              context, 'Speed Option', _controllerSpeed.text, 'Speed');

          _calcBestClass(peakSpeed, bestSpeed);
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<void> _focusRoundListener() async {
    if (_focusRound.hasFocus) {
      _controllerRound.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerRound.text.length);
    } else {
      if (_controllerRound.text == '') {
        todayPctRound = '';
      } else {
        todayPctRound = _calcTodayPercent(peakRound, _controllerRound.text);

        if (bestRound == '') {
          bestRound = _controllerRound.text;
          bestClassRound = _calcBestClass(peakRound, _controllerRound.text);
        } else if ((double.parse(_controllerRound.text) <
            double.parse(bestRound))) {
          _confirmNewBestTime(
              context, 'Roundabout', _controllerRound.text, 'Round');

          _calcBestClass(peakRound, bestRound);
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  //If shooter enters a time lower than the previous best, confirm that previous
  //best should be replaced
  _confirmNewBestTime(context, String name, String time, String textID) {
    String stageName = name;
    String stageTime = time;
    String bestID = textID;

    Alert(
      context: context,
      type: AlertType.info,
      title: "Confirm...",
      desc: "Enter a new best time of $stageTime for $stageName?",
      buttons: [
        DialogButton(
          color: Constants.mtGreen,
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            //Calculate the time cut from previous best, and add time cuts
            //to previous time cut value and display total time cuts at
            //bottom center of screen
            switch (bestID) {
              case '5':
                diff = (double.parse(best5) - double.parse(stageTime));

                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                      'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                      ' time on 5 to Go!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                best5 = stageTime;
                bestClass5 = _calcBestClass(peak5, stageTime);
                newBestColor5 = Colors.green;
                _calcOverall();

                break;

              case 'Show':
                diff = (double.parse(bestShow) - double.parse(stageTime));
                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                      'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                      ' time on Showdown!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                bestShow = stageTime;
                bestClassShow = _calcBestClass(peakShow, stageTime);
                newBestColorShow = Colors.green;
                _calcOverall();

                break;

              case 'SH':
                diff = (double.parse(bestSH) - double.parse(stageTime));
                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                      'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                      ' time on Smoke & Hope!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                bestSH = stageTime;
                bestClassSH = _calcBestClass(peakSH, stageTime);
                newBestColorSH = Colors.green;
                _calcOverall();

                break;
              case 'OL':
                diff = (double.parse(bestOL) - double.parse(stageTime));
                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                      'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                      ' time on Outer Limits!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                bestOL = stageTime;
                bestClassOL = _calcBestClass(peakOL, stageTime);
                newBestColorOL = Colors.green;
                _calcOverall();

                break;

              case 'Acc':
                diff = (double.parse(bestAcc) - double.parse(stageTime));
                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                      'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                      ' time on Accelerator!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                bestAcc = stageTime;
                bestClassAcc = _calcBestClass(peakAcc, stageTime);
                newBestColorAcc = Colors.green;
                _calcOverall();

                break;

              case 'Pend':
                diff = (double.parse(bestPend) - double.parse(stageTime));
                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                      'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                      ' time on Pendulum!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                bestPend = stageTime;
                bestClassPend = _calcBestClass(peakPend, stageTime);
                newBestColorPend = Colors.green;
                _calcOverall();

                break;

              case 'Speed':
                diff = (double.parse(bestSpeed) - double.parse(stageTime));
                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                      'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                      ' time on Speed Option!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                bestSpeed = stageTime;
                bestClassSpeed = _calcBestClass(peakSpeed, stageTime);
                newBestColorSpeed = Colors.green;
                _calcOverall();

                break;
              case 'Round':
                diff = (double.parse(bestRound) - double.parse(stageTime));
                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                      'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                      ' time on Roundabout!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                bestRound = stageTime;
                bestClassRound = _calcBestClass(peakRound, stageTime);
                newBestColorRound = Colors.green;
                _calcOverall();

                break;
            }
            _saveStageTimes();
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          color: Constants.mtGreen,
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ],
    ).show();
  }

  FontWeight getFontWeight(Color currentColor) {
    if (currentColor == Constants.mtGreen) {
      return FontWeight.bold;
    }
    return FontWeight.normal;
  }

  ///Call functions to update today and overall totals when TextField loses focus

  void _calcOverall() {
    _addOverallTimes();
    _addOverallPeak();
    _calcOverallPeak();
  }

  void _calcTotals() {
    if (showToday == 'On') {
      _addTodayTimes();
      _addTodayPeak();
      _calcTodayPeak();
    }
    _addOverallTimes();
    _addOverallPeak();
    _calcOverallPeak();
  }

  void _addTodayTimes() {
    double time5 = 0.0;
    double timeShow = 0.0;
    double timeSH = 0.0;
    double timeOL = 0.0;
    double timeAcc = 0.0;
    double timePend = 0.0;
    double timeSpeed = 0.0;
    double timeRound = 0.0;
    double todayTotal = 0.0;

    if (_controller5.text != '') {
      time5 = double.parse(_controller5.text);
    }
    if (_controllerShow.text != '') {
      timeShow = double.parse(_controllerShow.text);
    }
    if (_controllerSH.text != '') {
      timeSH = double.parse(_controllerSH.text);
    }
    if (_controllerOL.text != '') {
      timeOL = double.parse(_controllerOL.text);
    }
    if (_controllerAcc.text != '') {
      timeAcc = double.parse(_controllerAcc.text);
    }
    if (_controllerPend.text != '') {
      timePend = double.parse(_controllerPend.text);
    }
    if (_controllerSpeed.text != '') {
      timeSpeed = double.parse(_controllerSpeed.text);
    }
    if (_controllerRound.text != '') {
      timeRound = double.parse(_controllerRound.text);
    }

    todayTotal = time5 +
        timeShow +
        timeSH +
        timeOL +
        timeAcc +
        timePend +
        timeSpeed +
        timeRound;

    setState(() {
      if (todayTotal > 0) {
        todayTime = todayTotal.toStringAsFixed(2);
      } else {
        todayTime = '';
      }
    });
  }

  void _addOverallTimes() {
    double bTime5 = 0.0;
    double bTimeShow = 0.0;
    double bTimeSH = 0.0;
    double bTimeOL = 0.0;
    double bTimeAcc = 0.0;
    double bTimePend = 0.0;
    double bTimeSpeed = 0.0;
    double bTimeRound = 0.0;
    double overallTotal = 0.0;

    if (best5 != '') {
      bTime5 = double.parse(best5);
    }
    if (bestShow != '') {
      bTimeShow = double.parse(bestShow);
    }
    if (bestSH != '') {
      bTimeSH = double.parse(bestSH);
    }
    if (bestOL != '') {
      bTimeOL = double.parse(bestOL);
    }
    if (bestAcc != '') {
      bTimeAcc = double.parse(bestAcc);
    }
    if (bestPend != '') {
      bTimePend = double.parse(bestPend);
    }
    if (bestSpeed != '') {
      bTimeSpeed = double.parse(bestSpeed);
    }
    if (bestRound != '') {
      bTimeRound = double.parse(bestRound);
    }
    overallTotal = bTime5 +
        bTimeShow +
        bTimeSH +
        bTimeOL +
        bTimeAcc +
        bTimePend +
        bTimeSpeed +
        bTimeRound;

    setState(() {
      if (overallTotal > 0) {
        overallTime = overallTotal.toStringAsFixed(2);
      } else {
        overallTime = '';
      }
    });
  }

  void _addTodayPeak() {
    double p5 = 0.0;
    double pShow = 0.0;
    double pSH = 0.0;
    double pOL = 0.0;
    double pAcc = 0.0;
    double pPend = 0.0;
    double pSpeed = 0.0;
    double pRound = 0.0;
    double todPeak = 0.0;

    if (_controller5.text != '') {
      p5 = peak5;
    }
    if (_controllerShow.text != '') {
      pShow = peakShow;
    }
    if (_controllerSH.text != '') {
      pSH = peakSH;
    }
    if (_controllerOL.text != '') {
      pOL = peakOL;
    }
    if (_controllerAcc.text != '') {
      pAcc = peakAcc;
    }
    if (_controllerPend.text != '') {
      pPend = peakPend;
    }
    if (_controllerSpeed.text != '') {
      pSpeed = peakSpeed;
    }
    if (_controllerRound.text != '') {
      pRound = peakRound;
    }
    todPeak = p5 + pShow + pSH + pOL + pAcc + pPend + pSpeed + pRound;

    setState(() {
      if (todPeak > 0.0) {
        todayPeak = todPeak.toStringAsFixed(2);
      } else {
        todayPeak = '';
      }
    });
  }

  void _addOverallPeak() {
    double oP5 = 0.0;
    double oPShow = 0.0;
    double oPSH = 0.0;
    double oPOL = 0.0;
    double oPAcc = 0.0;
    double oPPend = 0.0;
    double oPSpeed = 0.0;
    double oPRound = 0.0;
    double oPeak = 0.0;

    if (best5 != '') {
      oP5 = peak5;
    }
    if (bestShow != '') {
      oPShow = peakShow;
    }
    if (bestSH != '') {
      oPSH = peakSH;
    }
    if (bestOL != '') {
      oPOL = peakOL;
    }
    if (bestAcc != '') {
      oPAcc = peakAcc;
    }
    if (bestPend != '') {
      oPPend = peakPend;
    }
    if (bestSpeed != '') {
      oPSpeed = peakSpeed;
    }
    if (bestRound != '') {
      oPRound = peakRound;
    }

    oPeak = oP5 + oPShow + oPSH + oPOL + oPAcc + oPPend + oPSpeed + oPRound;

    setState(() {
      if (oPeak > 0.0) {
        overallPeak = oPeak.toStringAsFixed(2);
      } else {
        overallPeak = '';
      }
    });
  }

  void _calcTodayPeak() {
    if (todayPeak != '') {
      todayPct = (double.parse(todayPeak) / double.parse(todayTime) * 100)
          .toStringAsFixed(2);

      if (double.parse(todayPct) < 40.0) {
        todayClass = 'D';
      } else if (double.parse(todayPct) < 60.0) {
        todayClass = 'C';
      } else if (double.parse(todayPct) < 75.0) {
        todayClass = 'B';
      } else if (double.parse(todayPct) < 85.0) {
        todayClass = 'A';
      } else if (double.parse(todayPct) < 95.0) {
        todayClass = 'M';
      } else {
        todayClass = 'GM';
      }
    } else {
      todayPct = '';
      todayClass = '';
    }
    setState(() {});
  }

  void _calcOverallPeak() {
    if (overallPeak != '') {
      overallPct = (double.parse(overallPeak) / double.parse(overallTime) * 100)
          .toStringAsFixed(2);

      if (overriddenClass != '') {
        overallClass = overriddenClass;
      } else {
        if (double.parse(overallPct) < 40.0) {
          overallClass = 'D';
        } else if (double.parse(overallPct) < 60.0) {
          overallClass = 'C';
        } else if (double.parse(overallPct) < 75.0) {
          overallClass = 'B';
        } else if (double.parse(overallPct) < 85.0) {
          overallClass = 'A';
        } else if (double.parse(overallPct) < 95.0) {
          overallClass = 'M';
        } else {
          overallClass = 'GM';
        }
      }
      setState(() {});
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  void _confirmClearToday() {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Confirm...",
      desc: "This will clear all \"Today\" times and cannot be undone.",
      buttons: [
        DialogButton(
          width: 20,
          color: Constants.mtGreen,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          color: Constants.mtGreen,
          child: const Text(
            "Clear",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () {
            setState(() {
              _controller5.text = '';
              _controllerShow.text = '';
              _controllerSH.text = '';
              _controllerOL.text = '';
              _controllerAcc.text = '';
              _controllerPend.text = '';
              _controllerSpeed.text = '';
              _controllerRound.text = '';

              todayPct5 = '';
              todayPctShow = '';
              todayPctSH = '';
              todayPctOL = '';
              todayPctAcc = '';
              todayPctPend = '';
              todayPctSpeed = '';
              todayPctRound = '';

              todayTime = '';
              todayPeak = '';
              todayPct = '';
              todayClass = '';

              timeCuts = '';
              timeShaved = 0.0;

              newBestColor5 = Colors.black;
              newBestColorShow = Colors.black;
              newBestColorSH = Colors.black;
              newBestColorOL = Colors.black;
              newBestColorAcc = Colors.black;
              newBestColorPend = Colors.black;
              newBestColorSpeed = Colors.black;
              newBestColorRound = Colors.black;
            });
            _saveStageTimes();
            Navigator.pop(context);
          },
          width: 20,
        ),
      ],
    ).show();
  }

//Save user's choice to show or hide today times using SharedPreferences
  Future<void> _setShowHide(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('showToday', value);
  }

//Determine whether user has chosen to show or hide today times
  Future<String> _getShowHide() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
//if showToday is null, return 'On'
    return preferences.getString('showToday') ?? 'On';
  }

//If user has overridden the class in this division, use SharedPreferences to
//save he updated class
  Future<void> _setClassOverride(String div, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(div, value);
  }

//Get overridden class (if any) for this division from SharedPreferences
  Future<String> _getClassOverride(String div) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //if overridden class is null, return empty string
    return preferences.getString(div) ?? '';
  }

//Respond to user selection from overflow popup menu
  void _matchMenuChoiceAction(String menuChoice) {
    switch (menuChoice) {
      case 'Clear Division Data':
        _clearDivisionData();

        break;

      case 'Track Class':
        if (_getClassifierCount() < 4) {
          _noClassification(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ClassTracker(
                  division: widget.currentDivision,
                  totPeak: overallPeak,
                  totTime: overallTime,
                  currClass: overallClass,
                );
              },
            ),
          );
        }
        break;

      case 'Override Class':
        _overrideClass(context);

        break;

      case 'Track Best Strings':
        _addTodayTimes();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BestStrings(
                currentDivision: widget.currentDivision,
                bestStr5: best5,
                bestStrShow: bestShow,
                bestStrSH: bestSH,
                bestStrOL: bestOL,
                bestStrAcc: bestAcc,
                bestStrPend: bestPend,
                bestStrSpeed: bestSpeed,
                bestStrRound: bestRound,
              );
            },
          ),
        );
        break;

      case 'Show/Hide Today Times':
        if (showToday == 'On') {
          setState(() {
            todayTime = '';
            todayPeak = '';
            todayPct = '';
            todayClass = '';

            _setShowHide('Off');
            _getShowHide().then((value) {
              _setShowHide('Off');
              showToday = value;
            });
          });
        } else if (showToday == 'Off') {
          _addTodayTimes();
          _addTodayPeak();
          _calcTodayPeak();

          _setShowHide('On');
          _getShowHide().then((value) {
            showToday = value;
          });
        }

        break;
    }
  }

//If the current peak percent doesn't support a class previously attained,
//allow user to override the calculated class and display the correct class.
  Future<void> _overrideClass(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Center(
              child: Text(
                'Tap current $divAbbrev class: ',
                style: const TextStyle(color: Constants.mtGreen),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  _setClassOverride(widget.currentDivision, 'GM');

                  overallClass = 'GM';

                  final snackBar = SnackBar(
                    backgroundColor: Constants.mtGreen,
                    content: Text(
                      'Your ${widget.currentDivision} class has been changed to GM.',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Center(
                  child: Text(
                    'GM',
                    style: TextStyle(
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  if (double.parse(overallPct) < 95.0) {
                    _setClassOverride(widget.currentDivision, 'M');

                    overallClass = 'M';

                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class has been changed to M.',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    _setClassOverride(widget.currentDivision, '');
                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class is already M or higher.',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Center(
                  child: Text(
                    'M',
                    style: TextStyle(
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  if (double.parse(overallPct) < 75.0) {
                    _setClassOverride(widget.currentDivision, 'A');

                    overallClass = 'A';

                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class has been changed to A.',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    _setClassOverride(widget.currentDivision, '');
                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class is already A or higher.',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  if (double.parse(overallPct) < 60.0) {
                    _setClassOverride(widget.currentDivision, 'B');

                    overallClass = 'B';

                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class has been changed to B.',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    _setClassOverride(widget.currentDivision, '');
                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class is already B or higher.',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Center(
                  child: Text(
                    'B',
                    style: TextStyle(
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  if (double.parse(overallPct) < 40.0) {
                    _setClassOverride(widget.currentDivision, 'C');

                    overallClass = 'C';

                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class has been changed to C.',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    _setClassOverride(widget.currentDivision, '');
                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class is already C or higher.',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Center(
                  child: Text(
                    'C',
                    style: TextStyle(
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: const BorderSide(
                            width: 1, color: Constants.mtGreen),
                        primary: Constants.mtGreen),
                    onPressed: () {
                      Navigator.pop(context);

                      _setClassOverride(widget.currentDivision, '');

                      overriddenClass = '';

                      _calcOverallPeak();
                      final snackBar = SnackBar(
                        backgroundColor: Constants.mtGreen,
                        content: Text(
                          'Any ${widget.currentDivision} class override has been removed.',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text(
                      'Remove class override',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

//If user taps best time, calculate average string time to achieve that score
  //and display it in Snackbar (definition follows method)
  void _calcBestAvg(String stage, String bestTime) {
    double bestAvg;
    if (stage == 'Outer Limits') {
      bestAvg = (double.parse(bestTime) / 3);
    } else {
      bestAvg = (double.parse(bestTime) / 4);
    }
    _snackBarBestAvg(stage, bestAvg);
  }

//Same as above if user taps best class instead of best time
  InkWell bestStage(String stage, String bestStage) {
    return InkWell(
      highlightColor: Constants.mtGreen,
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _calcBestAvg(stage, bestStage);
      },
      child: Text(
        bestStage,
        style: const TextStyle(fontSize: 14.0),
        textAlign: TextAlign.left,
      ),
    );
  }

  InkWell bestClass(String stage, String bestString, String bestClass) {
    return InkWell(
      highlightColor: Constants.mtGreen,
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _calcBestAvg(stage, bestString);
      },
      child: Text(
        bestClass,
        style: const TextStyle(fontSize: 14.0),
        textAlign: TextAlign.left,
      ),
    );
  }

  //Snackbar called from _calcBestAvg above to display best average strings times
  // with an action to show best average times needed to advance in classification
  void _snackBarBestAvg(String stage, double bestAvg) {
    final snackBar = SnackBar(
      backgroundColor: Constants.mtGreen,
      content: Text(
        'Best average string $stage is ${bestAvg.toStringAsFixed(2)}',
        textAlign: TextAlign.center,
      ),
      action: SnackBarAction(
        label: 'More',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TimesNeeded(
                  division: widget.currentDivision,
                  stage: stage,
                  divAbb: divAbbrev,
                  bestAvgStr: bestAvg,
                );
              },
            ),
          );
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//Save all displayed times when a TextField loses focus or user taps back button.
  _saveStageTimes() async {
    StageTimes stageTimes = StageTimes();

    stageTimes.fiveToGo = _controller5.text;
    stageTimes.showdown = _controllerShow.text;
    stageTimes.smokeAndHope = _controllerSH.text;
    stageTimes.outerLimits = _controllerOL.text;
    stageTimes.accelerator = _controllerAcc.text;
    stageTimes.pendulum = _controllerPend.text;
    stageTimes.speedOption = _controllerSpeed.text;
    stageTimes.roundabout = _controllerRound.text;

    stageTimes.best5 = best5;
    stageTimes.bestShow = bestShow;
    stageTimes.bestSH = bestSH;
    stageTimes.bestOL = bestOL;
    stageTimes.bestAcc = bestAcc;
    stageTimes.bestPend = bestPend;
    stageTimes.bestSpeed = bestSpeed;
    stageTimes.bestRound = bestRound;

    if (timeShaved == null || timeShaved == 0.0) {
      stageTimes.shavedTime = '';
    } else {
      stageTimes.shavedTime = timeShaved.toStringAsFixed(2);
    }

    await helper.insertStages(divAbbrev, stageTimes);
  }

//Restore from database all previously entered and displayed times when user revisits screen
  _getStageTimes() async {
    int numRows = await helper.getCount(divAbbrev);

    StageTimes stageTimes = await helper.queryStageTimes(divAbbrev, numRows);
    if (numRows == 0) {
      timeCuts = '';
    } else {
      _controller5.text = stageTimes.fiveToGo;
      stageTimes.fiveToGo != ''
          ? todayPct5 = _calcTodayPercent(peak5, stageTimes.fiveToGo)
          : todayPct5 = '';
      _controllerShow.text = stageTimes.showdown;
      stageTimes.showdown != ''
          ? todayPctShow = _calcTodayPercent(peakShow, stageTimes.showdown)
          : todayPctShow = '';
      _controllerSH.text = stageTimes.smokeAndHope;
      stageTimes.smokeAndHope != ''
          ? todayPctSH = _calcTodayPercent(peakSH, stageTimes.smokeAndHope)
          : todayPctSH = '';
      _controllerOL.text = stageTimes.outerLimits;
      stageTimes.outerLimits != ''
          ? todayPctOL = _calcTodayPercent(peakOL, stageTimes.outerLimits)
          : todayPctOL = '';
      _controllerAcc.text = stageTimes.accelerator;
      stageTimes.accelerator != ''
          ? todayPctAcc = _calcTodayPercent(peakAcc, stageTimes.accelerator)
          : todayPctAcc = '';
      _controllerPend.text = stageTimes.pendulum;
      stageTimes.pendulum != ''
          ? todayPctPend = _calcTodayPercent(peakPend, stageTimes.pendulum)
          : todayPctPend = '';
      _controllerSpeed.text = stageTimes.speedOption;
      stageTimes.speedOption != ''
          ? todayPctSpeed = _calcTodayPercent(peakSpeed, stageTimes.speedOption)
          : todayPctSpeed = '';
      _controllerRound.text = stageTimes.roundabout;
      stageTimes.roundabout != ''
          ? todayPctRound = _calcTodayPercent(peakRound, stageTimes.roundabout)
          : todayPctRound = '';

      stageTimes.best5 != null && stageTimes.best5 != ''
          ? best5 = stageTimes.best5
          : best5 = '';

      if (best5 != '') {
        bestClass5 = _calcBestClass(peak5, best5);
        if (best5 == _controller5.text) {
          newBestColor5 = Colors.green;
        }
      }

      stageTimes.bestShow != null
          ? bestShow = stageTimes.bestShow
          : bestShow = '';
      if (bestShow != '') {
        bestClassShow = _calcBestClass(peakShow, bestShow);
        if (bestShow == _controllerShow.text) {
          newBestColorShow = Colors.green;
        }
      }

      stageTimes.bestSH != null ? bestSH = stageTimes.bestSH : bestSH = '';
      if (bestSH != '') {
        bestClassSH = _calcBestClass(peakSH, bestSH);
        if (bestSH == _controllerSH.text) {
          newBestColorSH = Colors.green;
        }
      }

      stageTimes.bestOL != null ? bestOL = stageTimes.bestOL : bestOL = '';
      if (bestOL != '') {
        bestClassOL = _calcBestClass(peakOL, bestOL);
        if (bestOL == _controllerOL.text) {
          newBestColorOL = Colors.green;
        }
      }

      stageTimes.bestAcc != null ? bestAcc = stageTimes.bestAcc : bestAcc = '';
      if (bestAcc != '') {
        bestClassAcc = _calcBestClass(peakAcc, bestAcc);
        if (bestAcc == _controllerAcc.text) {
          newBestColorAcc = Colors.green;
        }
      }

      stageTimes.bestPend != null
          ? bestPend = stageTimes.bestPend
          : bestPend = '';
      if (bestPend != '') {
        bestClassPend = _calcBestClass(peakPend, bestPend);
        if (bestPend == _controllerPend.text) {
          newBestColorPend = Colors.green;
        }
      }

      stageTimes.bestSpeed != null
          ? bestSpeed = stageTimes.bestSpeed
          : bestSpeed = '';
      if (bestSpeed != '') {
        bestClassSpeed = _calcBestClass(peakSpeed, bestSpeed);
        if (bestSpeed == _controllerSpeed.text) {
          newBestColorSpeed = Colors.green;
        }
      }

      stageTimes.bestRound != null
          ? bestRound = stageTimes.bestRound
          : bestRound = '';
      if (bestRound != '') {
        bestClassRound = _calcBestClass(peakRound, bestRound);
        if (bestRound == _controllerRound.text) {
          newBestColorRound = Colors.green;
        }
      }

      best5 = stageTimes.best5;
      bestShow = stageTimes.bestShow;
      bestSH = stageTimes.bestSH;
      bestOL = stageTimes.bestOL;
      bestAcc = stageTimes.bestAcc;
      bestPend = stageTimes.bestPend;
      bestSpeed = stageTimes.bestSpeed;
      bestRound = stageTimes.bestRound;

      if (stageTimes.shavedTime == null || stageTimes.shavedTime == '') {
        timeShaved = 0.0;
        timeCuts = '';
      } else {
        timeShaved = double.parse(stageTimes.shavedTime);

        timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
      }
    }
    _calcTotals();
  }

//Calculate and display the class represented by the best stage time for the division
  String _calcBestClass(double peak, String timeText) {
    double bestClass = (peak / double.parse(timeText) * 100);

    if (bestClass < 40.0) {
      return '/D';
    } else if (bestClass < 60) {
      return '/C';
    } else if (bestClass < 75) {
      return '/B';
    } else if (bestClass < 85) {
      return '/A';
    } else if (bestClass < 95) {
      return '/M';
    } else {
      return '/G';
    }
  }

//Calculate and display the percent and class for each today stage time entered
  static String _calcTodayPercent(double peak, String timeText) {
    double todayPercent = (peak / double.parse(timeText) * 100);

    if (todayPercent < 40.0) {
      return '${todayPercent.toStringAsFixed(2)}/D';
    } else if (todayPercent < 60.0) {
      return '${todayPercent.toStringAsFixed(2)}/C';
    } else if (todayPercent < 75.0) {
      return '${todayPercent.toStringAsFixed(2)}/B';
    } else if (todayPercent < 85.0) {
      return '${todayPercent.toStringAsFixed(2)}/A';
    } else if (todayPercent < 95.0) {
      return '${todayPercent.toStringAsFixed(2)}/M';
    } else {
      return '${todayPercent.toStringAsFixed(2)}/G';
    }
  }

//Confirm that user really wants to clear all division data. If so, clear
// data by saving empty strings to database
  void _clearDivisionData() {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Confirm...",
      desc:
          "This will clear all $divAbbrev data, including best stage and best string times, and cannot be undone.",
      buttons: [
        DialogButton(
          width: 20,
          color: Constants.mtGreen,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          color: Constants.mtGreen,
          child: const Text(
            "Clear",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () {
            _controller5.text = '';
            _controllerShow.text = '';
            _controllerSH.text = '';
            _controllerOL.text = '';
            _controllerAcc.text = '';
            _controllerPend.text = '';
            _controllerSpeed.text = '';
            _controllerRound.text = '';

            todayPct5 = '';
            todayPctShow = '';
            todayPctSH = '';
            todayPctOL = '';
            todayPctAcc = '';
            todayPctPend = '';
            todayPctSpeed = '';
            todayPctRound = '';

            todayTime = '';
            todayPeak = '';
            todayPct = '';
            todayClass = '';

            overallTime = '';
            overallPeak = '';
            overallPct = '';
            overallClass = '';

            best5 = '';
            bestClass5 = '';
            bestShow = '';
            bestClassShow = '';
            bestSH = '';
            bestClassSH = '';
            bestOL = '';
            bestClassOL = '';
            bestAcc = '';
            bestClassAcc = '';
            bestPend = '';
            bestClassPend = '';
            bestSpeed = '';
            bestClassSpeed = '';
            bestRound = '';
            bestClassRound = '';

            timeCuts = '';

            timeShaved = 0.0;

            _setClassOverride(widget.currentDivision, '');

            overriddenClass = '';

            _saveStageTimes();
            _clearStringTimes();
            Navigator.pop(context);
            final snackBar = SnackBar(
              backgroundColor: Constants.mtGreen,
              content: Text(
                '$divAbbrev data cleared.',
                textAlign: TextAlign.center,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          width: 20,
        ),
      ],
    ).show();
  }

  _clearStringTimes() async {
    StringTimes stringTimes = StringTimes();
    setState(() {
      stringTimes.fiveToGo = '';
      stringTimes.showdown = '';
      stringTimes.smokeAndHope = '';
      stringTimes.outerLimits = '';
      stringTimes.accelerator = '';
      stringTimes.pendulum = '';
      stringTimes.speedOption = '';
      stringTimes.roundabout = '';
    });
    // stringTimes.fiveToGo = '';
    // stringTimes.showdown = '';
    // stringTimes.smokeAndHope = '';
    // stringTimes.outerLimits = '';
    // stringTimes.accelerator = '';
    // stringTimes.pendulum = '';
    // stringTimes.speedOption = '';
    // stringTimes.roundabout = '';

    await helper.insertStrings(divAbbrev + 'STR', stringTimes);
  }

//Determine if user has scored at least 4 classifier stages before displaying
  //Track Class screen
  int _getClassifierCount() {
    int count = 0;

    if (best5 != '') {
      count++;
    }
    if (bestShow != '') {
      count++;
    }
    if (bestSH != '') {
      count++;
    }
    if (bestOL != '') {
      count++;
    }
    if (bestAcc != '') {
      count++;
    }
    if (bestPend != '') {
      count++;
    }
    if (bestSpeed != '') {
      count++;
    }
    if (bestRound != '') {
      count++;
    }
    return count;
  }

  _noClassification(context) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "",
      desc:
          'You have not entered a minimum of four classifier stage scores for this division.',
      buttons: [
        DialogButton(
          color: Constants.mtGreen,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}

class _HeadText extends StatelessWidget {
  const _HeadText({Key key, @required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
