import 'package:flutter/material.dart';
import 'mt_home_page.dart';
import 'package:flutter/services.dart';

//Lock screen orientation on Android devices
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MatchTrackerHomePage(),
      ),
    );
  }
}
