import 'package:flutter/material.dart';
import '../../helpers/helpers.dart';
import '../duration_selector.dart';
import '../buttons.dart';

class DurationSection extends StatefulWidget {
  final List<dynamic>? duration;
  final DateTime? startTime;
  final Function? onChange;
  const DurationSection(
      {Key? key, this.duration, this.startTime, this.onChange})
      : super(key: key);

  @override
  State<DurationSection> createState() => _DurationSectionState();
}

class _DurationSectionState extends State<DurationSection> {
  List<dynamic>? _duration;

  @override
  void initState() {
    _duration = widget.duration;
    super.initState();
  }

  Widget showDuration() {
    Widget duration = const Text('');
    if (_duration![0] == 0) {
      duration = const Text('No end Date');
    }
    if (_duration![0] == 1) {
      duration = Text(
          'Until: ${Helpers.dateTimeFormat(_duration![1]['untilDate'], "yMMMd")}');
    }
    if (_duration![0] == 2) {
      duration = Text('For ${_duration![1]['forXDays']} day(s)');
    }

    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Duration',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            OrangeTextButton(
              label: 'Select duration',
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DurationSelector(
                      duration: _duration,
                      startTime: widget.startTime,
                    ),
                    fullscreenDialog: true,
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      widget.onChange!(value);
                      _duration = value;
                    });
                  }
                });
              },
            ),
          ],
        ),
        showDuration(),
      ],
    );
  }
}
