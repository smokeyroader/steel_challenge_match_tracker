import 'package:flutter/material.dart';

import 'constants.dart';

class Help extends StatelessWidget {
  const Help({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String bullet = '\u2022';

    return Scaffold(
        appBar: AppBar(
          title: const Text('Using Match Tracker'),
          backgroundColor: Constants.mtGreen,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Getting Started\r\n',
                          style: TextStyle(
                            color: Constants.mtGreen,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        const TextSpan(
                          style: TextStyle(fontSize: 18.0),
                          text:
                              'Begin by selecting the first division (gun type) you wish to track from the drop-down box '
                              'on the home page. As you select divisions, the home page will display each division you '
                              'have selected (up to four) in any one session. As you change guns during a match, you may '
                              'tap one of these to select your division without using the drop-down list. New with '
                              'Version 2.2.5: Press and hold any division you want to remove from your working list. Use the overflow '
                              'menu (three dots) at the top right of the screen to clear the list of recent guns or to save '
                              'the list so your favorite divisions will appear each time you open the app.\r\n\n',
                        ),
                        const TextSpan(
                          text: 'Entering Best Times\r\n',
                          style: TextStyle(
                            color: Constants.mtGreen,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        const TextSpan(
                          style: TextStyle(fontSize: 18.0),
                          text:
                              'After you’ve selected your first division, the scoring screen for that division '
                              'will appear. Using the SCSA website (www.steelchallenge.com) or your own records, '
                              'enter your best times (the times used for classification) into the “Today” field for '
                              'each stage you’ve shot (decimals will be added automatically). When you tap out of a field, '
                              'that time will show up as your “Best” time for that stage. When finished entering times '
                              'for all stages for which you have scores, click the “Clear Today” button to delete the “Today” '
                              'times and make ready to shoot your next match.\r\n\n'
                              'If you mistakenly enter a time that is HIGHER than your actual best time for a '
                              'stage, you can go back to that stage and enter the correct time. The best time '
                              'will be corrected when you leave the field. If you accidentally enter a LOWER time for a '
                              'stage, you must remove ALL DATA for that division and start over (so take your time!). '
                              'Use the overflow menu icon at the top right to clear all data for that division. If you’re new to Steel Challenge and '
                              'have no match record, just entering your times during your first match will establish best times '
                              'for each stage you shoot. \r\n\n',
                        ),
                        const TextSpan(
                          text: 'Scoring a Match\r\n',
                          style: TextStyle(
                            color: Constants.mtGreen,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        const TextSpan(
                          style: TextStyle(fontSize: 18.0),
                          text:
                              'To score a match and update your overall classification, just enter your '
                              'times for each stage as you shoot. If you’re shooting more than one gun '
                              'in a match, tap the “Change Guns” button or either back button to go back to the '
                              'home page and select another division. If you enter a '
                              'time for a stage that is lower than your previous best time, you will be '
                              'asked to confirm that you want to set a new best time for that stage. As '
                              'the match progresses, you can track your total time and class rating for '
                              'the match. Any new best times you set will be calculated into your best '
                              'overall scores so you can immediately see how your classification will be '
                              'affected. Total time cuts from your previous best times will also be shown '
                              'at the center bottom of the screen.\r\n\n',
                        ),
                        const TextSpan(
                          text: 'Cool Features\r\n',
                          style: TextStyle(
                            color: Constants.mtGreen,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          style: const TextStyle(fontSize: 18.0),
                          text:
                              '$bullet Tap any stage name to bring up a stage diagram for that stage and (new in Version 2.2.5) hear '
                              'what the stage sounds like being shot by a professional or top GM shooter (if app sounds have not been turned off).\r\n\n$bullet Tap and hold any '
                              '“Best” time to see (in a popup) the average string times it took to '
                              'achieve that stage score. New in Version 2.2.5: Tap "More" in the popup to see the average '
                              'string times needed for each class for that division and stage. \r\n\n$bullet Select “Track Class” from any division menu to '
                              'see how many seconds you must cut from your overall time to achieve '
                              'higher classifications in that division (the time cuts shown will be '
                              'most valid after you have shot all eight SCSA classification stages). \r\n\n'
                              '$bullet Select "Override Class" from the division menu if your current percentage does '
                              'not support your official classification in that division. You may also remove any previous overrides.\r\n\n$bullet Select '
                              '“Track Best Strings” from the division menu to record your best strings for '
                              'each stage. \r\n\n$bullet Select "Show/Hide Today Times" to toggle display of current match '
                              'times on or off. \r\n\n$bullet From the home screen menu, select "Classification Summary" '
                              'to see your current percentage and class for every division for '
                              'which you have a classification. \r\n\n$bullet From the home screen menu, select "App Sounds On/Off to enable or disable app sounds. \r\n\n$bullet Select '
                              '"Resources" from the main menu to see a list of useful links for Steel Challenge competitors.\r\n\n',
                        ),
                        const TextSpan(
                          text: 'Contact Us\r\n',
                          style: TextStyle(
                            color: Constants.mtGreen,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        const TextSpan(
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          text:
                              'Send bug reports or requests or recommendations for additional '
                              'features to scmatchtracker@gmail.com.\r\n\n',
                        ),
                        const TextSpan(
                          text: 'Disclaimer\r\n',
                          style: TextStyle(
                            color: Constants.mtGreen,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        const TextSpan(
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          text:
                              'The Steel Challenge Match Tracker app is not supported or '
                              'endorsed by or officially associated in any way '
                              'with the Steel Challenge Shooting Association (SCSA) or the '
                              'United States Practical Shooting Association (USPSA).',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
