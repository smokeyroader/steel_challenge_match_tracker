import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Using Match Tracker'),
          backgroundColor: Color(0xFF00681B),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
//                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Update Notice\r\n',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16.0),
                      ),
                      TextSpan(
                          text:
                              'The updated version of Steel Challenge Match Tracker has been rewritten with a different database structure. This means that users of previous versions will have to reenter their best times for all the divisions they shoot. We regret the inconvenience, but the new implementation will allow more efficient updates and bug fixes affecting both the Android and iOS versions of the app as well as facilitating the addition of new features in the future.\r\n\n'),
                      TextSpan(
                        text: 'Getting Started\r\n',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16.0),
                      ),
                      TextSpan(
                        text:
                            'Begin by selecting the division(s) (gun type) you wish to track from the drop-down box on the main page. The page will display each division you have selected (up to four) in any one session. As you change guns during a match, you may tap one of these to select your division without having to use the drop-down list. Use the overflow menu (three dots) at the top right of the screen to clear the list of recent guns or to save the list so your favorite divisions will appear each time you open the app.\r\n\n',
                      ),
                      TextSpan(
                        text: 'Entering Best Times\r\n',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                      ),
                      TextSpan(
                        text:
                            'After you’ve selected a division, tap the division name or the “Continue” button to bring up the score entry screen. Using the SCSA website (www.steelchallenge.com) or your own records, enter your best times (the times used for classification) into the “Today” field for each stage you’ve shot (decimals will be added automatically). When you tap out of a field, that time will show up as your “Best” time for that stage. When finished, click the “Clear Stage Times” button to delete the “Today” times and make ready to shoot your next match.\r\n'
                            'If you mistakenly enter a time that is HIGHER than your actual best time for a stage, you can go back to that stage and enter the correct time. The best time will be corrected when you leave the field. If you accidentally enter a LOWER time for a stage, you must remove ALL DATA for that division and start over (so take your time!). Use the overflow menu icon at the top right to clear all data for that division. If you’re entering scores for more than one division, use the “Change Gun” button to select another division and repeat the process. (If you’re new to Steel Challenge and have no match record, just enter your times during your next match; your best times will be recorded as you shoot.)\r\n\n',
                      ),
                      TextSpan(
                        text: 'Scoring a Match\r\n',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16.0),
                      ),
                      TextSpan(
                        text:
                            'To score a match and update your overall classification, just enter your times for each stage as you shoot. If you’re shooting more than one gun, tap the “Change Guns” button and score the other gun(s). If you enter a time for a stage that is lower than your previous best time, you will be asked to confirm that you want to set a new best time for that stage. As the match progresses, you can track your total time and class rating for the match. Any new best times you set will be calculated into your best overall scores so you can immediately see how your classification will be affected. Any time cuts from your previous best times will also be shown at the center bottom of the screen.\r\n\n',
                      ),
                      TextSpan(
                        text: 'Cool Features\r\n',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16.0),
                      ),
                      TextSpan(
                        text:
                            'Tap any “Best” time to see (in a popup) the average string times it took to achieve that score. Select “Track Class” to see how many seconds you must cut from your overall time to achieve higher classifications (the time cuts shown will be most valid after you have shot all eight SCSA classification stages). Select "Override Class" if your current percentage does not support your official classification in that division. Select “Track Best Strings” to record your best strings for each stage. Tap any stage name to call up a stage diagram. Select "Show/Hide Today Times" to toggle current match times on or off. Select “Resources” from the main menu to see a list of useful links for Steel Challenge competitors.\r\n\n',
                      ),
                      TextSpan(
                        text: 'Contact Us\r\n',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16.0),
                      ),
                      TextSpan(
                        text:
                            'Send bug reports or requests/recommendations for features to scmatchtracker@gmail.com.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
