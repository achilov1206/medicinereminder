import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../days_selector.dart';
import '../buttons.dart';

class IntakeDaysSection extends StatefulWidget {
  final List<dynamic>? intakeDays;
  final Function? onChange;
  const IntakeDaysSection({Key? key, this.intakeDays, this.onChange})
      : super(key: key);

  @override
  State<IntakeDaysSection> createState() => _IntakeDaysSectionState();
}

class _IntakeDaysSectionState extends State<IntakeDaysSection> {
  List<dynamic>? _intakeDays;

  @override
  void initState() {
    _intakeDays = widget.intakeDays;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Days',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            OrangeTextButton(
              label: 'Select days',
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext ctx) => DaysSelector(
                      medicineIntakeDays: _intakeDays,
                    ),
                    fullscreenDialog: true,
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      widget.onChange!(value);
                      _intakeDays = value;
                    });
                  }
                });
              },
            ),
          ],
        ),
        Text(Helpers.intakeDaysAsString(_intakeDays!)),
      ],
    );
  }
}
