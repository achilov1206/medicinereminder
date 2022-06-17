import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static String formatTime(TimeOfDay time, {bool isShort = false}) {
    int hour = time.hour;
    int minute = time.minute;
    String amPm = 'AM';
    String divider = ':';

    if (hour >= 13) {
      amPm = 'PM';
      hour = hour - 12;
    }
    String h = hour.toString(), m = minute.toString();
    if (hour < 10) {
      if (isShort == true) {
        h = '$hour';
      } else {
        h = '0$hour';
      }
    }
    if (minute < 10) {
      m = '0$minute';
    }
    if (isShort == true && minute == 0) {
      m = '';
      divider = '';
    }
    if (isShort == true) {
      amPm = amPm.toLowerCase();
    }

    return '$h$divider$m $amPm';
  }

  static List<TimeOfDay> timeGenerator() {
    List<TimeOfDay> timeList = [];
    for (int i = 7; i <= 24; i++) {
      timeList.add(TimeOfDay(hour: i, minute: 00));
    }
    for (int i = 1; i <= 6; i++) {
      timeList.add(TimeOfDay(hour: i, minute: 00));
    }
    return timeList;
  }

  static String dateTimeFormat(DateTime datetime, String format) =>
      DateFormat(format).format(datetime);

  static String intakeDaysAsString(List<dynamic> intakeDays) {
    String intakeDaysStr = '';
    if (intakeDays[0] == 0) {
      intakeDaysStr = 'Every day';
    }
    if (intakeDays[0] == 1) {
      intakeDaysStr = 'Every ${intakeDays[1]['everyXdays']} days';
    }
    if (intakeDays[0] == 2) {
      Map<dynamic, dynamic> daysOfWeek = intakeDays[1];
      List weekDaysList = [];
      daysOfWeek.forEach((key, value) {
        if (value == true) {
          weekDaysList.add(weekDays[int.parse(key)]?[1]);
        }
      });
      intakeDaysStr = weekDaysList.join(', ');
    }
    if (intakeDays[0] == 3) {
      intakeDaysStr =
          '${intakeDays[1]['daysActive']} days active, ${intakeDays[1]['daysInactive']} days inactive';
    }

    return intakeDaysStr;
  }

  static const Map<int, List> weekDays = {
    1: ['Monday', 'Mon'],
    2: ['Tuesday', 'Tue'],
    3: ['Wednesday', 'Wed'],
    4: ['Thursday', 'Thu'],
    5: ['Friday', 'Fri'],
    6: ['Saturday', 'Sat'],
    7: ['Sunday', 'Sun'],
  };

  static const List<String> medicineUnitTypes = [
    'tablet',
    'capsule',
    'drops',
    'cream',
    'liquid',
    'powder',
    'spray',
    'ampoule',
    'gram',
    'injection',
    'milligram',
    'milliletr',
    'piece',
    'pill',
    'unit',
    'tablespoon',
    'teaspoon',
    'gel',
  ];
}
