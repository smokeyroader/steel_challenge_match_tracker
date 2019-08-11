import 'package:flutter/material.dart';

class StageDiagram extends StatelessWidget {
  final String stage;
  final String image;

  StageDiagram(
//    Key key,
    this.stage,
    this.image,
  );
//      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '$stage',
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00681B),
      ),
      body: Container(
        child: Image.asset('$image'),
      ),
    );
  }
}
