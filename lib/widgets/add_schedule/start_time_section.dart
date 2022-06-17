import 'package:flutter/material.dart';
import '../../../helpers/helpers.dart';

class StartTimeSection extends StatefulWidget {
  final DateTime? startTime;
  final Function? onStartTimeChanged;
  final bool? edit;
  const StartTimeSection(
      {Key? key, this.startTime, this.onStartTimeChanged, this.edit})
      : super(key: key);

  @override
  State<StartTimeSection> createState() => _StartTimeSectionState();
}

class _StartTimeSectionState extends State<StartTimeSection> {
  var _choicesList = ['Today', 'Tomorrow', 'Select'];
  String? _defaultValue = 'Today';

  @override
  initState() {
    if (widget.edit!) {
      var startTimeString = Helpers.dateTimeFormat(widget.startTime!, "MMM d");
      _choicesList = [
        startTimeString,
        'Select',
      ];
      _defaultValue = startTimeString;
    }
    super.initState();
  }

  Future<void> _onStartTimeChange(String value) async {
    DateTime dateTime = widget.startTime ?? DateTime.now();

    if (value == 'Tomorrow') {
      dateTime = dateTime.add(const Duration(days: 1));
    }
    if (value == 'Select') {
      dateTime = await showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: dateTime,
            lastDate: DateTime.now().add(const Duration(days: 30)),
            builder: (context, child) {
              // return Theme(
              //   data: Theme.of(context).copyWith(
              //     colorScheme: const ColorScheme.light(
              //       primary: Colors.orange,
              //       onPrimary: Colors.white,
              //     ),
              //     textButtonTheme: TextButtonThemeData(
              //       style: TextButton.styleFrom(
              //         primary: Colors.orange,
              //       ),
              //     ),
              //   ),
              //   child: child!,
              // );
              return child!;
            },
          ) ??
          dateTime;
      setState(() {
        var startTimeString = Helpers.dateTimeFormat(dateTime, "MMM d");
        _choicesList = [
          startTimeString,
          'Select',
        ];
        _defaultValue = startTimeString;
      });
    }
    widget.onStartTimeChanged!(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Start',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 40,
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          color: Colors.white,
          child: DropdownButton<String>(
            icon: const Icon(
              Icons.arrow_downward,
              size: 20,
            ),
            items: _choicesList.map(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            value: _defaultValue,
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                _onStartTimeChange(value!);
                _defaultValue = value;
              });
            },
            hint: const Text('Please select Date'),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            iconEnabledColor: Colors.black,
            iconSize: 14,
            underline: Container(),
          ),
        ),
      ],
    );
  }
}
