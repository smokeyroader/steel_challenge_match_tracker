// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'string_avg_needed.dart';
import 'best_strings.dart';
import 'constants.dart';
import 'database_helper.dart';
import 'track_class.dart';
import 'stage_diagrams.dart';
import 'today_text_field.dart';

class MatchTracker extends StatefulWidget {
  //Set current division sent from mt_home_page.dart.
  final String currentDivision;
  final String appSounds; //Determines whether user has turned off app sounds.

  const MatchTracker({
    super.key,
    required this.currentDivision,
    required this.appSounds, //If 'On,' sounds will play; if 'Off,' sounds will be muted.
  });

  @override
  MatchTrackerState createState() => MatchTrackerState();
}

class MatchTrackerState extends State<MatchTracker> {
  late AudioPlayer player; //Declare audio player for playing app sounds.

  //Establish connection with MatchTracker.db.
  DatabaseHelper helper = DatabaseHelper.instance;

  //Line below needed to display Snackbars.
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

  //Declare focusNodes to detect change in focus of TextFields.
  late FocusNode _focus5;
  late FocusNode _focusShow;
  late FocusNode _focusSH;
  late FocusNode _focusOL;
  late FocusNode _focusAcc;
  late FocusNode _focusPend;
  late FocusNode _focusSpeed;
  late FocusNode _focusRound;

  String? showToday;
  late String overriddenClass = '';

  late String stageName;

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

  late double peak5;
  late double peakShow;
  late double peakSH;
  late double peakOL;
  late double peakAcc;
  late double peakPend;
  late double peakSpeed;
  late double peakRound;

  late double diff;
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

  bool dialogShowing = false;

// Permit changing today time font to green and bold if a new personal
//best is entered.

  Color newBestColor5 = Colors.black;
  Color newBestColorShow = Colors.black;
  Color newBestColorSH = Colors.black;
  Color newBestColorOL = Colors.black;
  Color newBestColorAcc = Colors.black;
  Color newBestColorPend = Colors.black;
  Color newBestColorSpeed = Colors.black;
  Color newBestColorRound = Colors.black;

  late String divAbbrev;

  @override
  void initState() {
    player = AudioPlayer(); //Initialize audio player (from just_audio pkg.).
    super.initState();

    _focus5 = FocusNode();
    _focusShow = FocusNode();
    _focusSH = FocusNode();
    _focusOL = FocusNode();
    _focusAcc = FocusNode();
    _focusPend = FocusNode();
    _focusSpeed = FocusNode();
    _focusRound = FocusNode();

    //Check whether today times are shown (true) or hidden (false).
    _getShowHide().then((value) {
      showToday = value;
    });

    //Check whether class has been overridden.
    _getClassOverride(widget.currentDivision).then((value) {
      overriddenClass = value;
    });

    //Set division abbreviation to be used to access the correct table when
    //saving and retrieving times.
    divAbbrev = Constants.getDivAbbrev(widget.currentDivision);

    //Get and set best and today times from database.
    _getStageTimes();

    //Call method to calculate and show all current total times after
    //retrieval from database.
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
    player.dispose();
    _focus5.dispose();
    _focusShow.dispose();
    _focusSH.dispose();
    _focusOL.dispose();
    _focusAcc.dispose();
    _focusPend.dispose();
    _focusSpeed.dispose();
    _focusRound.dispose();

    _controller5.dispose();
    _controllerShow.dispose();
    _controllerSH.dispose();
    _controllerOL.dispose();
    _controllerPend.dispose();
    _controllerAcc.dispose();
    _controllerSpeed.dispose();
    _controllerRound.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Get peak times for the division from constants class.
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
        foregroundColor: Colors.white,
        //Create popup menu (stacked dots at the right of AppBar)
        //Menu is populated with a list from the Constants.dart file.
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
      // (to account for ios keyboard that does not have a "Done" key).
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        //Override both back buttons to save data when tapped even if the
        //user has not tapped outside the last (focused) time text field.
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didpop, Object? result) async {
            // debugPrint('PopScope called. Value of didpop is $didpop.');
            _onBackPressed(didpop);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                              child: Card(
                                elevation: 8,
                                shadowColor: Constants.mtGreen,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, bottom: 4, left: 8, right: 8),
                                  child: Text(
                                    widget.currentDivision,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.mtGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                      color: Constants.mtGreen,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          SizedBox(
                            width: 65,
                            child: _HeadText(
                              text: 'Stage',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 24.0,
                            ),
                            child: SizedBox(
                              width: 60,
                              child: _HeadText(
                                text: 'Best',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: SizedBox(
                              width: 60,
                              child: _HeadText(
                                text: 'Today',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 75,
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
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Briefly show color when user taps a stage name
                                //to display the stage diagram (and play a sound
                                //of shooting the stage if app sounds is turned on).
                                InkWell(
                                  highlightColor: Constants.mtGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StageDiagram(
                                            'Five to Go',
                                            'images/five_to_go.jpg',
                                          );
                                        },
                                      ),
                                    );
                                    //Only play a sound if app sounds are 'On.'
                                    if (widget.appSounds == 'On') {
                                      await player
                                          .setAsset('sounds/five_to_go_2.mp3');
                                      player.play();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        '5 to Go',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '101 ($peak5)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
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
                              width: 75,
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
                              height: 20,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  todayPct5,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  highlightColor: Constants.mtGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StageDiagram(
                                            'Showdown',
                                            'images/showdown.jpg',
                                          );
                                        },
                                      ),
                                    );
                                    if (widget.appSounds == 'On') {
                                      await player
                                          .setAsset('sounds/showdown.mp3');
                                      player.play();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Showdown',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '102 ($peakShow)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
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
                              width: 75,
                              child: (Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  bestStage('Showdown', bestShow),
                                  bestClass(
                                      'Showdown', bestShow, bestClassShow),
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
                              height: 20,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  todayPctShow,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  highlightColor: Constants.mtGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StageDiagram(
                                            'Smoke & Hope',
                                            'images/smoke_n_hope.jpg',
                                          );
                                        },
                                      ),
                                    );
                                    if (widget.appSounds == 'On') {
                                      await player
                                          .setAsset('sounds/smoke_n_hope.mp3');
                                      player.play();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 24.0),
                                        child: Text(
                                          'Smoke&Hope',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '103 ($peakSH)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
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
                              width: 75,
                              child: (Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  bestStage('Smoke & Hope', bestSH),
                                  bestClass(
                                      'Smoke & Hope', bestSH, bestClassSH),
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
                              height: 20,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  todayPctSH,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  highlightColor: Constants.mtGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StageDiagram(
                                            'Outer Limits',
                                            'images/outer_limits.jpg',
                                          );
                                        },
                                      ),
                                    );
                                    if (widget.appSounds == 'On') {
                                      await player
                                          .setAsset('sounds/outer_limits.mp3');
                                      player.play();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'Outer Limits',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '104 ($peakOL)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
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
                              width: 75,
                              child: (Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  bestStage('Outer Limits', bestOL),
                                  bestClass(
                                      'Outer Limits', bestOL, bestClassOL),
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
                              height: 20,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  todayPctOL,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  highlightColor: Constants.mtGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StageDiagram(
                                            'Accelerator',
                                            'images/accelerator.jpg',
                                          );
                                        },
                                      ),
                                    );
                                    if (widget.appSounds == 'On') {
                                      await player
                                          .setAsset('sounds/accelerator.mp3');
                                      player.play();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          'Accelerator',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '105 ($peakAcc)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
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
                              width: 75,
                              child: (Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  bestStage('Accelerator', bestAcc),
                                  bestClass(
                                      'Accelerator', bestAcc, bestClassAcc),
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
                              height: 20,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  todayPctAcc,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  highlightColor: Constants.mtGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StageDiagram(
                                            'The Pendulum',
                                            'images/pendulum.jpg',
                                          );
                                        },
                                      ),
                                    );
                                    if (widget.appSounds == 'On') {
                                      await player
                                          .setAsset('sounds/pendulum.mp3');
                                      player.play();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          'Pendulum',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '106 ($peakPend)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
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
                              width: 75,
                              child: (Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  bestStage('Pendulum', bestPend),
                                  bestClass(
                                      'Pendulum', bestPend, bestClassPend),
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
                              height: 20,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  todayPctPend,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  highlightColor: Constants.mtGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StageDiagram(
                                            'Speed Option',
                                            'images/speed_option.jpg',
                                          );
                                        },
                                      ),
                                    );
                                    if (widget.appSounds == 'On') {
                                      await player
                                          .setAsset('sounds/speed_option.mp3');
                                      player.play();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 24.0),
                                        child: Text(
                                          'Speed Option',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '107 ($peakSpeed)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
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
                              width: 75,
                              child: (Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  bestStage('Speed Option', bestSpeed),
                                  bestClass('Speed Option', bestSpeed,
                                      bestClassSpeed),
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
                              height: 20,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  todayPctSpeed,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  highlightColor: Constants.mtGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StageDiagram(
                                            'Roundabout',
                                            'images/roundabout.jpg',
                                          );
                                        },
                                      ),
                                    );
                                    if (widget.appSounds == 'On') {
                                      await player
                                          .setAsset('sounds/roundabout.mp3');
                                      player.play();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'Roundabout',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '108 ($peakRound)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
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
                              width: 75,
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
                              height: 20,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  todayPctRound,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
                                width: 60,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  right: 18.0,
                                ),
                                child: SizedBox(
                                  height: 18,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        'Time',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                                child: SizedBox(
                                  height: 18,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Peak',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 70,
                                child: SizedBox(
                                  height: 18,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '%Peak',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 65,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 8.0,
                                  ),
                                  child: SizedBox(
                                    height: 18,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        'Class',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
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
                                height: 20,
                                width: 60,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    'Today',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 58,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    todayTime,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 58,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    todayPeak,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 58,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    todayPct,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 70,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    todayClass,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.left,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                                width: 60,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    'Overall',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 58,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    overallTime,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 58,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    overallPeak,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 58,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    overallPct,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 70,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    overallClass,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 48,
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
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          width: 1,
                                          color: Constants.mtGreen,
                                        )),
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

                                      //If the user has not tapped outside the active field before
                                      //attempting to change guns, remove focus programmatically to
                                      //activate the _saveStageTimes method.

                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');

                                      //If the user has not tapped outside the acvtive field after entering a time
                                      //that would be a new best time for that stage, delay the excution of
                                      //the code that follows to allow time for the _confirmNewBestTime method to
                                      //display the new best time alert (and set the dialogShowing flag to true).
                                      //Otherwise, the screen will pop to the home page before the alert can display
                                      //and the app will freeze.
                                      Timer(const Duration(milliseconds: 300),
                                          () {
                                        //Only leave the page if the new best time alert dialog is not showing
                                        if (!dialogShowing) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    timeCuts,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
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
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          width: 1,
                                          color: Constants.mtGreen,
                                        )),
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
  //best should be replaced.
  _confirmNewBestTime(context, String name, String time, String textID) {
    String stageName = name;
    String stageTime = time;
    String bestID = textID;
    dialogShowing = true;

    Alert(
      context: context,
      type: AlertType.none,
      title: "Confirm...",
      desc: "Enter a new best time of $stageTime for $stageName?",
      buttons: [
        DialogButton(
          color: Constants.mtGreen,
          onPressed: () async {
            dialogShowing = false;
            if (widget.appSounds == 'On') {
              await player.setAsset('sounds/success.mp3');
              player.play();
            }

            //Calculate the day's time cuts from previous best, and add time cuts
            //to previous time cut value and display total time cuts today at
            //bottom center of screen.
            switch (bestID) {
              case '5':
                diff = (double.parse(best5) - double.parse(stageTime));

                timeShaved += diff;
                timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                final snackBar = SnackBar(
                  backgroundColor: Constants.mtGreen,
                  content: Text(
                    'You cut ${diff.toStringAsFixed(2)} seconds from your best'
                    ' time on 5 to Go!',
                    textAlign: TextAlign.center,
                  ),
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
                    ' time on Showdown!',
                    textAlign: TextAlign.center,
                  ),
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
                    ' time on Smoke & Hope!',
                    textAlign: TextAlign.center,
                  ),
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
                    ' time on Outer Limits!',
                    textAlign: TextAlign.center,
                  ),
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
                    ' time on Accelerator!',
                    textAlign: TextAlign.center,
                  ),
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
                    ' time on Pendulum!',
                    textAlign: TextAlign.center,
                  ),
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
                    ' time on Speed Option!',
                    textAlign: TextAlign.center,
                  ),
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
                    ' time on Roundabout!',
                    textAlign: TextAlign.center,
                  ),
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
            //Remove focus without triggering the best time dialog again
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          width: 120,
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        DialogButton(
          color: Constants.mtGreen,
          onPressed: () {
            dialogShowing = false;
            Navigator.pop(context);
            //Remove focus without triggering the best time dialog again
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          width: 120,
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
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

  ///Call functions to update today and overall totals when TextField loses focus.

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
          child: const Text(
            "Clear",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    ).show();
  }

//Save user's choice to show or hide today times using SharedPreferences.
  Future<void> _setShowHide(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('showToday', value);
  }

//Determine whether user has chosen to show or hide today times.
  Future<String> _getShowHide() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
//if showToday is null, return 'On.'
    return preferences.getString('showToday') ?? 'On';
  }

//If user has overridden the class in this division, use SharedPreferences to
//save the updated class.
  Future<void> _setClassOverride(String div, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(div, value);
  }

//Get overridden class (if any) for this division from SharedPreferences.
  Future<String> _getClassOverride(String div) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //if overridden class is null, return empty string.
    return preferences.getString(div) ?? '';
  }

//Respond to user selection from overflow popup menu.
  void _matchMenuChoiceAction(String menuChoice) async {
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
                currBest5: best5,
                currBestShow: bestShow,
                currBestSH: bestSH,
                currBestOL: bestOL,
                currBestAcc: bestAcc,
                currBestPend: bestPend,
                currBestSpeed: bestSpeed,
                currBestRound: bestRound,
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

            var snackBar = SnackBar(
              backgroundColor: Constants.mtGreen,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Today times hidden', textAlign: TextAlign.center),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 20,
                      width: 50,
                      child: FaIcon(Icons.visibility_off_sharp),
                    ),
                  ),
                ],
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            _setShowHide('Off');
            _getShowHide().then((value) async {
              showToday = value;

              if (widget.appSounds == 'On') {
                await player.setAsset('sounds/ding.mp3');
                player.play();
              }
            });
          });
        } else if (showToday == 'Off') {
          _addTodayTimes();
          _addTodayPeak();
          _calcTodayPeak();

          var snackBar = SnackBar(
            backgroundColor: Constants.mtGreen,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Today times showing', textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    height: 20,
                    width: 50,
                    child: FaIcon(Icons.visibility),
                  ),
                ),
              ],
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          _setShowHide('On');
          _getShowHide().then((value) async {
            showToday = value;

            if (widget.appSounds == 'On') {
              await player.setAsset('sounds/ding.mp3');
              player.play();
            }
          });
        }

        break;
    }
  }

//If the current peak percent doesn't support a class previously attained,
//allow user to override the calculated class and display the correct class.
//Do not allow choice of a class lower than supported by the current percentage.
  Future<String?> _overrideClass(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            title: Center(
              child: Text(
                'Tap current $divAbbrev class: ',
                style: const TextStyle(color: Constants.mtGreen),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  _setClassOverride(widget.currentDivision, 'GM');

                  overallClass = 'GM';

                  final snackBar = SnackBar(
                    backgroundColor: Constants.mtGreen,
                    content: Text(
                      'Your ${widget.currentDivision} class has been changed to GM.',
                      textAlign: TextAlign.center,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  if (widget.appSounds == 'On') {
                    await player.setAsset('sounds/ding.mp3');
                    player.play();
                  }
                },
                child: const Center(
                  child: Text(
                    'GM',
                    style: TextStyle(
                      fontSize: 18,
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  if (double.parse(overallPct) < 95.0) {
                    _setClassOverride(widget.currentDivision, 'M');

                    overallClass = 'M';

                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class has been changed to M.',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (widget.appSounds == 'On') {
                      await player.setAsset('sounds/ding.mp3');
                      player.play();
                    }
                  } else {
                    _setClassOverride(widget.currentDivision, '');
                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class is already M or higher.',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (widget.appSounds == 'On') {
                      await player.setAsset('sounds/error.mp3');
                      player.play();
                    }
                  }
                },
                child: const Center(
                  child: Text(
                    'M',
                    style: TextStyle(
                      fontSize: 18,
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  if (double.parse(overallPct) < 75.0) {
                    _setClassOverride(widget.currentDivision, 'A');

                    overallClass = 'A';

                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class has been changed to A.',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (widget.appSounds == 'On') {
                      await player.setAsset('sounds/ding.mp3');
                      player.play();
                    }
                  } else {
                    _setClassOverride(widget.currentDivision, '');
                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class is already A or higher.',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (widget.appSounds == 'On') {
                      await player.setAsset('sounds/error.mp3');
                      player.play();
                    }
                  }
                },
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: 18,
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  if (double.parse(overallPct) < 60.0) {
                    _setClassOverride(widget.currentDivision, 'B');

                    overallClass = 'B';

                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class has been changed to B.',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (widget.appSounds == 'On') {
                      await player.setAsset('sounds/ding.mp3');
                      player.play();
                    }
                  } else {
                    _setClassOverride(widget.currentDivision, '');
                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class is already B or higher.',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (widget.appSounds == 'On') {
                      await player.setAsset('sounds/error.mp3');
                      player.play();
                    }
                  }
                },
                child: const Center(
                  child: Text(
                    'B',
                    style: TextStyle(
                      fontSize: 18,
                      color: Constants.mtGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  _calcOverallPeak();
                  if (double.parse(overallPct) < 40.0) {
                    _setClassOverride(widget.currentDivision, 'C');

                    overallClass = 'C';

                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class has been changed to C.',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (widget.appSounds == 'On') {
                      await player.setAsset('sounds/ding.mp3');
                      player.play();
                    }
                  } else {
                    _setClassOverride(widget.currentDivision, '');
                    final snackBar = SnackBar(
                      backgroundColor: Constants.mtGreen,
                      content: Text(
                        'Your ${widget.currentDivision} class is already C or higher.',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (widget.appSounds == 'On') {
                      await player.setAsset('sounds/error.mp3');
                      player.play();
                    }
                  }
                },
                child: const Center(
                  child: Text(
                    'C',
                    style: TextStyle(
                      fontSize: 18,
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
                        backgroundColor: Constants.mtGreen),
                    onPressed: () async {
                      Navigator.pop(context);

                      _setClassOverride(widget.currentDivision, '');

                      overriddenClass = '';

                      _calcOverallPeak();
                      final snackBar = SnackBar(
                        backgroundColor: Constants.mtGreen,
                        content: Text(
                          'Any ${widget.currentDivision} class override has been removed.',
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      if (widget.appSounds == 'On') {
                        await player.setAsset('sounds/ding.mp3');
                        player.play();
                      }
                    },
                    child: const FittedBox(
                      child: Text(
                        'Remove class override',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

//If user presses and holds a populated best time field, calculate average string
// time to achieve that score and display it in Snackbar (Snackbar definition follows method).
  void _calcBestAvg(String stage, String bestTime) {
    double bestAvg;
    if (stage == 'Outer Limits') {
      bestAvg = (double.parse(bestTime) / 3);
    } else {
      bestAvg = (double.parse(bestTime) / 4);
    }
    _snackBarBestAvg(stage, bestAvg);
  }

  InkWell bestStage(String stage, String bestStage) {
    return InkWell(
      highlightColor: Constants.mtGreen,
      borderRadius: BorderRadius.circular(5),
      //A tap (instead of press and hold) of a populated or unpopulated best time
      //field will dismiss the keyboard and calculate totals (the expected behavior).
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      //A press and hold (instead of a tap) of a populated field will trigger a
      //snackbar to show average string time.
      onLongPress: () async {
        if (bestStage != '') {
          if (widget.appSounds == 'On') {
            await player.setAsset('sounds/ding.mp3');
            player.play();
            _calcBestAvg(stage, bestStage);
          }
        }
      },
      child: SizedBox(
        height: 20,
        width: 40,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              bestStage,
              style: const TextStyle(fontSize: 14.0),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }

//Same as above if user presses and holds best class instead of best time.
  InkWell bestClass(String stage, String bestStage, String bestClass) {
    return InkWell(
      highlightColor: Constants.mtGreen,
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      onLongPress: () async {
        if (bestClass != '') {
          if (widget.appSounds == 'On') {
            await player.setAsset('sounds/ding.mp3');
            player.play();
            _calcBestAvg(stage, bestStage);
          }
        }
      },
      child: SizedBox(
        height: 20,
        width: 22,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              bestClass,
              style: const TextStyle(fontSize: 14.0),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }

  //Snackbar called from _calcBestAvg above to display best average strings times
  // with an action to show best average times needed to advance in classification.
  void _snackBarBestAvg(String stage, double bestAvg) {
    final snackBar = SnackBar(
      backgroundColor: Constants.mtGreen,
      content: Text(
        'Best average string $stage is ${bestAvg.toStringAsFixed(2)}',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'More...',
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

    if (timeShaved == 0.0) {
      stageTimes.shavedTime = '';
    } else {
      stageTimes.shavedTime = timeShaved.toStringAsFixed(2);
    }

    await helper.insertStages(divAbbrev, stageTimes);
  }

//Restore from database all previously entered and displayed times when user revisits screen.
  _getStageTimes() async {
    int? numRows = await helper.getCount(divAbbrev);

    StageTimes? stageTimes = await helper.queryStageTimes(divAbbrev, numRows!);
    if (numRows == 0) {
      timeCuts = '';
    } else {
      _controller5.text = stageTimes!.fiveToGo!;
      stageTimes.fiveToGo != ''
          ? todayPct5 = _calcTodayPercent(peak5, stageTimes.fiveToGo!)
          : todayPct5 = '';
      _controllerShow.text = stageTimes.showdown!;
      stageTimes.showdown != ''
          ? todayPctShow = _calcTodayPercent(peakShow, stageTimes.showdown!)
          : todayPctShow = '';
      _controllerSH.text = stageTimes.smokeAndHope!;
      stageTimes.smokeAndHope != ''
          ? todayPctSH = _calcTodayPercent(peakSH, stageTimes.smokeAndHope!)
          : todayPctSH = '';
      _controllerOL.text = stageTimes.outerLimits!;
      stageTimes.outerLimits != ''
          ? todayPctOL = _calcTodayPercent(peakOL, stageTimes.outerLimits!)
          : todayPctOL = '';
      _controllerAcc.text = stageTimes.accelerator!;
      stageTimes.accelerator != ''
          ? todayPctAcc = _calcTodayPercent(peakAcc, stageTimes.accelerator!)
          : todayPctAcc = '';
      _controllerPend.text = stageTimes.pendulum!;
      stageTimes.pendulum != ''
          ? todayPctPend = _calcTodayPercent(peakPend, stageTimes.pendulum!)
          : todayPctPend = '';
      _controllerSpeed.text = stageTimes.speedOption!;
      stageTimes.speedOption != ''
          ? todayPctSpeed =
              _calcTodayPercent(peakSpeed, stageTimes.speedOption!)
          : todayPctSpeed = '';
      _controllerRound.text = stageTimes.roundabout!;
      stageTimes.roundabout != ''
          ? todayPctRound = _calcTodayPercent(peakRound, stageTimes.roundabout!)
          : todayPctRound = '';

      stageTimes.best5 != '' ? best5 = stageTimes.best5! : best5 = '';

      if (best5 != '') {
        bestClass5 = _calcBestClass(peak5, best5);
        if (best5 == _controller5.text) {
          newBestColor5 = Colors.green;
        }
      }

      stageTimes.bestShow != null
          ? bestShow = stageTimes.bestShow!
          : bestShow = '';
      if (bestShow != '') {
        bestClassShow = _calcBestClass(peakShow, bestShow);
        if (bestShow == _controllerShow.text) {
          newBestColorShow = Colors.green;
        }
      }

      stageTimes.bestSH != null ? bestSH = stageTimes.bestSH! : bestSH = '';
      if (bestSH != '') {
        bestClassSH = _calcBestClass(peakSH, bestSH);
        if (bestSH == _controllerSH.text) {
          newBestColorSH = Colors.green;
        }
      }

      stageTimes.bestOL != null ? bestOL = stageTimes.bestOL! : bestOL = '';
      if (bestOL != '') {
        bestClassOL = _calcBestClass(peakOL, bestOL);
        if (bestOL == _controllerOL.text) {
          newBestColorOL = Colors.green;
        }
      }

      stageTimes.bestAcc != null ? bestAcc = stageTimes.bestAcc! : bestAcc = '';
      if (bestAcc != '') {
        bestClassAcc = _calcBestClass(peakAcc, bestAcc);
        if (bestAcc == _controllerAcc.text) {
          newBestColorAcc = Colors.green;
        }
      }

      stageTimes.bestPend != null
          ? bestPend = stageTimes.bestPend!
          : bestPend = '';
      if (bestPend != '') {
        bestClassPend = _calcBestClass(peakPend, bestPend);
        if (bestPend == _controllerPend.text) {
          newBestColorPend = Colors.green;
        }
      }

      stageTimes.bestSpeed != null
          ? bestSpeed = stageTimes.bestSpeed!
          : bestSpeed = '';
      if (bestSpeed != '') {
        bestClassSpeed = _calcBestClass(peakSpeed, bestSpeed);
        if (bestSpeed == _controllerSpeed.text) {
          newBestColorSpeed = Colors.green;
        }
      }

      stageTimes.bestRound != null
          ? bestRound = stageTimes.bestRound!
          : bestRound = '';
      if (bestRound != '') {
        bestClassRound = _calcBestClass(peakRound, bestRound);
        if (bestRound == _controllerRound.text) {
          newBestColorRound = Colors.green;
        }
      }

      best5 = stageTimes.best5!;
      bestShow = stageTimes.bestShow!;
      bestSH = stageTimes.bestSH!;
      bestOL = stageTimes.bestOL!;
      bestAcc = stageTimes.bestAcc!;
      bestPend = stageTimes.bestPend!;
      bestSpeed = stageTimes.bestSpeed!;
      bestRound = stageTimes.bestRound!;

      if (stageTimes.shavedTime.isEmpty || stageTimes.shavedTime == '') {
        timeShaved = 0.0;
        timeCuts = '';
      } else {
        timeShaved = double.parse(stageTimes.shavedTime);

        timeCuts = 'Time cut today : -${timeShaved.toStringAsFixed(2)}';
      }
    }
    _calcTotals();
  }

//Calculate and display the class represented by the best stage time for the division.
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
      return ' /M';
    } else {
      return '/G';
    }
  }

//Calculate and display the percent and class for each today stage time entered.
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
// data by saving empty strings to database and clearing all current data.
  void _clearDivisionData() {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Confirm...",
      desc:
          "This will clear all $divAbbrev data, including best stage and string times, and cannot be undone.",
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
          onPressed: () async {
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

            newBestColor5 = Colors.black;
            newBestColorShow = Colors.black;
            newBestColorSH = Colors.black;
            newBestColorOL = Colors.black;
            newBestColorAcc = Colors.black;
            newBestColorPend = Colors.black;
            newBestColorSpeed = Colors.black;
            newBestColorRound = Colors.black;

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
            if (widget.appSounds == 'On') {
              await player.setAsset('sounds/ding.mp3');
              player.play();
            }
          },
          width: 20,
          child: const Text(
            "Clear",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    ).show();
  }

  void _clearStringTimes() async {
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

    await helper.insertStrings('${divAbbrev}STR', stringTimes);
  }

//Determine if user has scored at least 4 classifier stages before displaying
  //Track Class screen.
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

  void _noClassification(context) async {
    await player.setAsset('sounds/error.mp3');
    player.play();
    Alert(
      context: context,
      desc:
          'You have not entered a minimum of four classifier stage scores for this division.',
      buttons: [
        DialogButton(
          color: Constants.mtGreen,
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

//Method to handle PopScope action when a back button is tapped
  void _onBackPressed(didpop) {
    // debugPrint('_onBackPressed called.');
    if (didpop) {
      return;
    }
    //Unfocus all text fields and hide keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    //Delay back action to allow time for the _confirmNewBestTime dialog
    //to show if necessary (which will cancel the back action)
    Future.delayed(Duration(milliseconds: 200), () {
      //If the new best time dialog is not showing, leave the scoring screen
      if (!dialogShowing) {
        if (!mounted) return;
        Navigator.of(context).pop();
      }
    });
  }
}

class _HeadText extends StatelessWidget {
  const _HeadText({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
