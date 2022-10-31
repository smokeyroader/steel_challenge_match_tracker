// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//
class TodayTime extends StatefulWidget {
  final Color color;
  final TextEditingController controller;
  final FocusNode focusNode;

  const TodayTime(this.color, this.controller, this.focusNode, {Key key})
      : super(key: key);

  @override
  _TodayTimeState createState() => _TodayTimeState();
}

class _TodayTimeState extends State<TodayTime> {
  bool ignoreChange = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 20,
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
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
//          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        onChanged: (text) {
          autoFormat(widget.controller);
        },
      ),
    );
  }

//  *******************************************************
//Method to automatically add decimal to time inputs

  void autoFormat(TextEditingController controller) {
    //Text entry can go into infinite loop under some conditions, with the
    //system apparently failing to distinguish between system (programmatic)change and user change.
    //The ignoreChange switch is an attempt to address this. Will monitor the effectiveness of this 'fix.'

    if (!ignoreChange) {
      String text = controller.text;

      if (text != '') {
        // if (text.substring(0, 2) != '.') {}
        //Meaningless empty 'if statement' above inserted to make it work. (Digits will be misplaced if not included.)

        text = text.replaceAll('.', '');

        if (text.length <= 2) {
          text = '.' + text;
        } else {
          text = text.substring(0, text.length - 2) +
              '.' +
              text.substring(text.length - 2, text.length);
        }
      }
      ignoreChange = true;
      setState(() {
        controller.text = text;
        //Move cursor to first position after text changed
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: (text ?? '').length));
      });
    }
    ignoreChange = false;
//  }
  }
}
