import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'database_helper.dart';
import 'today_text_field.dart';

class BestStrings extends StatefulWidget {
  final String currentDivision;
  final String currBest5;
  final String currBestShow;
  final String currBestSH;
  final String currBestOL;
  final String currBestAcc;
  final String currBestPend;
  final String currBestSpeed;
  final String currBestRound;

  const BestStrings({
    Key key,
    this.currentDivision,
    this.currBest5,
    this.currBestShow,
    this.currBestSH,
    this.currBestOL,
    this.currBestAcc,
    this.currBestPend,
    this.currBestSpeed,
    this.currBestRound,
  }) : super(key: key);

  @override
  _BestStringsState createState() => _BestStringsState();
}

class _BestStringsState extends State<BestStrings> {
  DatabaseHelper helper = DatabaseHelper.instance;
  final TextEditingController _controller5STR = TextEditingController();
  final TextEditingController _controllerShowSTR = TextEditingController();
  final TextEditingController _controllerSHSTR = TextEditingController();
  final TextEditingController _controllerOLSTR = TextEditingController();
  final TextEditingController _controllerAccSTR = TextEditingController();
  final TextEditingController _controllerPendSTR = TextEditingController();
  final TextEditingController _controllerSpeedSTR = TextEditingController();
  final TextEditingController _controllerRoundSTR = TextEditingController();

  final FocusNode _focus5STR = FocusNode();
  final FocusNode _focusShowSTR = FocusNode();
  final FocusNode _focusSHSTR = FocusNode();
  final FocusNode _focusOLSTR = FocusNode();
  final FocusNode _focusAccSTR = FocusNode();
  final FocusNode _focusPendSTR = FocusNode();
  final FocusNode _focusSpeedSTR = FocusNode();
  final FocusNode _focusRoundSTR = FocusNode();

  String divAbbrev;

  String bestStage5 = '';
  String bestStageShow = '';
  String bestStageSH = '';
  String bestStageOL = '';
  String bestStageAcc = '';
  String bestStagePend = '';
  String bestStageSpeed = '';
  String bestStageRound = '';

  String _bestAvg5 = '';
  String _bestAvgShow = '';
  String _bestAvgSH = '';
  String _bestAvgOL = '';
  String _bestAvgAcc = '';
  String _bestAvgPend = '';
  String _bestAvgSpeed = '';
  String _bestAvgRound = '';

  String bestMatchTime = '';
  String matchPct = '';
  String totPeak = '';
  String bestMatchClass = '';

  double peak5 = 0.0;
  double peakShow = 0.0;
  double peakSH = 0.0;
  double peakOL = 0.0;
  double peakAcc = 0.0;
  double peakPend = 0.0;
  double peakSpeed = 0.0;
  double peakRound = 0.0;

  double matchPeak = 0.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _focus5STR.addListener(_focus5Listener);
    _focusShowSTR.addListener(_focusShowListener);
    _focusSHSTR.addListener(_focusSHListener);
    _focusOLSTR.addListener(_focusOLListener);
    _focusAccSTR.addListener(_focusAccListener);
    _focusPendSTR.addListener(_focusPendListener);
    _focusSpeedSTR.addListener(_focusSpeedListener);
    _focusRoundSTR.addListener(_focusRoundListener);

    if (widget.currBest5 != '') {
      _bestAvg5 = (double.parse(widget.currBest5) / 4).toStringAsFixed(2);
    }

    if (widget.currBestShow != '') {
      _bestAvgShow = (double.parse(widget.currBestShow) / 4).toStringAsFixed(2);
    }
    if (widget.currBestSH != '') {
      _bestAvgSH = (double.parse(widget.currBestSH) / 4).toStringAsFixed(2);
    }
    if (widget.currBestOL != '') {
      _bestAvgOL = (double.parse(widget.currBestOL) / 3).toStringAsFixed(2);
    }
    if (widget.currBestAcc != '') {
      _bestAvgAcc = (double.parse(widget.currBestAcc) / 4).toStringAsFixed(2);
    }
    if (widget.currBestPend != '') {
      _bestAvgPend = (double.parse(widget.currBestPend) / 4).toStringAsFixed(2);
    }
    if (widget.currBestSpeed != '') {
      _bestAvgSpeed =
          (double.parse(widget.currBestSpeed) / 4).toStringAsFixed(2);
    }
    if (widget.currBestRound != '') {
      _bestAvgRound =
          (double.parse(widget.currBestRound) / 4).toStringAsFixed(2);
    }

    peak5 = Constants.getPeak5(widget.currentDivision);
    peakShow = Constants.getPeakShow(widget.currentDivision);
    peakSH = Constants.getPeakSH(widget.currentDivision);
    peakOL = Constants.getPeakOL(widget.currentDivision);
    peakAcc = Constants.getPeakAcc(widget.currentDivision);
    peakPend = Constants.getPeakPend(widget.currentDivision);
    peakSpeed = Constants.getPeakSpeed(widget.currentDivision);
    peakRound = Constants.getPeakRound(widget.currentDivision);

    switch (widget.currentDivision) {
      case 'Rimfire Rifle Open (RFRO)':
        divAbbrev = 'RFROSTR';
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        divAbbrev = 'RFRISTR';
        break;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        divAbbrev = 'PCCOSTR';
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        divAbbrev = 'PCCISTR';
        break;

      case 'Rimfire Pistol Open (RFPO)':
        divAbbrev = 'RFPOSTR';
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        divAbbrev = 'RFPISTR';
        break;

      case 'Open (OPN)':
        divAbbrev = 'OPNSTR';
        break;

      case 'Carry Optics (CO)':
        divAbbrev = 'COSTR';
        break;

      case 'Production (PROD)':
        divAbbrev = 'PRODSTR';
        break;

      case 'Limited Optics (LO)':
        divAbbrev = 'LOSTR';
        break;

      case 'Limited (LTD)':
        divAbbrev = 'LTDSTR';
        break;

      case 'Single Stack (SS)':
        divAbbrev = 'SSSTR';
        break;

      case 'Optical Sight Revolver (OSR)':
        divAbbrev = 'OSRSTR';
        break;

      case 'Iron Sight Revolver (ISR)':
        divAbbrev = 'ISRSTR';
        break;
    }

    _getStringTimes();
  }

  @override
  void dispose() {
    _focus5STR.dispose();
    _focusShowSTR.dispose();
    _focusSHSTR.dispose();
    _focusOLSTR.dispose();
    _focusAccSTR.dispose();
    _focusPendSTR.dispose();
    _focusSpeedSTR.dispose();
    _focusRoundSTR.dispose();

    _controller5STR.dispose();
    _controllerShowSTR.dispose();
    _controllerSHSTR.dispose();
    _controllerOLSTR.dispose();
    _controllerAccSTR.dispose();
    _controllerPendSTR.dispose();
    _controllerSpeedSTR.dispose();
    _controllerRoundSTR.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Text(
            'Track Best Strings',
          ),
        ),
        backgroundColor: Constants.mtGreen,
        actions: const <Widget>[],
      ),

      //GestureDetector to dismiss keyboard by tapping outside any text field
      // (to account for ios keyboard that does not have a "Done" or check key).
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  FittedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
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
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    color: Constants.mtGreen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        SizedBox(
                          width: 95,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                'Stage/\r\n  Best',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            'Best Avg.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            'Best Single',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 85,
                          child: Text(
                            'Stage\r\nTarget',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
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
                              Text(
                                widget.currBest5,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _bestAvg5,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TodayTime(
                              Colors.black, _controller5STR, _focus5STR),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 75,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  bestStage5,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
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
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  child: Text(
                                    'Showdown',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                widget.currBestShow,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _bestAvgShow,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                        TodayTime(
                            Colors.black, _controllerShowSTR, _focusShowSTR),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 75,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  bestStageShow,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
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
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0),
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
                              Text(
                                widget.currBestSH,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _bestAvgSH,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                        TodayTime(Colors.black, _controllerSHSTR, _focusSHSTR),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 75.0,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  bestStageSH,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
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
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  child: Text(
                                    'Outer Limits',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                widget.currBestOL,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _bestAvgOL,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                        TodayTime(Colors.black, _controllerOLSTR, _focusOLSTR),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 75.0,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  bestStageOL,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
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
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    'Accelerator',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                widget.currBestAcc,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _bestAvgAcc,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                        TodayTime(
                            Colors.black, _controllerAccSTR, _focusAccSTR),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 75,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  bestStageAcc,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
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
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    'Pendulum',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Text(
                                widget.currBestPend,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _bestAvgPend,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                        TodayTime(
                            Colors.black, _controllerPendSTR, _focusPendSTR),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 75.0,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  bestStagePend,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
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
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0),
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
                              Text(
                                widget.currBestSpeed,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _bestAvgSpeed,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                        TodayTime(
                            Colors.black, _controllerSpeedSTR, _focusSpeedSTR),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 75,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  bestStageSpeed,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
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
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  child: Text(
                                    'Roundabout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                widget.currBestRound,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _bestAvgRound,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                        ),
                        TodayTime(
                            Colors.black, _controllerRoundSTR, _focusRoundSTR),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 75,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  bestStageRound,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(width: 75),
                          const SizedBox(
                            width: 65,
                            child: Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 60,
                            child: Text(
                              'Peak',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 75,
                            child: Text(
                              '%Peak',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(
                            width: 65,
                            child: Text(
                              'Class',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const SizedBox(
                            width: 65,
                            child: Text(
                              'Best Match',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 65,
                            child: Text(
                              bestMatchTime,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 65,
                            child: Text(
                              totPeak,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 65,
                            child: Text(
                              matchPct,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 55,
                            child: Text(
                              bestMatchClass,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  side: const BorderSide(
                                    width: 1,
                                    color: Constants.mtGreen,
                                  ),
                                  primary: Colors.white),
                              child: const Text(
                                'Clear',
                                style: TextStyle(
                                  color: Constants.mtGreen,
                                ),
                              ),
                              onPressed: () {
                                _clearBestSingles();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ])),
          ),
        ),
      ),
    );
  }

  Future<void> _focus5Listener() async {
    if (_focus5STR.hasFocus) {
      _controller5STR.selection = TextSelection(
          baseOffset: 0, extentOffset: _controller5STR.text.length);
    } else {
      if (_controller5STR.text != '') {
        setState(() {
          bestStage5 = _calcBestStage(peak5, _controller5STR.text, 4);
        });
      } else {
        setState(() {
          bestStage5 = '';
        });
      }
      _calcBestMatch();

      _saveStringTimes();
    }
  }

  Future<void> _focusShowListener() async {
    if (_focusShowSTR.hasFocus) {
      _controllerShowSTR.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerShowSTR.text.length);
    } else {
      if (_controllerShowSTR.text != '') {
        setState(() {
          bestStageShow = _calcBestStage(peakShow, _controllerShowSTR.text, 4);
        });
      } else {
        setState(() {
          bestStageShow = '';
        });
      }
      _calcBestMatch();
      _saveStringTimes();
    }
  }

  Future<void> _focusSHListener() async {
    if (_focusSHSTR.hasFocus) {
      _controllerSHSTR.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerSHSTR.text.length);
    } else {
      if (_controllerSHSTR.text != '') {
        setState(() {
          bestStageSH = _calcBestStage(peakSH, _controllerSHSTR.text, 4);
        });
      } else {
        setState(() {
          bestStageSH = '';
        });
      }
      _calcBestMatch();
      _saveStringTimes();
    }
  }

  Future<void> _focusOLListener() async {
    if (_focusOLSTR.hasFocus) {
      _controllerOLSTR.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerOLSTR.text.length);
    } else {
      if (_controllerOLSTR.text != '') {
        setState(() {
          bestStageOL = _calcBestStage(peakOL, _controllerOLSTR.text, 3);
        });
      } else {
        setState(() {
          bestStageOL = '';
        });
      }
      _calcBestMatch();
      _saveStringTimes();
    }
  }

  Future<void> _focusAccListener() async {
    if (_focusAccSTR.hasFocus) {
      _controllerAccSTR.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerAccSTR.text.length);
    } else {
      if (_controllerAccSTR.text != '') {
        setState(() {
          bestStageAcc = _calcBestStage(peakAcc, _controllerAccSTR.text, 4);
        });
      } else {
        setState(() {
          bestStageAcc = '';
        });
      }
      _calcBestMatch();
      _saveStringTimes();
    }
  }

  Future<void> _focusPendListener() async {
    if (_focusPendSTR.hasFocus) {
      _controllerPendSTR.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerPendSTR.text.length);
    } else {
      if (_controllerPendSTR.text != '') {
        setState(() {
          bestStagePend = _calcBestStage(peakPend, _controllerPendSTR.text, 4);
        });
      } else {
        setState(() {
          bestStagePend = '';
        });
      }
      _calcBestMatch();
      _saveStringTimes();
    }
  }

  Future<void> _focusSpeedListener() async {
    if (_focusSpeedSTR.hasFocus) {
      _controllerSpeedSTR.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerSpeedSTR.text.length);
    } else {
      if (_controllerSpeedSTR.text != '') {
        setState(() {
          bestStageSpeed =
              _calcBestStage(peakSpeed, _controllerSpeedSTR.text, 4);
        });
      } else {
        setState(() {
          bestStageSpeed = '';
        });
      }
      _calcBestMatch();
      _saveStringTimes();
    }
  }

  Future<void> _focusRoundListener() async {
    if (_focusRoundSTR.hasFocus) {
      _controllerRoundSTR.selection = TextSelection(
          baseOffset: 0, extentOffset: _controllerRoundSTR.text.length);
    } else {
      if (_controllerRoundSTR.text != '') {
        setState(() {
          bestStageRound =
              _calcBestStage(peakRound, _controllerRoundSTR.text, 4);
        });
      } else {
        setState(() {
          bestStageRound = '';
        });
      }
      _calcBestMatch();
      _saveStringTimes();
    }
  }

  void _calcBestMatch() {
    double bTotalTimes = 0.0;
    double totalPeak = 0.0;

    bestMatchTime = '';

    if (_controller5STR.text != '') {
      bTotalTimes = bTotalTimes + (double.parse(_controller5STR.text) * 4);
      totalPeak = totalPeak + peak5;
    }
    if (_controllerShowSTR.text != '') {
      bTotalTimes = bTotalTimes + (double.parse(_controllerShowSTR.text) * 4);
      totalPeak = totalPeak + peakShow;
    }
    if (_controllerSHSTR.text != '') {
      bTotalTimes = bTotalTimes + (double.parse(_controllerSHSTR.text) * 4);
      totalPeak = totalPeak + peakSH;
    }
    if (_controllerOLSTR.text != '') {
      bTotalTimes = bTotalTimes + (double.parse(_controllerOLSTR.text) * 3);
      totalPeak = totalPeak + peakOL;
    }
    if (_controllerAccSTR.text != '') {
      bTotalTimes = bTotalTimes + (double.parse(_controllerAccSTR.text) * 4);
      totalPeak = totalPeak + peakAcc;
    }
    if (_controllerPendSTR.text != '') {
      bTotalTimes = bTotalTimes + (double.parse(_controllerPendSTR.text) * 4);
      totalPeak = totalPeak + peakPend;
    }
    if (_controllerSpeedSTR.text != '') {
      bTotalTimes = bTotalTimes + (double.parse(_controllerSpeedSTR.text) * 4);
      totalPeak = totalPeak + peakSpeed;
    }
    if (_controllerRoundSTR.text != '') {
      bTotalTimes = bTotalTimes + (double.parse(_controllerRoundSTR.text) * 4);
      totalPeak = totalPeak + peakRound;
    }
    setState(() {
      if (bTotalTimes > 0) {
        bestMatchTime = bTotalTimes.toStringAsFixed(2);
        totPeak = totalPeak.toStringAsFixed(2);
        matchPeak = (totalPeak / bTotalTimes) * 100;
        matchPct = matchPeak.toStringAsFixed(2);

        if (matchPeak < 40.0) {
          bestMatchClass = 'D';
        } else if (matchPeak < 60.0) {
          bestMatchClass = 'C';
        } else if (matchPeak < 75.0) {
          bestMatchClass = 'B';
        } else if (matchPeak < 85.0) {
          bestMatchClass = 'A';
        } else if (matchPeak < 95.0) {
          bestMatchClass = 'M';
        } else {
          bestMatchClass = 'GM';
        }
      } else {
        bestMatchTime = '';
        matchPct = '';
        bestMatchClass = '';
        totPeak = '';
      }
      if (totalPeak > 0) {}
    });
  }

  void _clearBestSingles() {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Confirm...",
      desc: "This will clear all \"Best Single\" times and cannot be undone.",
      buttons: [
        DialogButton(
          width: 20,
          color: Colors.green,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          color: Colors.green,
          child: const Text(
            "Clear",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () {
            setState(() {
              _controller5STR.text = '';
              _controllerShowSTR.text = '';
              _controllerSHSTR.text = '';
              _controllerOLSTR.text = '';
              _controllerAccSTR.text = '';
              _controllerPendSTR.text = '';
              _controllerSpeedSTR.text = '';
              _controllerRoundSTR.text = '';

              bestStage5 = '';
              bestStageShow = '';
              bestStageSH = '';
              bestStageOL = '';
              bestStageAcc = '';
              bestStagePend = '';
              bestStageSpeed = '';
              bestStageRound = '';

              bestMatchTime = '';
              matchPct = '';
              bestMatchClass = '';
              totPeak = '';

              _saveStringTimes();
            });
            Navigator.pop(context);
          },
          width: 20,
        ),
      ],
    ).show();
  }

  String _calcBestStage(double peak, String timeText, int stringNum) {
    double bestStage = double.parse(timeText) * stringNum;
    double bestPct = (peak / bestStage) * 100;

    if (bestPct < 40.0) {
      return '${bestStage.toStringAsFixed(2)}/D';
    } else if (bestPct < 60.0) {
      return '${bestStage.toStringAsFixed(2)}/C';
    } else if (bestPct < 75.0) {
      return '${bestStage.toStringAsFixed(2)}/B';
    } else if (bestPct < 85.0) {
      return '${bestStage.toStringAsFixed(2)}/A';
    } else if (bestPct < 95.0) {
      return '${bestStage.toStringAsFixed(2)}/M';
    } else {
      return '${bestStage.toStringAsFixed(2)}/G';
    }
  }

  _saveStringTimes() async {
    StringTimes stringTimes = StringTimes();

    stringTimes.fiveToGo = _controller5STR.text;
    stringTimes.showdown = _controllerShowSTR.text;
    stringTimes.smokeAndHope = _controllerSHSTR.text;
    stringTimes.outerLimits = _controllerOLSTR.text;
    stringTimes.accelerator = _controllerAccSTR.text;
    stringTimes.pendulum = _controllerPendSTR.text;
    stringTimes.speedOption = _controllerSpeedSTR.text;
    stringTimes.roundabout = _controllerRoundSTR.text;

    await helper.insertStrings(divAbbrev, stringTimes);
  }

  _getStringTimes() async {
    int numRows = await helper.getCount(divAbbrev);

    StringTimes stringTimes = await helper.queryStringTimes(divAbbrev, numRows);

    if (numRows != 0) {
      setState(() {
        if (stringTimes.fiveToGo != '' && stringTimes.fiveToGo != null) {
          _controller5STR.text = stringTimes.fiveToGo;
          bestStage5 = _calcBestStage(peak5, stringTimes.fiveToGo, 4);
        }
        if (stringTimes.showdown != '' && stringTimes.showdown != null) {
          _controllerShowSTR.text = stringTimes.showdown;
          bestStageShow = _calcBestStage(peakShow, stringTimes.showdown, 4);
        }
        if (stringTimes.smokeAndHope != '' &&
            stringTimes.smokeAndHope != null) {
          _controllerSHSTR.text = stringTimes.smokeAndHope;
          bestStageSH = _calcBestStage(peakSH, stringTimes.smokeAndHope, 4);
        }
        if (stringTimes.outerLimits != '' && stringTimes.outerLimits != null) {
          _controllerOLSTR.text = stringTimes.outerLimits;
          bestStageOL = _calcBestStage(peakOL, stringTimes.outerLimits, 3);
        }
        if (stringTimes.accelerator != '' && stringTimes.accelerator != null) {
          _controllerAccSTR.text = stringTimes.accelerator;
          bestStageAcc = _calcBestStage(peakAcc, stringTimes.accelerator, 4);
        }
        if (stringTimes.pendulum != '' && stringTimes.pendulum != null) {
          _controllerPendSTR.text = stringTimes.pendulum;
          bestStagePend = _calcBestStage(peakPend, stringTimes.pendulum, 4);
        }
        if (stringTimes.speedOption != '' && stringTimes.speedOption != null) {
          _controllerSpeedSTR.text = stringTimes.speedOption;
          bestStageSpeed =
              _calcBestStage(peakSpeed, stringTimes.speedOption, 4);
        }
        if (stringTimes.roundabout != '' && stringTimes.roundabout != null) {
          _controllerRoundSTR.text = stringTimes.roundabout;
          bestStageRound = _calcBestStage(peakRound, stringTimes.roundabout, 4);
        }

        _calcBestMatch();
      });
    }
  }
}
