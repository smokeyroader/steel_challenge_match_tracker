import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'best_strings.dart';
import 'constants.dart';
import 'database_helper.dart';
import 'track_class.dart';
import 'stage_diagrams.dart';

class MatchTracker extends StatefulWidget {
  //Set current division sent from mt_home_page.dart
  final String currentDivision;

  MatchTracker({
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

  TextEditingController _controller5 = TextEditingController();
  TextEditingController _controllerShow = TextEditingController();
  TextEditingController _controllerSH = TextEditingController();
  TextEditingController _controllerOL = TextEditingController();
  TextEditingController _controllerAcc = TextEditingController();
  TextEditingController _controllerPend = TextEditingController();
  TextEditingController _controllerSpeed = TextEditingController();
  TextEditingController _controllerRound = TextEditingController();

  //Declare focusNodes to detect change in focus of TextFields

  FocusNode _focus5;
  FocusNode _focusShow;
  FocusNode _focusSH;
  FocusNode _focusOL;
  FocusNode _focusAcc;
  FocusNode _focusPend;
  FocusNode _focusSpeed;
  FocusNode _focusRound;

//  bool savedClass = false;
  bool ignoreChange = false;

  String showToday;
  String overridenClass = '';

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

  double bestAvg5;
  double bestAvgShow;
  double bestAvgSH;
  double bestAvgOL;
  double bestAvgAcc;
  double bestAvgPend;
  double bestAvgSpeed;
  double bestAvgRound;

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

  String timeCuts;

//  Permit changing today time font to green if a new personal best is entered
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

    //Keep screen from rotating to landscape
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);

    _focus5 = FocusNode();
    _focusShow = FocusNode();
    _focusSH = FocusNode();
    _focusOL = FocusNode();
    _focusAcc = FocusNode();
    _focusPend = FocusNode();
    _focusSpeed = FocusNode();
    _focusRound = FocusNode();

//    Check if today times are shown (true) or hidden (false)
    _getShowHide().then((value) {
      setState(() {
        showToday = value;
      });
    });

    //Check if class has been overwritten
    _getClassOverride(widget.currentDivision).then((value) {
      setState(() {
        overridenClass = value;
      });
    });

    //Set division abbreviation to be used to access the correct table when saving and retrieving times
    setState(() {
      switch (widget.currentDivision) {
        case 'Rimfire Rifle Open (RFRO)':
          divAbbrev = 'RFRO';
          break;

        case 'Rimfire Rifle Irons (RFRI)':
          divAbbrev = 'RFRI';
          break;

        case 'Pistol-Caliber Carbine Optic (PCCO)':
          divAbbrev = 'PCCO';
          break;

        case 'Pistol-Caliber Carbine Irons (PCCI)':
          divAbbrev = 'PCCI';
          break;

        case 'Rimfire Pistol Open (RFPO)':
          divAbbrev = 'RFPO';
          break;

        case 'Rimfire Pistol Irons (RFPI)':
          divAbbrev = 'RFPI';
          break;

        case 'Open (OPN)':
          divAbbrev = 'OPN';
          break;

        case 'Carry Optics (CO)':
          divAbbrev = 'CO';
          break;

        case 'Production (PROD)':
          divAbbrev = 'PROD';
          break;

        case 'Limited (LTD)':
          divAbbrev = 'LTD';
          break;

        case 'Single Stack (SS)':
          divAbbrev = 'SS';
          break;

        case 'Optical Sight Revolver (OSR)':
          divAbbrev = 'OSR';
          break;

        case 'Iron Sight Revolver (ISR)':
          divAbbrev = 'ISR';
          break;
      }
    });
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
        title: Text(
          'Match Tracker',
        ),
        backgroundColor: Color(0xFF00681B),
        actions: <Widget>[
          PopupMenuButton<String>(
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

      //Override both back buttons to also save data when tapped
      body: WillPopScope(
        onWillPop: () async {
          _saveStageTimes();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          return true;
        },
        //Add ScrollView so that keyboard doesn't cover data fields
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                        padding: const EdgeInsets.all(2.0),
                        child: FittedBox(
                          child: Text(
                            '${widget.currentDivision}',
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
                ),
                Container(
                  height: 20.0,
                  color: Color(0xFF00681B),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 95.0,
                        child: FittedBox(
                          child: Text(
                            'Stage',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Container(
                          width: 60.0,
                          child: FittedBox(
                            child: Text(
                              'Best',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 60.0,
                        child: FittedBox(
                          child: Text(
                            'Today',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 85.0,
                        child: FittedBox(
                          child: Text(
                            '%/Class',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 117.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StageDiagram('Five to Go',
                                          'images/five_to_go.jpg');
//                                      return Image.asset(
//                                          'images/five_to_go.jpg');
                                    },
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  '5 to Go',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '101 ($peak5)',
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 75.0,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _calcBestAvg('5');
                                },
                                child: Text(
                                  '$best5',
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                '$bestClass5',
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 48.0,
                          child: TextField(
                            style:
                                TextStyle(fontSize: 14.0, color: newBestColor5),
                            controller: _controller5,
                            focusNode: _focus5,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              BlacklistingTextInputFormatter(
                                RegExp('[\\-|,\\ ]'),
                              ),
                            ],
                            decoration: InputDecoration.collapsed(
                              hintText: null,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (text) {
                              autoFormat(_controller5);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 75.0,
                          child: Text(
                            '$todayPct5',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 117.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StageDiagram(
                                          'Showdown', 'images/showdown.jpg');
//                                      return Image.asset(
//                                          'images/five_to_go.jpg');
                                    },
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Showdown',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '102 ($peakShow)',
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 75.0,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _calcBestAvg('Show');
                                },
                                child: Text(
                                  '$bestShow',
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                '$bestClassShow',
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 48.0,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 14.0, color: newBestColorShow),
                            controller: _controllerShow,
                            focusNode: _focusShow,
                            decoration: InputDecoration.collapsed(
                              hintText: null,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              BlacklistingTextInputFormatter(
                                RegExp('[\\-|,\\ ]'),
                              ),
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (text) {
                              autoFormat(_controllerShow);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 75.0,
                          child: Text(
                            '$todayPctShow',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),

//                  Text(
//                    '/G',
//                  ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 117.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StageDiagram('Smoke & Hope',
                                          'images/smoke_n_hope.jpg');
//                                      return Image.asset(
//                                          'images/five_to_go.jpg');
                                    },
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Smoke&Hope',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '103 ($peakSH)',
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 75.0,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _calcBestAvg('SH');
                                },
                                child: Text(
                                  '$bestSH',
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                '$bestClassSH',
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 48.0,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 14.0, color: newBestColorSH),
                            controller: _controllerSH,
                            focusNode: _focusSH,
                            decoration: InputDecoration.collapsed(
                              hintText: null,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              BlacklistingTextInputFormatter(
                                RegExp('[\\-|,\\ ]'),
                              ),
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (text) {
                              autoFormat(_controllerSH);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 75.0,
                          child: Text(
                            '$todayPctSH',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),

//
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
//                      color: Colors.blue,
                        width: 117.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StageDiagram('Outer Limits',
                                          'images/outer_limits.jpg');
//                                      return Image.asset(
//                                          'images/five_to_go.jpg');
                                    },
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Outer Limits',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '104 ($peakOL)',
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 75.0,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _calcBestAvg('OL');
                                },
                                child: Text(
                                  '$bestOL',
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                '$bestClassOL',
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 48.0,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 14.0, color: newBestColorOL),
                            controller: _controllerOL,
                            focusNode: _focusOL,
                            decoration: InputDecoration.collapsed(
                              hintText: null,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              BlacklistingTextInputFormatter(
                                RegExp('[\\-|,\\ ]'),
                              ),
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (text) {
                              autoFormat(_controllerOL);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 75.0,
                          child: Text(
                            '$todayPctOL',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 117.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StageDiagram('Accelerator',
                                          'images/accelerator.jpg');
//                                      return Image.asset(
//                                          'images/five_to_go.jpg');
                                    },
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Accelerator',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '105 ($peakAcc)',
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 75.0,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _calcBestAvg('Acc');
                                },
                                child: Text(
                                  '$bestAcc',
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                '$bestClassAcc',
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 48.0,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 14.0, color: newBestColorAcc),
                            controller: _controllerAcc,
                            focusNode: _focusAcc,
                            decoration: InputDecoration.collapsed(
                              hintText: null,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              BlacklistingTextInputFormatter(
                                RegExp('[\\-|,\\ ]'),
                              ),
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (text) {
                              autoFormat(_controllerAcc);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 75.0,
                          child: Text(
                            '$todayPctAcc',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),

//                  Text(
//                    '/G',
//                  ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 117.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StageDiagram('The Pendulum',
                                          'images/pendulum.jpg');
//                                      return Image.asset(
//                                          'images/five_to_go.jpg');
                                    },
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Pendulum',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '106 ($peakPend)',
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 75.0,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _calcBestAvg('Pend');
                                },
                                child: Text(
                                  '$bestPend',
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                '$bestClassPend',
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 48.0,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 14.0, color: newBestColorPend),
                            controller: _controllerPend,
                            focusNode: _focusPend,
                            decoration: InputDecoration.collapsed(
                              hintText: null,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              BlacklistingTextInputFormatter(
                                RegExp('[\\-|,\\ ]'),
                              ),
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (text) {
                              autoFormat(_controllerPend);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 75.0,
                          child: Text(
                            '$todayPctPend',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),

//
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 117.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StageDiagram('Speed Option',
                                          'images/speed_option.jpg');
//                                      return Image.asset(
//                                          'images/five_to_go.jpg');
                                    },
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Speed Option',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '107 ($peakSpeed)',
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 75.0,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _calcBestAvg('Speed');
                                },
                                child: Text(
                                  '$bestSpeed',
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                '$bestClassSpeed',
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 48.0,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 14.0, color: newBestColorSpeed),
                            controller: _controllerSpeed,
                            focusNode: _focusSpeed,
                            decoration: InputDecoration.collapsed(
                              hintText: null,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              BlacklistingTextInputFormatter(
                                RegExp('[\\-|,\\ ]'),
                              ),
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (text) {
                              autoFormat(_controllerSpeed);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 75.0,
                          child: Text(
                            '$todayPctSpeed',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 117.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StageDiagram('Roundabout',
                                          'images/roundabout.jpg');
//                                      return Image.asset(
//                                          'images/five_to_go.jpg');
                                    },
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Roundabout',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '108 ($peakRound)',
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 75.0,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _calcBestAvg('Round');
                                },
                                child: Text(
                                  '$bestRound',
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                '$bestClassRound',
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 48.0,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 14.0, color: newBestColorRound),
                            controller: _controllerRound,
                            focusNode: _focusRound,
                            decoration: InputDecoration.collapsed(
                              hintText: null,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              BlacklistingTextInputFormatter(
                                RegExp('[\\-|,\\ ]'),
                              ),
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (text) {
                              autoFormat(_controllerRound);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 75.0,
                          child: Text(
                            '$todayPctRound',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
//                          Container(width: 25),
                          Container(
                            width: 65.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Text(
                              'Time',
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w900),
                            ),
                          ),
                          Container(
                            width: 65.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Peak',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          Container(
                            width: 75.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                '%Peak',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          Container(
                            width: 65.0,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Class',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w900),
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
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 65.0,
                            child: Text(
                              'Today',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: 65.0,
                            child: Text(
                              '$todayTime',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            width: 65.0,
                            child: Text(
                              '$todayPeak',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            width: 65.0,
                            child: Text(
                              '$todayPct',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            width: 55.0,
                            child: Text(
                              '$todayClass',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 65.0,
                            child: Text(
                              'Overall',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: 65.0,
                            child: Text(
                              '$overallTime',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            width: 65.0,
                            child: Text(
                              '$overallPeak',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            width: 65.0,
                            child: Text(
                              '$overallPct',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            width: 55.0,
                            child: Text(
                              '$overallClass',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
//                    SizedBox(
//                      height: 15.0,
//                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: RaisedButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: Color(0xFF00681B))),
                                child: Text(
                                  'Change Gun',
                                  style: TextStyle(
                                    color: Color(0xFF00681B),
                                  ),
                                ),
                                onPressed: () {
                                  //Code here to save data before exiting screen
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Container(
                              width: 120.0,
                              child: Text(
                                '$timeCuts',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: RaisedButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: Color(0xFF00681B))),
                                child: Text(
                                  'Clear Today',
                                  style: TextStyle(
                                    color: Color(0xFF00681B),
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
    );
  }

//Method to automatically add decimal to time inputs
  void autoFormat(TextEditingController controller) {
    //Text entry can go into infinite loop under some conditions, with the
    //system apparently failing to distinguish between system (programmatic)change and user change.
    //The ignoreChange switch is an attempt to address this. Will monitor the effectiveness of this 'fix.'
    if (!ignoreChange) {
      String text = controller.text;
      if (text != '') {
        text = text.replaceAll('.', '');
        text = text.replaceAll(' ', '');
        if (text.length <= 2) {
          text = '.' + text;
        } else {
          text = text.substring(0, text.length - 2) +
              '.' +
              text.substring(text.length - 2, text.length);
        }
        ignoreChange = true;
        setState(() {
          controller.text = text;
          //Move cursor to first position after text changed
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: (text ?? '').length));
        });
        ignoreChange = false;
      }
    }
  }

//Update today and total times when TextFields lose focus.

  Future<Null> _focus5Listener() async {
    if (_focus5.hasFocus) {
      _controller5.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller5.text.length);
    } else {
      if (_controller5.text == '') {
        setState(() {
          todayPct5 = '';
        });
      } else {
        setState(() {
          todayPct5 = _calcTodayPercent(peak5, _controller5.text);
        });

        if (best5 == '' || best5 == '') {
          setState(() {
            best5 = _controller5.text;
            bestClass5 = _calcBestClass(peak5, _controller5.text);
          });
        } else if ((double.parse(_controller5.text) < double.parse(best5))) {
          _confirmNewBestTime(context, '5 to Go', _controller5.text, '5');
          setState(() {
            _calcBestClass(peak5, best5);
          });
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<Null> _focusShowListener() async {
    if (_focusShow.hasFocus) {
      _controllerShow.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerShow.text.length);
    } else {
      if (_controllerShow.text == '') {
        setState(() {
          todayPctShow = '';
        });
      } else {
        setState(() {
          todayPctShow = _calcTodayPercent(peakShow, _controllerShow.text);
        });

        if (bestShow == '') {
          setState(() {
            bestShow = _controllerShow.text;
            bestClassShow = _calcBestClass(peakShow, _controllerShow.text);
          });
        } else if ((double.parse(_controllerShow.text) <
            double.parse(bestShow))) {
          _confirmNewBestTime(
              context, 'Showdown', _controllerShow.text, 'Show');
          setState(() {
            _calcBestClass(peakShow, bestShow);
          });
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<Null> _focusSHListener() async {
    if (_focusSH.hasFocus) {
      _controllerSH.selection =
          TextSelection(baseOffset: 0, extentOffset: _controllerSH.text.length);
    } else {
      if (_controllerSH.text == '') {
        setState(() {
          todayPctSH = '';
        });
      } else {
        setState(() {
          todayPctSH = _calcTodayPercent(peakSH, _controllerSH.text);
        });

        if (bestSH == '') {
          setState(() {
            bestSH = _controllerSH.text;
            bestClassSH = _calcBestClass(peakSH, _controllerSH.text);
          });
        } else if ((double.parse(_controllerSH.text) < double.parse(bestSH))) {
          _confirmNewBestTime(
              context, 'Smoke & Hope', _controllerSH.text, 'SH');
          setState(() {
            _calcBestClass(peakSH, bestSH);
          });
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<Null> _focusOLListener() async {
    if (_focusOL.hasFocus) {
      _controllerOL.selection =
          TextSelection(baseOffset: 0, extentOffset: _controllerOL.text.length);
    } else {
      if (_controllerOL.text == '') {
        setState(() {
          todayPctOL = '';
        });
      } else {
        setState(() {
          todayPctOL = _calcTodayPercent(peakOL, _controllerOL.text);
        });

        if (bestOL == '') {
          setState(() {
            bestOL = _controllerOL.text;
            bestClassOL = _calcBestClass(peakOL, _controllerOL.text);
          });
        } else if ((double.parse(_controllerOL.text) < double.parse(bestOL))) {
          _confirmNewBestTime(
              context, 'Outer Limits', _controllerOL.text, 'OL');
          setState(() {
            _calcBestClass(peakOL, bestOL);
          });
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<Null> _focusAccListener() async {
    if (_focusAcc.hasFocus) {
      _controllerAcc.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerAcc.text.length);
    } else {
      if (_controllerAcc.text == '') {
        setState(() {
          todayPctAcc = '';
        });
      } else {
        setState(() {
          todayPctAcc = _calcTodayPercent(peakAcc, _controllerAcc.text);
        });

        if (bestAcc == '') {
          setState(() {
            bestAcc = _controllerAcc.text;
            bestClassAcc = _calcBestClass(peakAcc, _controllerAcc.text);
          });
        } else if ((double.parse(_controllerAcc.text) <
            double.parse(bestAcc))) {
          _confirmNewBestTime(
              context, 'Accelerator', _controllerAcc.text, 'Acc');
          setState(() {
            _calcBestClass(peakAcc, bestAcc);
          });
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<Null> _focusPendListener() async {
    if (_focusPend.hasFocus) {
      _controllerPend.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerPend.text.length);
    } else {
      if (_controllerPend.text == '') {
        setState(() {
          todayPctPend = '';
        });
      } else {
        setState(() {
          todayPctPend = _calcTodayPercent(peakPend, _controllerPend.text);
        });

        if (bestPend == '') {
          setState(() {
            bestPend = _controllerPend.text;
            bestClassPend = _calcBestClass(peakPend, _controllerPend.text);
          });
        } else if ((double.parse(_controllerPend.text) <
            double.parse(bestPend))) {
          _confirmNewBestTime(
              context, 'Pendulum', _controllerPend.text, 'Pend');
          setState(() {
            _calcBestClass(peakPend, bestPend);
          });
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<Null> _focusSpeedListener() async {
    if (_focusSpeed.hasFocus) {
      _controllerSpeed.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerSpeed.text.length);
    } else {
      if (_controllerSpeed.text == '') {
        setState(() {
          todayPctSpeed = '';
        });
      } else {
        setState(() {
          todayPctSpeed = _calcTodayPercent(peakSpeed, _controllerSpeed.text);
        });

        if (bestSpeed == '') {
          setState(() {
            bestSpeed = _controllerSpeed.text;
            bestClassSpeed = _calcBestClass(peakSpeed, _controllerSpeed.text);
          });
        } else if ((double.parse(_controllerSpeed.text) <
            double.parse(bestSpeed))) {
          _confirmNewBestTime(
              context, 'Speed Option', _controllerSpeed.text, 'Speed');
          setState(() {
            _calcBestClass(peakSpeed, bestSpeed);
          });
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  Future<Null> _focusRoundListener() async {
    if (_focusRound.hasFocus) {
      _controllerRound.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerRound.text.length);
    } else {
      if (_controllerRound.text == '') {
        setState(() {
          todayPctRound = '';
        });
      } else {
        setState(() {
          todayPctRound = _calcTodayPercent(peakRound, _controllerRound.text);
        });

        if (bestRound == '') {
          setState(() {
            bestRound = _controllerRound.text;
            bestClassRound = _calcBestClass(peakRound, _controllerRound.text);
          });
        } else if ((double.parse(_controllerRound.text) <
            double.parse(bestRound))) {
          _confirmNewBestTime(
              context, 'Roundabout', _controllerRound.text, 'Round');
          setState(() {
            _calcBestClass(peakRound, bestRound);
          });
        }
      }
      _calcTotals();
      _saveStageTimes();
    }
  }

  //If shooter enters a time lower than the previous best, confirm that previous best should be replaced
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
          color: Colors.green,
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
//            Navigator.pop(context);
            setState(() {
              switch (bestID) {
                case '5':
                  //Calculate the time cut from previous best
                  diff = (double.parse(best5) - double.parse(stageTime));
                  //Add time cuts to previous time cut value and display at bottom center of screen
                  timeShaved = timeShaved + diff;

                  setState(() {
                    timeCuts =
                        'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                  });

                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                        'You cut ${diff.toStringAsFixed(2)} seconds from your best time on 5 to Go!'),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);

                  best5 = stageTime;
                  setState(() {
                    bestClass5 = _calcBestClass(peak5, stageTime);
                    newBestColor5 = Colors.green;
                    _calcOverall();
                  });
                  break;
                case 'Show':
                  diff = (double.parse(bestShow) - double.parse(stageTime));
                  timeShaved = timeShaved + diff;

                  setState(() {
                    timeCuts =
                        'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                  });
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                        'You cut ${diff.toStringAsFixed(2)} seconds from your best time on Showdown!'),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                  bestShow = stageTime;
                  setState(() {
                    bestClassShow = _calcBestClass(peakShow, stageTime);
                    newBestColorShow = Colors.green;
                    _calcOverall();
                  });

                  break;
                case 'SH':
                  diff = (double.parse(bestSH) - double.parse(stageTime));
                  timeShaved = timeShaved + diff;

                  setState(() {
                    timeCuts =
                        'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                  });
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                        'You cut ${diff.toStringAsFixed(2)} seconds from your best time on Smoke & Hope!'),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                  bestSH = stageTime;
                  setState(() {
                    bestClassSH = _calcBestClass(peakSH, stageTime);
                  });
                  newBestColorSH = Colors.green;
                  _calcOverall();

                  break;
                case 'OL':
                  diff = (double.parse(bestOL) - double.parse(stageTime));
                  timeShaved = timeShaved + diff;

                  setState(() {
                    timeCuts =
                        'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                  });
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                        'You cut ${diff.toStringAsFixed(2)}seconds from your best time on Outer Limits!'),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                  bestOL = stageTime;
                  setState(() {
                    bestClassOL = _calcBestClass(peakOL, stageTime);
                  });
                  newBestColorOL = Colors.green;
                  _calcOverall();

                  break;
                case 'Acc':
                  diff = (double.parse(bestAcc) - double.parse(stageTime));
                  timeShaved = timeShaved + diff;

                  setState(() {
                    timeCuts =
                        'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                  });
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                        'You cut ${diff.toStringAsFixed(2)} seconds from your best time on Accelerator!'),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                  bestAcc = stageTime;
                  setState(() {
                    bestClassAcc = _calcBestClass(peakAcc, stageTime);
                  });
                  newBestColorAcc = Colors.green;
                  _calcOverall();

                  break;
                case 'Pend':
                  diff = (double.parse(bestPend) - double.parse(stageTime));
                  timeShaved = timeShaved + diff;

                  setState(() {
                    timeCuts =
                        'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                  });
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                        'You cut ${diff.toStringAsFixed(2)} seconds from your best time on Pendulum!'),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                  bestPend = stageTime;
                  setState(() {
                    bestClassPend = _calcBestClass(peakPend, stageTime);
                  });
                  newBestColorPend = Colors.green;
                  _calcOverall();

                  break;
                case 'Speed':
                  diff = (double.parse(bestSpeed) - double.parse(stageTime));
                  timeShaved = timeShaved + diff;

                  setState(() {
                    timeCuts =
                        'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                  });
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                        'You cut ${diff.toStringAsFixed(2)} seconds from your best time on Speed Option!'),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                  bestSpeed = stageTime;
                  setState(() {
                    bestClassSpeed = _calcBestClass(peakSpeed, stageTime);
                  });
                  newBestColorSpeed = Colors.green;
                  _calcOverall();

                  break;
                case 'Round':
                  diff = (double.parse(bestRound) - double.parse(stageTime));
                  timeShaved = timeShaved + diff;

                  setState(() {
                    timeCuts =
                        'Time cut today : -${timeShaved.toStringAsFixed(2)}';
                  });
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                        'You cut ${diff.toStringAsFixed(2)} seconds from your best time on Roundabout!'),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                  bestRound = stageTime;
                  setState(() {
                    bestClassRound = _calcBestClass(peakRound, stageTime);
                  });
                  newBestColorRound = Colors.green;
                  _calcOverall();

                  break;
              }
            });
            _saveStageTimes();
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.green,
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ],
    ).show();
  }

///////Call functions to update today and overall totals when TextField loses focus///////////////

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
    setState(() {
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
        } else
          todayClass = 'GM';
      } else {
        todayPct = '';
        todayClass = '';
      }
    });
  }

  void _calcOverallPeak() {
    if (overallPeak != '') {
      setState(() {
        overallPct =
            (double.parse(overallPeak) / double.parse(overallTime) * 100)
                .toStringAsFixed(2);

        overallClass = overridenClass;

        if (overridenClass != '') {
          if (double.parse(overallPct) < 40.0 &&
              overridenClass != 'C' &&
              overridenClass != 'B' &&
              overridenClass != 'A' &&
              overridenClass != 'M' &&
              overridenClass != 'GM') {
            overallClass = 'D';
          } else if (double.parse(overallPct) < 60.0 &&
              overridenClass != 'B' &&
              overridenClass != 'A' &&
              overridenClass != 'M' &&
              overridenClass != 'GM') {
            overallClass = 'C';
          } else if (double.parse(overallPct) < 75.0 &&
              overridenClass != 'A' &&
              overridenClass != 'M' &&
              overridenClass != 'GM') {
            overallClass = 'B';
          } else if (double.parse(overallPct) < 85.0 &&
              overridenClass != 'M' &&
              overridenClass != 'GM') {
            overallClass = 'A';
          } else if (double.parse(overallPct) < 95.0 &&
              overridenClass != 'GM') {
            overallClass = 'M';
          } else {
            overallClass = 'GM';
          }

          _setClassOverride(widget.currentDivision, overallClass);
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
          } else
            overallClass = 'GM';
        }
      });
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
          color: Colors.green,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          color: Colors.green,
          child: Text(
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
    return preferences.getString('showToday') ?? 'On';
  }

//If user has overriden class in this division, save the updated class using SharedPreferences
  Future<void> _setClassOverride(String div, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(div, value);
  }

//Get overriden class (if any) for this division from SharedPreferences
  Future<String> _getClassOverride(String div) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString(div) ?? '';
  }

//Respond to user selection from overflow menu
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
              setState(() {
                _setShowHide('Off');
                showToday = value;
              });
            });
          });
        } else if (showToday == 'Off') {
          setState(() {
            _addTodayTimes();
            _addTodayPeak();
            _calcTodayPeak();

            _setShowHide('On');
            _getShowHide().then((value) {
              setState(() {
                showToday = value;
              });
            });
          });
        }

        break;
    }
  }

//Allow user to override the calculated class if it is not correct because of current peak percent
  //that is lower than the highest class ever attained.
  Future<void> _overrideClass(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Center(
              child: Text(
                'Tap current $divAbbrev class: ',
                style: TextStyle(color: Color(0xFF00681B)),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);

                  _setClassOverride(widget.currentDivision, 'GM');
                  setState(() {
                    overridenClass = 'GM';
                  });
                  _calcOverallPeak();
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                      'Your ${widget.currentDivision} class has been changed to GM.',
                    ),
                  );

                  scaffoldState.currentState.showSnackBar(snackBar);
                },
                child: Center(
                  child: const Text(
                    'GM',
                    style: TextStyle(
                      color: Color(0xFF00681B),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);

                  _setClassOverride(widget.currentDivision, 'M');
                  setState(() {
                    overridenClass = 'M';
                  });
                  _calcOverallPeak();
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                      'Your ${widget.currentDivision} class has been changed to M.',
                    ),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                },
                child: Center(
                  child: const Text(
                    'M',
                    style: TextStyle(
                      color: Color(0xFF00681B),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);

                  _setClassOverride(widget.currentDivision, 'A');
                  setState(() {
                    overridenClass = 'A';
                  });
                  _calcOverallPeak();
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                      'Your ${widget.currentDivision} class has been changed to A.',
                    ),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                },
                child: Center(
                  child: const Text(
                    'A',
                    style: TextStyle(
                      color: Color(0xFF00681B),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);

                  _setClassOverride(widget.currentDivision, 'B');
                  setState(() {
                    overridenClass = 'B';
                  });
                  _calcOverallPeak();
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                      'Your ${widget.currentDivision} class has been changed to B.',
                    ),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                },
                child: Center(
                  child: const Text(
                    'B',
                    style: TextStyle(
                      color: Color(0xFF00681B),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);

                  _setClassOverride(widget.currentDivision, 'C');
                  setState(() {
                    overridenClass = 'C';
                  });
                  _calcOverallPeak();
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xFF00681B),
                    content: Text(
                      'Your ${widget.currentDivision} class has been changed to C.',
                    ),
                  );
                  scaffoldState.currentState.showSnackBar(snackBar);
                },
                child: Center(
                  child: const Text(
                    'C',
                    style: TextStyle(
                      color: Color(0xFF00681B),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

//If user taps best time, calculate average string time to achieve that score
  //and display it in Snackbar
  void _calcBestAvg(String iD) {
    switch (iD) {
      case '5':
        if (best5 != '') {
          bestAvg5 = (double.parse(best5) / 4);
          final snackBar = SnackBar(
            backgroundColor: Color(0xFF00681B),
            content: Text(
              'Best average string 5 to Go is ${bestAvg5.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          );
          scaffoldState.currentState.showSnackBar(snackBar);
        }
        break;

      case 'Show':
        if (bestShow != '') {
          bestAvgShow = (double.parse(bestShow) / 4);
          final snackBar = SnackBar(
            backgroundColor: Color(0xFF00681B),
            content: Text(
              'Best average string Showdown is ${bestAvgShow.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          );
          scaffoldState.currentState.showSnackBar(snackBar);
        }

        break;

      case 'SH':
        if (bestSH != '') {
          bestAvgSH = (double.parse(bestSH) / 4);
          final snackBar = SnackBar(
            backgroundColor: Color(0xFF00681B),
            content: Text(
              'Best average string Smoke & Hope is ${bestAvgSH.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          );
          scaffoldState.currentState.showSnackBar(snackBar);
        }

        break;

      case 'OL':
        if (bestOL != '') {
          bestAvgOL = (double.parse(bestOL) / 3);
          final snackBar = SnackBar(
            backgroundColor: Color(0xFF00681B),
            content: Text(
              'Best average string Outer Limits is ${bestAvgOL.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          );
          scaffoldState.currentState.showSnackBar(snackBar);
        }

        break;

      case 'Acc':
        if (bestAcc != '') {
          bestAvgAcc = (double.parse(bestAcc) / 4);
          final snackBar = SnackBar(
            backgroundColor: Color(0xFF00681B),
            content: Text(
              'Best average string Accelerator is ${bestAvgAcc.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          );
          scaffoldState.currentState.showSnackBar(snackBar);
        }

        break;

      case 'Pend':
        if (bestPend != '') {
          bestAvgPend = (double.parse(bestPend) / 4);
          final snackBar = SnackBar(
            backgroundColor: Color(0xFF00681B),
            content: Text(
              'Best average string Pendulum is ${bestAvgPend.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          );
          scaffoldState.currentState.showSnackBar(snackBar);
        }

        break;

      case 'Speed':
        if (bestSpeed != '') {
          bestAvgSpeed = (double.parse(bestSpeed) / 4);
          final snackBar = SnackBar(
            backgroundColor: Color(0xFF00681B),
            content: Text(
              'Best average string Speed Option is ${bestAvgSpeed.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          );
          scaffoldState.currentState.showSnackBar(snackBar);
        }

        break;

      case 'Round':
        if (bestRound != '') {
          bestAvgRound = (double.parse(bestRound) / 4);
          final snackBar = SnackBar(
            backgroundColor: Color(0xFF00681B),
            content: Text(
              'Best average string Roundabout is ${bestAvgRound.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          );
          scaffoldState.currentState.showSnackBar(snackBar);
        }

        break;
    }
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

//    int id =
    await helper.insertStages(divAbbrev, stageTimes);
//    print('inserted row: $id');
  }

//Restore from database all previously entered and displayed times when user revisits screen
  _getStageTimes() async {
    int numRows = await helper.getCount(divAbbrev);

    StageTimes stageTimes = await helper.queryStageTimes(divAbbrev, numRows);
    if (numRows == 0) {
//      print('read row $numRows: empty');
      timeCuts = '';
    } else {
      setState(() {
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
            ? todayPctSpeed =
                _calcTodayPercent(peakSpeed, stageTimes.speedOption)
            : todayPctSpeed = '';
        _controllerRound.text = stageTimes.roundabout;
        stageTimes.roundabout != ''
            ? todayPctRound =
                _calcTodayPercent(peakRound, stageTimes.roundabout)
            : todayPctRound = '';

        stageTimes.best5 != null &&
//                stageTimes.best5 != &&
                stageTimes.best5 != ''
            ? best5 = stageTimes.best5
            : best5 = '';

        if (best5 != '') {
          bestClass5 = _calcBestClass(peak5, best5);
          if (best5 == _controller5.text) {
            newBestColor5 = Color(0xFF00681B);
          }
        }

        stageTimes.bestShow != null
            ? bestShow = stageTimes.bestShow
            : bestShow = '';
        if (bestShow != '') {
          bestClassShow = _calcBestClass(peakShow, bestShow);
          if (bestShow == _controllerShow.text) {
            newBestColorShow = Color(0xFF00681B);
          }
        }

        stageTimes.bestSH != null ? bestSH = stageTimes.bestSH : bestSH = '';
        if (bestSH != '') {
          bestClassSH = _calcBestClass(peakSH, bestSH);
          if (bestSH == _controllerSH.text) {
            newBestColorSH = Color(0xFF00681B);
          }
        }

        stageTimes.bestOL != null ? bestOL = stageTimes.bestOL : bestOL = '';
        if (bestOL != '') {
          bestClassOL = _calcBestClass(peakOL, bestOL);
          if (bestOL == _controllerOL.text) {
            newBestColorOL = Color(0xFF00681B);
          }
        }

        stageTimes.bestAcc != null
            ? bestAcc = stageTimes.bestAcc
            : bestAcc = '';
        if (bestAcc != '') {
          bestClassAcc = _calcBestClass(peakAcc, bestAcc);
          if (bestAcc == _controllerAcc.text) {
            newBestColorAcc = Color(0xFF00681B);
          }
        }

        stageTimes.bestPend != null
            ? bestPend = stageTimes.bestPend
            : bestPend = '';
        if (bestPend != '') {
          bestClassPend = _calcBestClass(peakPend, bestPend);
          if (bestPend == _controllerPend.text) {
            newBestColorPend = Color(0xFF00681B);
          }
        }

        stageTimes.bestSpeed != null
            ? bestSpeed = stageTimes.bestSpeed
            : bestSpeed = '';
        if (bestSpeed != '') {
          bestClassSpeed = _calcBestClass(peakSpeed, bestSpeed);
          if (bestSpeed == _controllerSpeed.text) {
            newBestColorSpeed = Color(0xFF00681B);
          }
        }

        stageTimes.bestRound != null
            ? bestRound = stageTimes.bestRound
            : bestRound = '';
        if (bestRound != '') {
          bestClassRound = _calcBestClass(peakRound, bestRound);
          if (bestRound == _controllerRound.text) {
            newBestColorRound = Color(0xFF00681B);
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
      });
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
//    setState(() {
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
//    });
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
          color: Colors.green,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          color: Colors.green,
          child: Text(
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
            });
            _saveStageTimes();
            _clearStringTimes();
            Navigator.pop(context);
            final snackBar = SnackBar(
              backgroundColor: Color(0xFF00681B),
              content: Text(
                '$divAbbrev data cleared.',
                textAlign: TextAlign.center,
              ),
            );
            scaffoldState.currentState.showSnackBar(snackBar);
          },
          width: 20,
        ),
      ],
    ).show();
  }

  _clearStringTimes() async {
    StringTimes stringTimes = StringTimes();

    stringTimes.fiveToGo = '';
    stringTimes.showdown = '';
    stringTimes.smokeAndHope = '';
    stringTimes.outerLimits = '';
    stringTimes.accelerator = '';
    stringTimes.pendulum = '';
    stringTimes.speedOption = '';
    stringTimes.roundabout = '';

    await helper.insertStrings('$divAbbrev' + 'STR', stringTimes);
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
          "You have not entered a minimum of four classifier stage scores for this division.",
      buttons: [
        DialogButton(
          color: Colors.green,
          child: Text(
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
