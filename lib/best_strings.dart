import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'database_helper.dart';

class BestStrings extends StatefulWidget {
  final String currentDivision;
  final String bestStr5;
  final String bestStrShow;
  final String bestStrSH;
  final String bestStrOL;
  final String bestStrAcc;
  final String bestStrPend;
  final String bestStrSpeed;
  final String bestStrRound;

  BestStrings({
    Key key,
    this.currentDivision,
    this.bestStr5,
    this.bestStrShow,
    this.bestStrSH,
    this.bestStrOL,
    this.bestStrAcc,
    this.bestStrPend,
    this.bestStrSpeed,
    this.bestStrRound,
  }) : super(key: key);

  @override
  _BestStringsState createState() => _BestStringsState();
}

class _BestStringsState extends State<BestStrings> {
  DatabaseHelper helper = DatabaseHelper.instance;
  TextEditingController _controller5STR = TextEditingController();
  TextEditingController _controllerShowSTR = TextEditingController();
  TextEditingController _controllerSHSTR = TextEditingController();
  TextEditingController _controllerOLSTR = TextEditingController();
  TextEditingController _controllerAccSTR = TextEditingController();
  TextEditingController _controllerPendSTR = TextEditingController();
  TextEditingController _controllerSpeedSTR = TextEditingController();
  TextEditingController _controllerRoundSTR = TextEditingController();

  FocusNode _focus5STR;
  FocusNode _focusShowSTR;
  FocusNode _focusSHSTR;
  FocusNode _focusOLSTR;
  FocusNode _focusAccSTR;
  FocusNode _focusPendSTR;
  FocusNode _focusSpeedSTR;
  FocusNode _focusRoundSTR;

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

  double peak5;
  double peakShow;
  double peakSH;
  double peakOL;
  double peakAcc;
  double peakPend;
  double peakSpeed;
  double peakRound;

//  double totPeak;
  double matchPeak;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _focus5STR = FocusNode();
    _focusShowSTR = FocusNode();
    _focusSHSTR = FocusNode();
    _focusOLSTR = FocusNode();
    _focusAccSTR = FocusNode();
    _focusPendSTR = FocusNode();
    _focusSpeedSTR = FocusNode();
    _focusRoundSTR = FocusNode();

    _focus5STR.addListener(_focus5Listener);
    _focusShowSTR.addListener(_focusShowListener);
    _focusSHSTR.addListener(_focusSHListener);
    _focusOLSTR.addListener(_focusOLListener);
    _focusAccSTR.addListener(_focusAccListener);
    _focusPendSTR.addListener(_focusPendListener);
    _focusSpeedSTR.addListener(_focusSpeedListener);
    _focusRoundSTR.addListener(_focusRoundListener);

    if (widget.bestStr5 != '') {
      _bestAvg5 = (double.parse(widget.bestStr5) / 4).toStringAsFixed(2);
    }

    if (widget.bestStrShow != '') {
      _bestAvgShow = (double.parse(widget.bestStrShow) / 4).toStringAsFixed(2);
    }
    if (widget.bestStrSH != '') {
      _bestAvgSH = (double.parse(widget.bestStrSH) / 4).toStringAsFixed(2);
    }
    if (widget.bestStrOL != '') {
      _bestAvgOL = (double.parse(widget.bestStrOL) / 3).toStringAsFixed(2);
    }
    if (widget.bestStrAcc != '') {
      _bestAvgAcc = (double.parse(widget.bestStrAcc) / 4).toStringAsFixed(2);
    }
    if (widget.bestStrPend != '') {
      _bestAvgPend = (double.parse(widget.bestStrPend) / 4).toStringAsFixed(2);
    }
    if (widget.bestStrSpeed != '') {
      _bestAvgSpeed =
          (double.parse(widget.bestStrSpeed) / 4).toStringAsFixed(2);
    }
    if (widget.bestStrRound != '') {
      _bestAvgRound =
          (double.parse(widget.bestStrRound) / 4).toStringAsFixed(2);
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

      case 'Pistol-Caliber Carbine Optic (PCCO)':
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
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Track Best Strings',
        ),
        backgroundColor: Color(0xFF00681B),
        actions: <Widget>[],
      ),
//      key: scaffoldState,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '${widget.currentDivision}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00681B),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 45.0,
                color: Color(0xFF00681B),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
//                    color: Colors.orange,
                      width: 95.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Stage',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
//                    color: Colors.purple,
                      width: 60.0,
                      child: Text(
                        'Best Avg.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 60.0,
//                    color: Colors.teal,
                      child: Text(
                        'Best Single',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 85.0,
//                    color: Colors.amber,
                      child: Text(
                        'Best Stage',
                        style: TextStyle(
                            fontSize: 18.0,
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
                    Container(
//                      color: Colors.blue,
                      width: 120.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '5 to Go',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.bestStr5}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
//                      color: Colors.red,
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_bestAvg5',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
//                      color: Colors.green,
                        width: 45.0,
                        child: TextField(
                          style: TextStyle(fontSize: 18.0),
//                        style: TextStyle(color: newBestColor5),
                          controller: _controller5STR,
                          focusNode: _focus5STR,
                          decoration: InputDecoration.collapsed(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            BlacklistingTextInputFormatter(
                              RegExp('[\\-|,\\ ]'),
                            ),
                          ],
                          onChanged: (text) {
                            autoFormat(_controller5STR);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
//                        color: Colors.yellow,
                        width: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '$bestStage5',
                            style: TextStyle(fontSize: 18.0),
                          ),
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
//                      color: Colors.blue,
                      width: 120.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Showdown',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.bestStrShow}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
//                      color: Colors.red,
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_bestAvgShow',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )),
                    ),
                    Container(
//                      color: Colors.green,
                      width: 45.0,
                      child: TextField(
                        style: TextStyle(fontSize: 18.0),
//                        style: TextStyle(color: newBestColor5),
                        controller: _controllerShowSTR,
                        focusNode: _focusShowSTR,
                        decoration: InputDecoration.collapsed(
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          BlacklistingTextInputFormatter(
                            RegExp('[\\-|,\\ ]'),
                          ),
                        ],
                        onChanged: (text) {
                          autoFormat(_controllerShowSTR);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
//                        color: Colors.yellow,
                        width: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '$bestStageShow',
                            style: TextStyle(fontSize: 18.0),
                          ),
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
//                      color: Colors.blue,
                      width: 120.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Smoke&Hope',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.bestStrSH}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
//                      color: Colors.red,
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_bestAvgSH',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )),
                    ),
                    Container(
//                      color: Colors.green,
                      width: 45.0,
                      child: TextField(
                        style: TextStyle(fontSize: 18.0),
//                        style: TextStyle(color: newBestColorSH),
                        controller: _controllerSHSTR,
                        focusNode: _focusSHSTR,
                        decoration: InputDecoration.collapsed(
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          BlacklistingTextInputFormatter(
                            RegExp('[\\-|,\\ ]'),
                          ),
                        ],
                        onChanged: (text) {
                          autoFormat(_controllerSHSTR);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
//                        color: Colors.yellow,
                        width: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '$bestStageSH',
                            style: TextStyle(fontSize: 18.0),
                          ),
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
//                      color: Colors.blue,
                      width: 120.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Outer Limits',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.bestStrOL}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
//                      color: Colors.red,
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_bestAvgOL',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )),
                    ),
                    Container(
//                      color: Colors.green,
                      width: 45.0,
                      child: TextField(
                        style: TextStyle(fontSize: 18.0),
//                        style: TextStyle(color: newBestColorOL),
                        controller: _controllerOLSTR,
                        focusNode: _focusOLSTR,
                        decoration: InputDecoration.collapsed(
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          BlacklistingTextInputFormatter(
                            RegExp('[\\-|,\\ ]'),
                          ),
                        ],
                        onChanged: (text) {
                          autoFormat(_controllerOLSTR);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
//                        color: Colors.yellow,
                        width: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '$bestStageOL',
                            style: TextStyle(fontSize: 18.0),
                          ),
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
//                      color: Colors.blue,
                      width: 120.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Accelerator',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.bestStrAcc}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
//                      color: Colors.red,
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_bestAvgAcc',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )),
                    ),
                    Container(
//                      color: Colors.green,
                      width: 45.0,
                      child: TextField(
                        style: TextStyle(fontSize: 18.0),
//                        style: TextStyle(color: newBestColorAcc),
                        controller: _controllerAccSTR,
                        focusNode: _focusAccSTR,
                        decoration: InputDecoration.collapsed(
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          BlacklistingTextInputFormatter(
                            RegExp('[\\-|,\\ ]'),
                          ),
                        ],
                        onChanged: (text) {
                          autoFormat(_controllerAccSTR);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
//                        color: Colors.yellow,
                        width: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '$bestStageAcc',
                            style: TextStyle(fontSize: 18.0),
                          ),
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
//                      color: Colors.blue,
                      width: 120.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pendulum',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.bestStrPend}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
//                      color: Colors.red,
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_bestAvgPend',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )),
                    ),
                    Container(
//                      color: Colors.green,
                      width: 45.0,
                      child: TextField(
                        style: TextStyle(fontSize: 18.0),
//                        style: TextStyle(color: newBestColorPend),
                        controller: _controllerPendSTR,
                        focusNode: _focusPendSTR,
                        decoration: InputDecoration.collapsed(
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          BlacklistingTextInputFormatter(
                            RegExp('[\\-|,\\ ]'),
                          ),
                        ],
                        onChanged: (text) {
                          autoFormat(_controllerPendSTR);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
//                        color: Colors.yellow,
                        width: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '$bestStagePend',
                            style: TextStyle(fontSize: 18.0),
                          ),
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
//                      color: Colors.blue,
                      width: 120.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Speed Option',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.bestStrSpeed}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
//                      color: Colors.red,
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_bestAvgSpeed',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )),
                    ),
                    Container(
//                      color: Colors.green,
                      width: 45.0,
                      child: TextField(
                        style: TextStyle(fontSize: 18.0),
//                        style: TextStyle(color: newBestColorSpeed),
                        controller: _controllerSpeedSTR,
                        focusNode: _focusSpeedSTR,
                        decoration: InputDecoration.collapsed(
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          BlacklistingTextInputFormatter(
                            RegExp('[\\-|,\\ ]'),
                          ),
                        ],
                        onChanged: (text) {
                          autoFormat(_controllerSpeedSTR);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '$bestStageSpeed',
                            style: TextStyle(fontSize: 18.0),
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
                    Container(
//                      color: Colors.blue,
                      width: 120.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Roundabout',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.bestStrRound}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
//                      color: Colors.red,
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_bestAvgRound',
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )),
                    ),
                    Container(
//                      color: Colors.green,
                      width: 45.0,
                      child: TextField(
                        style: TextStyle(fontSize: 18.0),
//                        style: TextStyle(color: newBestColorRound),
                        controller: _controllerRoundSTR,
                        focusNode: _focusRoundSTR,
                        decoration: InputDecoration.collapsed(
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          BlacklistingTextInputFormatter(
                            RegExp('[\\-|,\\ ]'),
                          ),
                        ],
                        onChanged: (text) {
                          autoFormat(_controllerRoundSTR);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
//                        color: Colors.yellow,
                        width: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '$bestStageRound',
                            style: TextStyle(fontSize: 18.0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(width: 75.0),
                    Container(
                      width: 65.0,
                      child: Text(
                        'Time',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      width: 65.0,
                      child: Text(
                        'Peak',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      width: 65.0,
                      child: Text(
                        '%Peak',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      width: 65.0,
                      child: Text(
                        'Class',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 65.0,
                        child: Text(
                          'Best Match',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Container(
                        width: 65.0,
                        child: Text(
                          '$bestMatchTime',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Container(
                        width: 65.0,
                        child: Text(
                          '$totPeak',
                          style: TextStyle(fontSize: 16.0),
//                      style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Container(
                        width: 65.0,
                        child: Text(
                          '$matchPct',
                          style: TextStyle(fontSize: 16.0),
//                      style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Container(
                        width: 55.0,
                        child: Text(
                          '$bestMatchClass',
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.left,
//                      style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xFF00681B))),
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(30.0)),
//
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              color: Color(0xFF00681B),
//                                fontWeight: FontWeight.w900,
                            ),
                          ),
                          onPressed: () {
                            _clearBestSingles();
//                       confirmClearToday();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ])),
      ),
    );
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
  }

  void autoFormat(TextEditingController controller) {
    String text = controller.text;
    if (text != '') {
      setState(() {
        text = text.replaceAll('.', '');
        text = text.replaceAll(' ', '');
        if (text.length == 1)
          text = '.' + text;
        else if (text.length == 2)
          text = '.' + text;
        else if (text.length > 2) {
          text = text.substring(0, text.length - 2) +
              '.' +
              text.substring(text.length - 2, text.length);
        }
        controller.text = text;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: (text ?? '').length));
      });
    }
  }

  Future<Null> _focus5Listener() async {
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
//      setState(() {
      _calcBestMatch();
//      });

      _saveStringTimes();
    }
  }

  Future<Null> _focusShowListener() async {
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

  Future<Null> _focusSHListener() async {
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

  Future<Null> _focusOLListener() async {
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

  Future<Null> _focusAccListener() async {
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

  Future<Null> _focusPendListener() async {
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

  Future<Null> _focusSpeedListener() async {
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

  Future<Null> _focusRoundListener() async {
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
        } else
          bestMatchClass = 'GM';
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
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
//          width: 60,
        ),
        DialogButton(
          color: Colors.green,
          child: Text(
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
//            calcBestMatch();
          },
          width: 20,
        ),
      ],
    ).show();
  }

  String _calcBestStage(double peak, String timeText, int stringNum) {
    double bestStage = double.parse(timeText) * stringNum;
    double bestPct = (peak / bestStage) * 100;
//    setState(() {
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
//    });
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

    int id = await helper.insertStrings(divAbbrev, stringTimes);
  }

  _getStringTimes() async {
    int numRows = await helper.getCount('$divAbbrev');

    StringTimes stringTimes = await helper.queryStringTimes(divAbbrev, numRows);
    if (numRows == 0) {
      print('read row $numRows: empty');
    } else {
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
