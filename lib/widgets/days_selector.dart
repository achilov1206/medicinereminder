import 'package:flutter/material.dart';
import '../helpers/helpers.dart';
import '../widgets/number_selector.dart';

class DaysSelector extends StatefulWidget {
  final List<dynamic>? medicineIntakeDays;
  const DaysSelector({Key? key, this.medicineIntakeDays}) : super(key: key);

  @override
  _DaysSelectorState createState() => _DaysSelectorState();
}

class _DaysSelectorState extends State<DaysSelector> {
  int? _selected;
  Map<String, dynamic> _weekDays = {};
  int _everyXdays = 2;
  int _daysActive = 7;
  int _daysInactive = 1;

  @override
  void initState() {
    _selected = widget.medicineIntakeDays![0] ?? _selected;
    Helpers.weekDays.forEach((key, value) {
      _weekDays.addAll({key.toString(): true});
    });
    if (_selected == 1) {
      _everyXdays = widget.medicineIntakeDays![1]['everyXdays'] ?? _everyXdays;
    }
    if (_selected == 2) {
      _weekDays = widget.medicineIntakeDays![1] ?? _weekDays;
    }
    if (_selected == 3) {
      _daysActive = widget.medicineIntakeDays![1]['daysActive'] ?? _daysActive;
      _daysInactive =
          widget.medicineIntakeDays![1]['daysInactive'] ?? _daysInactive;
    }
    super.initState();
  }

  void _setIntakeDays() {
    List<dynamic>? intakeDays = [];
    if (_selected == 0) {
      intakeDays = [0];
    }
    if (_selected == 1) {
      intakeDays = [
        1,
        {'everyXdays': _everyXdays}
      ];
    }
    if (_selected == 2) {
      intakeDays = [2, _weekDays];
    }
    if (_selected == 3) {
      intakeDays = [
        3,
        {'daysActive': _daysActive, 'daysInactive': _daysInactive}
      ];
    }
    //widget.onSetIntakeDays!(intakeDays);
    Navigator.pop(context, intakeDays);
  }

  Widget everyXDays() {
    return ListTile(
      title: Text('Every'),
      subtitle: Text('$_everyXdays days'),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return NumberSelector(
              currentValue: _everyXdays,
              minValue: 1,
              maxValue: 300,
              onChanged: (value) {
                setState(() {
                  _everyXdays = value;
                });
              },
            );
          },
        );
      },
    );
  }

  Widget specificDaysOfWeek() {
    Color getColor(Set<MaterialState> states) {
      // const Set<MaterialState> interactiveStates = <MaterialState>{
      //   MaterialState.pressed,
      //   MaterialState.hovered,
      //   MaterialState.focused,
      // };
      return Colors.orange;
    }

    List<Widget> widget = [];
    _weekDays.forEach(
      (k, v) => {
        widget.add(
          ListTile(
            leading: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: v,
              onChanged: (bool? value) {
                setState(() {
                  _weekDays[k] = value!;
                });
              },
            ),
            title: Text(Helpers.weekDays[int.parse(k)]?[0]),
            onTap: () {
              setState(() {
                _weekDays[k] == true
                    ? _weekDays[k] = false
                    : _weekDays[k] = true;
              });
            },
          ),
        ),
      },
    );
    return Wrap(
      children: widget,
    );
  }

  Widget cycle() {
    return Wrap(
      children: [
        ListTile(
          title: Text('Days active'),
          subtitle: Text('$_daysActive'),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NumberSelector(
                    currentValue: _daysActive,
                    minValue: 1,
                    maxValue: 500,
                    onChanged: (value) {
                      setState(() {
                        _daysActive = value;
                      });
                    },
                  );
                });
          },
        ),
        ListTile(
          title: Text('Days inactive'),
          subtitle: Text('$_daysInactive'),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NumberSelector(
                    currentValue: _daysInactive,
                    minValue: 1,
                    maxValue: 500,
                    onChanged: (value) {
                      setState(() {
                        _daysInactive = value;
                      });
                    },
                  );
                });
          },
        ),
      ],
    );
  }

  Widget showDaySelectDetails(int value) {
    Widget widget = Container();
    if (value == 1) {
      widget = everyXDays();
    }
    if (value == 2) {
      widget = specificDaysOfWeek();
    }
    if (value == 3) {
      widget = cycle();
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Intake days'),
        actions: [
          TextButton.icon(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white)),
            onPressed: _setIntakeDays,
            icon: Icon(Icons.done),
            label: Text(''),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          RadioListTile<int>(
            title: const Text('Every Day'),
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
            title: const Text('Every X Days'),
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
            title: const Text('Specific days of week'),
            value: 2,
            groupValue: _selected,
            activeColor: Colors.orange,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
          ),
          RadioListTile<int>(
            title: const Text('X days active, Y days inactive'),
            value: 3,
            groupValue: _selected,
            activeColor: Colors.orange,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
          ),
          const Divider(height: 2, color: Colors.grey),
          showDaySelectDetails(_selected!),
        ],
      ),
    );
  }
}
