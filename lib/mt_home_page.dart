import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'help_screen.dart';
import 'match_tracker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'resources.dart';
import 'division_summary.dart';

class MatchTrackerHomePage extends StatefulWidget {
  @override
  _MatchTrackerHomePageState createState() => _MatchTrackerHomePageState();
}

class _MatchTrackerHomePageState extends State<MatchTrackerHomePage> {
  //Provide for use of snackbar.
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
//Stings to hold recently used divisions
  String dropdownValue = 'Select Division';
  String firstRecent = '';
  String secondRecent = '';
  String thirdRecent = '';
  String fourthRecent = '';

  bool gunsCleared = false;

  //initState and run setData() to populate list of recent guns with saved selections
//  Also lock orientation to portrait
  @override
  void initState() {
    super.initState();
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);

    setRecents();
  }

//  Future<bool> firstUse() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    if (preferences.get('firstUse') == null) {
//      _noDivisionAlert(context);
//      preferences.setBool('firstUse', false);
//    }
//  }

// Methods to retrieve saved recent guns. Need to figure out how to return multiple keys
  Future<String> getRecent1() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get('recent1') ?? '';
  }

  Future<String> getRecent2() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get('recent2') ?? '';
  }

  Future<String> getRecent3() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get('recent3') ?? '';
  }

  Future<String> getRecent4() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get('recent4') ?? '';
  }

//Retrieve saved recent guns and display in list
  setRecents() {
    getRecent1().then((value) {
      setState(() {
        firstRecent = value;
      });
    });

    getRecent2().then((value) {
      setState(() {
        secondRecent = value;
      });
    });

    getRecent3().then((value) {
      setState(() {
        thirdRecent = value;
      });
    });

    getRecent4().then((value) {
      setState(() {
        fourthRecent = value;
      });
    });
  }

  //Method to add division selections to list of recent guns (up to 4, without duplicates)
  void showRecents(String div) {
    if (firstRecent == '') {
      firstRecent = div;
      dropdownValue = 'Select Division';
    } else {
      if (secondRecent == '' && firstRecent != div) {
        secondRecent = div;
        dropdownValue = 'Select Division';
      } else {
        if (thirdRecent == '' && firstRecent != div && secondRecent != div) {
          thirdRecent = div;
          dropdownValue = 'Select Division';
        } else {
          if (fourthRecent == '' &&
              firstRecent != div &&
              secondRecent != div &&
              thirdRecent != div) {
            fourthRecent = div;
            dropdownValue = 'Select Division';
          }
        }
      }
    }

    startTracking(div);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(child: Text('Steel Challenge Match Tracker')),
          backgroundColor: Color(0xFF00681B),
          actions: <Widget>[
            FittedBox(
              child: PopupMenuButton<String>(
                onSelected: mainMenuChoiceAction,
                itemBuilder: (BuildContext context) {
                  return Constants.mainMenuChoices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
        key: scaffoldState, //Key for displaying snackbar
        body: Center(
          child: SingleChildScrollView(
            child: FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
//            SizedBox(height: 40.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        if (newValue != 'Select Division') {
                          setState(() {
                            dropdownValue = newValue;
                            showRecents(newValue);
                          });
                        } else {
                          _noDivisionAlert(context);
                        }
                      },
                      items: Constants.divisions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
//            SizedBox(
//              height: 30.0,
//            ),
                  GestureDetector(
                    onTap: trackFirstDiv,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          ' $firstRecent ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: trackSecondDiv,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          ' $secondRecent ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: trackThirdDiv,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          ' $thirdRecent ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: trackFourthDiv,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          ' $fourthRecent ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 190.0,
                    child: Image.asset('images/match_tracker_logo_front.jpg'),
                  ),

                  Text(
                    'Version 2.2.2',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Method to use Shared Preferences to save list of recently used (favorite) guns
  Future<void> saveRecents(
      String div1, String div2, String div3, String div4) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('recent1', div1);
    preferences.setString('recent2', div2);
    preferences.setString('recent3', div3);
    preferences.setString('recent4', div4);

    if (!gunsCleared) {
      final snackBar = SnackBar(
        backgroundColor: Color(0xFF00681B),
        content: Text(
          'Recent guns saved.',
          textAlign: TextAlign.center,
        ),
      );
      scaffoldState.currentState.showSnackBar(snackBar);
    }
    gunsCleared = false;
  }

  //Take actions in response to selections from main menu
  void mainMenuChoiceAction(String choice) {
    if (choice == 'Clear Recent Guns') {
      gunsCleared = true;
      //Clear any guns from the list and save the empty list to Shared Preferences
      setState(() {
        firstRecent = '';
        secondRecent = '';
        thirdRecent = '';
        fourthRecent = '';
        dropdownValue = 'Select Division';
        saveRecents(firstRecent, secondRecent, thirdRecent, fourthRecent);
      });
    } else if (choice == 'Save Recent Guns') {
      //Save recent guns so they will be displayed when user opens the app again
      if (firstRecent == '' &&
          secondRecent == '' &&
          thirdRecent == '' &&
          fourthRecent == '') {
        final snackBar = SnackBar(
          backgroundColor: Color(0xFF00681B),
          content: Text(
            'You have no recent guns to save.',
            textAlign: TextAlign.center,
          ),
        );
        scaffoldState.currentState.showSnackBar(snackBar);
//        _noRecentGunsAlert(context);
      } else {
        saveRecents(firstRecent, secondRecent, thirdRecent, fourthRecent);
      }
    } else if (choice == 'Classification Summary') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DivisionSummary();
          },
        ),
      );
    } else if (choice == 'Resources') {
      //Navigate to the Resources page with useful links

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Resources();
          },
        ),
      );
    } else {
      //Navigate to the Help page for instructions for using the app
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Help();
          },
        ),
      );
    }
  }

  //Set up a match scoring page depending on which division is selected when user taps one of the saved guns
  void trackFirstDiv() {
    if (firstRecent != '') {
      startTracking('$firstRecent');
    }
  }

  void trackSecondDiv() {
    if (secondRecent != '') {
      startTracking('$secondRecent');
    }
  }

  void trackThirdDiv() {
    if (thirdRecent != '') {
      startTracking('$thirdRecent');
    }
  }

  void trackFourthDiv() {
    if (fourthRecent != '') {
      startTracking('$fourthRecent');
    }
  }

  //Method to open match tracker page with division selected

  void startTracking(String division) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MatchTracker(
            currentDivision: '$division',
          );
        },
      ),
    );
  }

  //Show alert if a division isn't selected before pressing 'Continue'
  _noDivisionAlert(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Oops!",
      desc: "You must select a division or tap a previous division.",
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
