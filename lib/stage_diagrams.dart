import 'package:flutter/material.dart';

import 'Constants.dart';

class StageDiagram extends StatelessWidget {
  final String stage;
  final String image;

  const StageDiagram(this.stage, this.image, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          stage,
        ),
        centerTitle: true,
        backgroundColor: Constants.mtGreen,
      ),
      body: InteractiveViewer(
        child: Image.asset(image),
      ),
    );
  }
}
