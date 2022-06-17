import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:provider/provider.dart';
import '../providers/schedule.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({Key? key}) : super(key: key);

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime _selectedValue = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<ScheduleProvider>(context, listen: false).getInitDate(),
        builder: (ctx, snapshot) {
          var initDate = snapshot.data;
          if (snapshot.hasData) {
            return DatePicker(
              initDate as DateTime,
              initialSelectedDate: _selectedValue,
              selectionColor: Theme.of(context).colorScheme.primary,
              selectedTextColor: Colors.white,
              width: 60,
              onDateChange: (date) {
                setState(() {
                  _selectedValue = date;
                });
                Provider.of<ScheduleProvider>(context, listen: false)
                    .changeSelectedFilterDate(date);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
