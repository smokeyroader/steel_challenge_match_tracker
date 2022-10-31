import 'package:flutter/material.dart';

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
        backgroundColor: const Color(0xFF00681B),
      ),
      body: InteractiveViewer(
        child: Image.asset(image),
      ),
    );
  }
}
