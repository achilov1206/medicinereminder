import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberSelector extends StatefulWidget {
  final ValueChanged? onChanged;
  int? currentValue, minValue, maxValue;
  NumberSelector({
    Key? key,
    this.onChanged,
    this.currentValue,
    this.maxValue,
    this.minValue,
  }) : super(key: key);

  @override
  _NumberSelectorState createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  int _currentValue = 2;
  Widget cancelButton(context) => TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );

  Widget continueButton(value) => TextButton(
        child: const Text("Continue"),
        onPressed: () {
          widget.onChanged!(_currentValue);
          Navigator.of(context, rootNavigator: true).pop();
        },
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      titleTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
      title: const Text('Every X Days'),
      content: NumberPicker(
        value:
            widget.currentValue == null ? _currentValue : widget.currentValue!,
        minValue: widget.minValue!,
        maxValue: widget.maxValue!,
        textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
        selectedTextStyle: const TextStyle(color: Colors.orange, fontSize: 30),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
            bottom: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() => _currentValue = value);
          widget.currentValue = null;
        },
      ),
      actions: [
        cancelButton(context),
        continueButton(_currentValue),
      ],
    );
  }
}
