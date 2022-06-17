import 'package:flutter/material.dart';
import 'package:medicinereminder2/helpers/helpers.dart';

import '../utils/database.dart';
import '../models/schedule.dart';

class ScheduleProvider with ChangeNotifier {
  final _dbh = DB();
  //DateTime? filterDate;
  DateTime selectedFilterDate = DateTime.now();

  Future<List> getSchedules() async {
    return _dbh.getSchedules();
  }

  Future<List> getSchedulesByDate() async {
    String date = Helpers.dateTimeFormat(selectedFilterDate, 'yyyy-MM-dd');
    return <Future>[];
  }

  Future<Schedule> getSchedule(int id) {
    return _dbh.getSchedule(id);
  }

  Future<int> insertSchedule(Schedule schedule) async {
    var result = _dbh.insertSchedule(schedule);
    notifyListeners();
    return result;
  }

  Future<int> deleteSchedule(int id) async {
    var count = _dbh.deleteSchedule(id);
    notifyListeners();
    return count;
  }

  Future<int> updateSchedule(Schedule schedule) async {
    var count = _dbh.updateSchedule(schedule);
    notifyListeners();
    return count;
  }

  void changeSelectedFilterDate(DateTime newDate) {
    selectedFilterDate = newDate;
    notifyListeners();
  }

  Future<DateTime> getInitDate() async {
    return await _dbh.getInitDate().then((value) {
      return DateTime.parse(value);
    });
  }
}
