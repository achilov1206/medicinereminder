import 'package:flutter/material.dart';
import '../helpers/helpers.dart';
import './number_selector.dart';

class DurationSelector extends StatefulWidget {
  final List<dynamic>? duration;
  final DateTime? startTime;

  const DurationSelector({
    Key? key,
    this.duration,
    this.startTime,
  }) : super(key: key);

  @override
  _DurationSelectorState createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  int _selected = 0;
  DateTime _untilDate = DateTime.now();
  int _forXDays = 2;
  List<dynamic>? _duration;

  @override
  void initState() {
    _duration = widget.duration;
    _selected = _duration![0] ?? _selected;
    _untilDate = widget.startTime ?? _untilDate;

    if (_selected == 1) {
      _untilDate = _duration![1]['untilDate'] ?? _untilDate;
    }
    if (_selected == 2) {
      _forXDays = _duration![1]['forXDays'] ?? _forXDays;
    }
    super.initState();
  }

  void _setDuration() {
    List<dynamic> duration = [];
    if (_selected == 0) {
      duration = [0];
    }
    if (_selected == 1) {
      duration = [
        1,
        {'untilDate': _untilDate}
      ];
    }
    if (_selected == 2) {
      duration = [
        2,
        {'forXDays': _forXDays}
      ];
    }
    Navigator.pop(context, duration);
  }

  void getDatetime() async {
    DateTime? datetime = await showDatePicker(
          context: context,
          initialDate: _untilDate,
          firstDate: widget.startTime ?? DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 1000)),
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
        _untilDate;
    setState(() {
      _untilDate = datetime;
    });
  }

  Widget untilDate() {
    return ListTile(
      title: Text('Until'),
      subtitle: Text(Helpers.dateTimeFormat(_untilDate, "yMMMd")),
      onTap: getDatetime,
    );
  }

  Widget forXDays() {
    return ListTile(
      title: Text('Duration'),
      subtitle: Text('$_forXDays'),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return NumberSelector(
              currentValue: _forXDays,
              minValue: 1,
              maxValue: 500,
              onChanged: (value) {
                setState(() {
                  _forXDays = value;
                });
              },
            );
          },
        );
      },
    );
  }

  Widget showDurationDetails(int selected) {
    Widget widget = Container();
    if (selected == 1) {
      widget = untilDate();
    }
    if (selected == 2) {
      widget = forXDays();
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Duration'),
        actions: [
          TextButton.icon(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white)),
            onPressed: _setDuration,
            icon: const Icon(Icons.done),
            label: const Text(''),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          RadioListTile<int>(
            title: const Text('No end Date'),
            value: 0,
            groupValue: _selected,
            activeColor: Colors.orange,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
          ),
          RadioListTile<int>(
            title: const Text('Until Date'),
            value: 1,
            groupValue: _selected,
            activeColor: Colors.orange,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
          ),
          RadioListTile<int>(
            title: const Text('For X Days'),
            value: 2,
            groupValue: _selected,
            activeColor: Colors.orange,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
          ),
          const Divider(height: 2, color: Colors.grey),
          showDurationDetails(_selected),
        ],
      ),
    );
  }
}
