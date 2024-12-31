import 'package:flutter/material.dart';
import 'constants.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Policy'),
          backgroundColor: Constants.mtGreen,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: <Widget>[
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Privacy Policy Update\r\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          style: TextStyle(fontSize: 18.0),
                          text:
                              'Our Privacy Policy was last updated on January 26, 2023.\r\n\n',
                        ),
                        TextSpan(
                          text: 'Data Collected\r\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          style: TextStyle(fontSize: 18.0),
                          text:
                              'Steel Challenge Match Tracker, a product of Smokey Road Software,'
                              ' is a standalone app that collects neither personal user information nor app usage data. \r\n\n',
                        ),
                        TextSpan(
                          text: 'Privacy\r\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          style: TextStyle(fontSize: 18.0),
                          text:
                              'Your privacy is ensured by the fact that any data generated as you use the app '
                              'is contained solely within the app itself or on your device '
                              'and is therefore available only to you.\r\n\n',
                        ),
                        TextSpan(
                          text: 'Links to Websites\r\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          style: TextStyle(fontSize: 18.0),
                          text:
                              'Steel Challenge Match Tracker provides links to websites that'
                              ' are independent of the Match Tracker app or Smokey Road Software.'
                              ' If you click on one of these links, you will be directed to that third party’s'
                              ' site. We strongly advise you to review the Privacy Policy of every site you visit.\r\n\n'
                              'Smokey Road Software has no control over and assumes no responsibility for the'
                              ' content, privacy policies, or practices of any third-party sites or services.\r\n\n',
                        ),
                        TextSpan(
                          text: 'Contact Us\r\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          text:
                              'If you have questions about this Privacy Policy, email scmatchtracker@gmail.com.\r\n\n',
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
