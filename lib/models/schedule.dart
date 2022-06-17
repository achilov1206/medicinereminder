import 'dart:convert';
import 'package:flutter/material.dart';
import '../helpers/helpers.dart';

//Name for DataBase Table
const String scheduleTableName = 'schedule';

// Field Names for DataBase table
class ScheduleFields {
  static const List<String> columns = [
    id,
    medicineName,
    medicineUnitType,
    dosageAtOnce,
    timesPerDay,
    medicineTakingTimes,
    startTime,
    intakeDays,
    duration,
    alarm,
  ];

  static const String id = '_id';
  static const String medicineName = 'medicine_name';
  static const String medicineUnitType = 'medicine_unit_type';
  static const String dosageAtOnce = 'dosage_at_once';
  static const String timesPerDay = 'times_per_day';
  static const String medicineTakingTimes = 'medicine_taking_times';
  static const String startTime = 'start_time';
  static const String intakeDays = 'intake_days';
  static const String duration = 'duration';
  static const String alarm = 'alarm';
}

class Schedule {
  final int? id;
  //name of medicine
  String? medicineName;

  //type of medicine
  String? medicineUnitType;
  //dosage at one intake
  double? dosageAtOnce;

  //intake time per day
  double? timesPerDay;

  //time of each medicine during one day [{h:1, m:10}, {h:2, m:12}...]
  List<dynamic>? medicineTakingTimes;

  //medicine intake start time
  DateTime? startDate;

  //Intake days can be [0,1,2,3];
  // 0 = [0] Every day
  // 1 = [1, {everyXdays: ...}] Every X day
  // 2 = [2,{monday: true, .....}] Selected days of week
  // 3 = [3, {daysActive: ..., daysInactive: ...}] X days Active Y days Inactive
  List<dynamic>? intakeDays;

  //Duration can be [0,1,2];
  //0 = [0] Every day
  //1 = [1, {untilDate: ...}] until specified date
  //2 = [2, {forXDays: ...}] for X days
  List<dynamic>? duration;

  String durationEncode() {
    if (duration![0] == 1) {
      List<dynamic> localDuration = [
        1,
        {'untilDate': duration![1]['untilDate'].toString()}
      ];
      return jsonEncode(localDuration);
    }
    return jsonEncode(duration);
  }

  // Is alarm active or not;
  bool? alarm;

  List<TimeOfDay> intakeTimes = Helpers.timeGenerator();

  Schedule({
    this.id,
    this.medicineName,
    this.medicineUnitType,
    this.timesPerDay,
    this.dosageAtOnce,
    this.medicineTakingTimes,
    this.startDate,
    this.intakeDays,
    this.duration,
    this.alarm = true,
  });
  Schedule.withInitialValues({this.id}) {
    medicineName = '';
    medicineUnitType = Helpers.medicineUnitTypes[0];
    timesPerDay = 1.0;
    dosageAtOnce = 1.0;
    medicineTakingTimes = [
      {'hour': intakeTimes[0].hour, 'minute': intakeTimes[0].minute}
    ];
    startDate = DateTime.now();
    intakeDays = [0];
    duration = [0];
    alarm = true;
  }

  int get totalDays {
    //If duration is until some date
    if (duration![0] == 1) {
      return duration![1]['untilDate'].difference(startDate).inDays;
    }
    //If duration is for x days
    if (duration![0] == 2) {
      return duration![1]['forXDays'];
    }
    // if duration is everyDay return -1
    return -1;
  }

  DateTime get endDate {
    DateTime startTimeTemp = startDate!;
    return startTimeTemp.add(Duration(days: totalDays));
  }

  int get leftDays {
    if (totalDays == -1) {
      return -1;
    }
    return startDate!.difference(endDate).inDays;
  }

  //Calculate total medicine quantity
  // double get totalMedicineQuantity {
  //   double dosagePerDay = dosageAtOnce! * timesPerDay!;
  //   double totatQuantity = 0;
  //   if (timesPerDay! > 1) {}
  //   if (intakeDays![0] == 0) {
  //     //Every day
  //     totatQuantity = dosagePerDay * totalDays;
  //   } else if (intakeDays![0] == 1) {
  //     //[1, {everyXdays: ...}] Every X day
  //     totatQuantity =
  //         (totalDays ~/ intakeDays![1]['everyXdays']) * dosagePerDay;
  //   } else if (intakeDays![0] == 2) {
  //     //[2,{monday: true, .....}] Selected days of week

  //   } else if (intakeDays![0] == 3) {
  //     //[3, {daysActive: ..., daysInactive: ...}] X days Active Y days Inactive
  //     int daysActive = int.parse(intakeDays![1]['daysActive']);
  //     int _daysActive = 0;
  //     int daysInactive = int.parse(intakeDays![1]['daysInactive']);
  //     int _daysInactive = 0;
  //     int quantity;
  //     for (int i = 1; i <= totalDays; i++) {
  //       // if (daysActive != _daysActive && _daysInactive == 0) {
  //       //   _daysActive += 1;
  //       // } else {
  //       //   _daysActive = 0;
  //       // }
  //       // if(daysInactive)
  //     }
  //   }
  //   // 1 2 3 4 5 6 7 8 9 10 11 12 13 14
  //   // | | * * * | | * *  *  |  |  * *   2/3

  //   return totatQuantity;
  // }

  int get leftMedicineQuantity {
    return -1;
  }

  static Schedule fromJson(Map<String, dynamic> map) {
    List<dynamic> durationDecode(String str) {
      List<dynamic> decoded = jsonDecode(str);
      if (decoded[0] == 1) {
        List<dynamic> localDecoded = [
          1,
          {'untilDate': DateTime.parse(decoded[1]['untilDate'])}
        ];
        return localDecoded;
      }
      return decoded;
    }

    return Schedule(
      id: map[ScheduleFields.id] as int,
      medicineName: map[ScheduleFields.medicineName] as String,
      medicineUnitType: map[ScheduleFields.medicineUnitType] as String,
      timesPerDay: map[ScheduleFields.timesPerDay] as double,
      dosageAtOnce: map[ScheduleFields.dosageAtOnce] as double,
      medicineTakingTimes: jsonDecode(map[ScheduleFields.medicineTakingTimes]!),
      startDate: DateTime.parse(map[ScheduleFields.startTime]!),
      intakeDays: jsonDecode(map[ScheduleFields.intakeDays]!) as List,
      duration: durationDecode(map[ScheduleFields.duration]!),
      alarm: map[ScheduleFields.alarm] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() => {
        ScheduleFields.id: id,
        ScheduleFields.medicineName: medicineName,
        ScheduleFields.medicineUnitType: medicineUnitType,
        ScheduleFields.timesPerDay: timesPerDay,
        ScheduleFields.dosageAtOnce: dosageAtOnce,
        ScheduleFields.medicineTakingTimes: jsonEncode(medicineTakingTimes),
        ScheduleFields.startTime:
            Helpers.dateTimeFormat(startDate!, 'yyyy-MM-dd'),
        ScheduleFields.intakeDays: jsonEncode(intakeDays),
        ScheduleFields.duration: durationEncode(),
        ScheduleFields.alarm: alarm == true ? 1 : 0,
      };

  void updateTakingTimesList(TimeOfDay oldTime, TimeOfDay newTime) {
    int index = -1;
    for (int i = 0; i < medicineTakingTimes!.length; i++) {
      int hour = oldTime.hour;
      int minute = oldTime.minute;
      if (medicineTakingTimes![i]['hour'] == hour &&
          medicineTakingTimes![i]['minute'] == minute) {
        index = i;
        break;
      }
    }

    //int index = scheduleModel.medicineTakingTimes!.indexOf(oldTime);
    medicineTakingTimes!.removeAt(index);
    medicineTakingTimes!.insert(index, {
      'hour': newTime.hour,
      'minute': newTime.minute,
    });
  }

  void setTakingTimes(double timesPerDay) {
    List<Map<String, int>> intakeTimesLocal = [];

    int t = intakeTimes.length ~/ timesPerDay;
    for (int i = 0; i < timesPerDay; i++) {
      intakeTimesLocal.add({
        'hour': intakeTimes[i * t].hour,
        'minute': intakeTimes[i * t].minute,
      });
    }
    medicineTakingTimes = intakeTimesLocal;
  }
}
