import 'package:flutter/material.dart';

import 'Constants.dart';

class StageDiagram extends StatelessWidget {
  final String stage;
  final String image;

  const StageDiagram(this.stage, this.image, {super.key});

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
        foregroundColor: Colors.white,
      ),
      body: InteractiveViewer(
        child: Image.asset(image),
      ),
    );
  }
}
