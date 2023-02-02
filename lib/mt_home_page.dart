import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:just_audio/just_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'match_tracker.dart';
import 'constants.dart';
import 'help_screen.dart';
import 'privacy_policy.dart';
import 'resources.dart';
import 'classification_summary.dart';

class MatchTrackerHomePage extends StatefulWidget {
  const MatchTrackerHomePage({Key key}) : super(key: key);

  @override
  _MatchTrackerHomePageState createState() => _MatchTrackerHomePageState();
}

class _MatchTrackerHomePageState extends State<MatchTrackerHomePage> {
  //Provide for use of snackbar.
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  AudioPlayer player; //Declare audio player for playing app sounds.

//Stings to hold recently used divisions
  String dropdownValue = 'Select Division';
  String firstRecent = '';
  String secondRecent = '';
  String thirdRecent = '';
  String fourthRecent = '';

  String appSounds;

  bool gunsCleared = false;

  //initState and run setData() to populate list of recent guns with saved selections.

  @override
  void initState() {
    player = AudioPlayer(); //Initialize audio player (from just_audio package.)
    //  Check whether application sounds have been turned off.
    getSoundStatus().then((value) {
      appSounds = value;
    });
    setRecents();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

// Methods to retrieve saved recent guns. Need to figure out how to return multiple keys
  Future<String> getSavedRecent1() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //If setting is null (no savedguns), return empty string.
    return preferences.get('recent1') ?? '';
  }

  Future<String> getSavedRecent2() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get('recent2') ?? '';
  }

  Future<String> getSavedRecent3() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get('recent3') ?? '';
  }

  Future<String> getSavedRecent4() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get('recent4') ?? '';
  }

  Future<void> setSoundStatus(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('SoundStatus', value);
  }

  Future<String> getSoundStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //if SoundStatus is null (hasn't been set), return 'On'
    return preferences.getString('SoundStatus') ?? 'On';
  }

  //Retrieve saved recent guns and display in list.
  setRecents() {
    getSavedRecent1().then((value) {
      if (value != '') {
        setState(() => firstRecent = value);
      }
    });

    getSavedRecent2().then((value) {
      if (value != '') {
        setState(() => secondRecent = value);
      }
    });

    getSavedRecent3().then((value) {
      if (value != '') {
        setState(() => thirdRecent = value);
      }
    });

    getSavedRecent4().then((value) {
      if (value != '') {
        setState(() => fourthRecent = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            child: Text('Steel Challenge Match Tracker'),
          ),
          backgroundColor: Constants.mtGreen,
          actions: <Widget>[
            FittedBox(
              child: PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: mainMenuChoiceAction,
                itemBuilder: (BuildContext context) {
                  return Constants.mainMenuChoices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: const TextStyle(fontSize: 16.0),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        if (newValue != 'Select Division') {
                          dropdownValue = newValue;
                          setState(() => showRecents(newValue));
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
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  GestureDetector(
                    onTap: trackFirstDiv,
                    onLongPressStart: (details) {
                      _divDeleteAlert(context, firstRecent);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: TextRecent(
                            recent: firstRecent,
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: trackSecondDiv,
                    onLongPressStart: (details) {
                      _divDeleteAlert(context, secondRecent);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: TextRecent(
                          recent: secondRecent,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: trackThirdDiv,
                    onLongPressStart: (details) {
                      _divDeleteAlert(context, thirdRecent);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: TextRecent(
                          recent: thirdRecent,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: trackFourthDiv,
                    onLongPressStart: (details) {
                      _divDeleteAlert(context, fourthRecent);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: TextRecent(
                          recent: fourthRecent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 190.0,
                    child: Image.asset('images/match_tracker_logo_front.jpg'),
                  ),
                  const Text(
                    'Version 2.2.5',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Method to add division selections to list of recent guns (up to 4, without duplicates).
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

  //Method to use Shared Preferences to save list of recently used (favorite) guns
  Future<void> saveRecents(
      String div1, String div2, String div3, String div4) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('recent1', div1);
    preferences.setString('recent2', div2);
    preferences.setString('recent3', div3);
    preferences.setString('recent4', div4);
  }

  //Take actions in response to selections from home screen main menu.
  Future<void> mainMenuChoiceAction(String choice) async {
    switch (choice) {
      case 'Clear Recent/Saved Guns':
        gunsCleared = true;
        //Clear any guns from the list and save the empty list to Shared Preferences.
        setState(() {
          firstRecent = '';
          secondRecent = '';
          thirdRecent = '';
          fourthRecent = '';
          dropdownValue = 'Select Division';
          saveRecents(firstRecent, secondRecent, thirdRecent, fourthRecent);
        });
        const snackBar = SnackBar(
          backgroundColor: Constants.mtGreen,
          content: Text(
            'Recent and saved guns cleared.',
            textAlign: TextAlign.center,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if (appSounds == 'On') {
          await player.setAsset('sounds/ding.mp3');
          player.play();
        }

        break;

      case 'Save Recent Guns':
        {
          const snackBar = SnackBar(
            backgroundColor: Constants.mtGreen,
            content: Text(
              'Recent guns saved.',
              textAlign: TextAlign.center,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          if (appSounds == 'On') {
            await player.setAsset('sounds/ding.mp3');
            player.play();
          }
          saveRecents(firstRecent, secondRecent, thirdRecent, fourthRecent);
        }
        break;

      case 'Classification Summary':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const ClassificationSummary();
            },
          ),
        );
        break;

      case 'App Sounds On/Off':
        {
          if (appSounds == 'On') {
            //If sounds are on, turn them off.
            setSoundStatus('Off');

            var snackbar = SnackBar(
              backgroundColor: Constants.mtGreen,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('App sounds off', textAlign: TextAlign.center),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 20,
                      width: 50,
                      child: FaIcon(Icons.volume_off_sharp),
                    ),
                  ),
                ],
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);

            await player.setAsset('sounds/sound_off.mp3');
            player.play();
          } else {
            //If they're not on, they must be off, so turn them on.
            setSoundStatus('On');
            var snackBar = SnackBar(
              backgroundColor: Constants.mtGreen,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('App sounds on', textAlign: TextAlign.center),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 20,
                      width: 30,
                      child: FaIcon(Icons.volume_up_sharp),
                    ),
                  ),
                  // ),
                ],
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            await player.setAsset('sounds/ding.mp3');
            player.play();
          }
          getSoundStatus().then((value) {
            appSounds = value;
          });
        }

        break;

      case 'Resources':
        //Navigate to the Resources page with useful links.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Resources();
            },
          ),
        );
        break;

      case 'Help':
        //Navigate to the Help page for instructions for using the app.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Help();
            },
          ),
        );
        break;

      case 'About':
        //Access required privacy policy
        showAboutDialog(
            context: context,
            // applicationIcon: Image.asset('images/mt_logo_small.png'),
            applicationName: 'Steel Challenge Match Tracker',
            applicationVersion: 'Version 2.2.5 (February 2023)',
            applicationLegalese:
                'Copyright \u00a9 2018-2023 Smokey Road Software',
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: GestureDetector(
                      child: const Text(
                        'View Privacy Policy',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                      ),
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Privacy();
                              },
                            ),
                          )),
                ),
              )
            ]);
    }
  }

  //Set up a match scoring page depending on which division is selected when user taps one of the saved guns.
  void trackFirstDiv() {
    if (firstRecent != '') {
      startTracking(firstRecent);
    }
  }

  void trackSecondDiv() {
    if (secondRecent != '') {
      startTracking(secondRecent);
    }
  }

  void trackThirdDiv() {
    if (thirdRecent != '') {
      startTracking(thirdRecent);
    }
  }

  void trackFourthDiv() {
    if (fourthRecent != '') {
      startTracking(fourthRecent);
    }
  }

  //Method to open match_tracker.dart, passing the division and the appSounds status (on/off).
  void startTracking(String division) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MatchTracker(
            currentDivision: division,
            appSounds: appSounds,
          );
        },
      ),
    );
  }

  //Show alert if a division isn't selected.
  _noDivisionAlert(context) {
    Alert(
      context: context,
      style: const AlertStyle(
          isButtonVisible: false,
          titleStyle: TextStyle(color: Constants.mtGreen)),
      title: 'Oops!',
      desc: 'You must select a division or tap a previous division.',
    ).show();
  }

//Method to allow competitors to remove guns from the list of recent
//or saved guns. This does not affect any saved guns unless the user
//saves the new list of guns (without the deleted ones). Method is called
//by pressing and holding the name of the division to be removed.

  _divDeleteAlert(context, String division) {
    division = division;
    Alert(context: context, desc: 'Remove $division from this list?', buttons: [
      DialogButton(
        width: 10,
        color: Constants.mtGreen,
        child: const Text(
          "No",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      DialogButton(
        width: 20,
        color: Constants.mtGreen,
        child: const Text(
          "Yes",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () {
          //Remove the selected division and adjust the list accordingly.
          if (division == firstRecent) {
            //Dismiss dialog
            Navigator.pop(context);

            setState(() {
              firstRecent = secondRecent;
              secondRecent = thirdRecent;
              thirdRecent = fourthRecent;
              fourthRecent = '';
            });
          }
          if (division == secondRecent) {
            Navigator.pop(context);
            setState(() {
              secondRecent = thirdRecent;
              thirdRecent = fourthRecent;
              fourthRecent = '';
            });
          }
          if (division == thirdRecent) {
            Navigator.pop(context);
            setState(() {
              thirdRecent = fourthRecent;
              fourthRecent = '';
            });
          }
          if (division == fourthRecent) {
            Navigator.pop(context);
            setState(() => fourthRecent = '');
          }
        },
      )
    ]).show();
  }
}

class TextRecent extends StatelessWidget {
  const TextRecent({
    Key key,
    @required this.recent,
  }) : super(key: key);

  final String recent;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        ' $recent ',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
