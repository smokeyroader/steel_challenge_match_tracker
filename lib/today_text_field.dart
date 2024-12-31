import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

////This class draws each today time textfield box on the screen and handles
////auto decimal formatting when user enters a time.

class TodayTime extends StatefulWidget {
  final Color color;
  final TextEditingController controller;
  final FocusNode focusNode;

  const TodayTime(this.color, this.controller, this.focusNode, {super.key});

  @override
  TodayTimeState createState() => TodayTimeState();
}

class TodayTimeState extends State<TodayTime> {
//Set a switch to let the system distinguish between changes made by the user
//and changes made by the system in response to user input. Default value is
//false and is only changed to true briefly by the autoFormat method.
  bool ignoreChange = false;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        height: 20,
        width: 60,
        child: TextField(
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: 16.0,
            color: widget.color,
            fontWeight: widget.color == Colors.green
                ? FontWeight.bold
                : FontWeight.normal,
          ),
          controller: widget.controller,
          focusNode: widget.focusNode,
          decoration: const InputDecoration.collapsed(
            hintText: null,
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(5),
            FilteringTextInputFormatter.deny(RegExp('[\\-|,.\\ ]')),
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          onChanged: (text) {
            autoFormat(widget.controller);
          },
        ),
      ),
    );
  }

//  *******************************************************
//Method to automatically add decimal to time inputs

  void autoFormat(TextEditingController controller) {
    //Text entry can go into infinite loop under some conditions, with the
    //system apparently failing to distinguish between system (programmatic)change and user change.
    //The ignoreChange switch is an attempt to address this.

    //If ignore change is false...
    if (!ignoreChange) {
      String text = controller.text;

      if (text != '') {
        text = text.replaceAll('.', '');
        if (text.length <= 2) {
          text = '.$text';
        } else {
          text = '${text.substring(0, text.length - 2)}.${text.substring(text.length - 2, text.length)}';
        }
      }
      //Ignore changes made by the system
      ignoreChange = true;
      setState(() {
        controller.text = text;
        //Move cursor to first position after text changed
        controller.selection = TextSelection.fromPosition(
          TextPosition(
            offset: (text).length,
          ),
        );
      });
    }
    //Turn off ignore change to prepare for next text change
    ignoreChange = false;
//  }
  }
}
