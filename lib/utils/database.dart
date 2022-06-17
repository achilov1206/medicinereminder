import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

import '../helpers/helpers.dart';
import '../models/schedule.dart';

class DB {
  //Datebase filename
  static const dataBaseName = 'medicinereminder.db';
  //Database version
  static const dataBaseVersion = 1;

  //Singleton
  static final DB _dbHelper = DB._internal();

  //Factory constructor
  DB._internal();
  factory DB() {
    return _dbHelper;
  }
  //Database entry point
  static Database? _db;
  Future<Database> get db async {
    _db ??= await initializeDb();
    return _db!;
  }

  //Initialize the database
  Future<Database> initializeDb() async {
    Directory d = await getApplicationDocumentsDirectory();
    String p = d.path + dataBaseName;

    var db =
        await openDatabase(p, version: dataBaseVersion, onCreate: _createDB);
    return db;
  }

  //SQL to create the database
  Future _createDB(Database db, int version) async {
    String initDate = Helpers.dateTimeFormat(DateTime.now(), 'yyyy-MM-dd');
    await db.execute('''
CREATE TABLE $scheduleTableName (
${ScheduleFields.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
${ScheduleFields.medicineName} TEXT NOT NULL,
${ScheduleFields.medicineUnitType} TEXT NOT NULL,
${ScheduleFields.dosageAtOnce} DOUBLE NOT NULL,
${ScheduleFields.timesPerDay} DOUBLE NOT NULL,
${ScheduleFields.medicineTakingTimes} TEXT NOT NULL,
${ScheduleFields.startTime} TEXT NOT NULL,
${ScheduleFields.intakeDays} TEXT NOT NULL,
${ScheduleFields.duration} TEXT NOT NULL,
${ScheduleFields.alarm} INTEGER NOT NULL)''');

    await db.execute('''
CREATE TABLE initDate (
firstDate TEXT NOT NULL)''');

    db.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO initDate(firstDate) VALUES(?)',
        [initDate],
      );
    });
  }

  Future<String> getInitDate() async {
    Database db = await this.db;
    dynamic result;
    try {
      result = await db.query('initDate');
    } catch (e) {
      debugPrint('Det init Date' + e.toString());
    }
    return result!.first['firstDate'];
  }

  // Inser new schedule
  Future<int> insertSchedule(Schedule schedule) async {
    var result;
    Database db = await this.db;
    try {
      result = await db.insert(scheduleTableName, schedule.toJson());
    } catch (e) {
      debugPrint('Insert new Schedule' + e.toString());
    }
    return result;
  }

  //Get all schedules from DB
  Future<List> getSchedules() async {
    Database db = await this.db;
    var result = await db.query(
      scheduleTableName,
      columns: ScheduleFields.columns,
      orderBy: '${ScheduleFields.id} DESC',
    );
    return result.map((e) => Schedule.fromJson(e)).toList();
    //return result;
  }

  //Get one schedule by ID from DB
  Future<Schedule> getSchedule(int id) async {
    Database db = await this.db;
    var result = await db.query(
      scheduleTableName,
      columns: ScheduleFields.columns,
      where: '${ScheduleFields.id} = ?',
      whereArgs: [id],
    );
    return Schedule.fromJson(result[0]);
  }

  //Delete schedule by id
  Future<int> deleteSchedule(int id) async {
    var db = await this.db;
    int r = await db.delete(
      scheduleTableName,
      where: '${ScheduleFields.id} = ?',
      whereArgs: [id],
    );
    return r;
  }

  //Update schedule
  Future<int> updateSchedule(Schedule schedule) async {
    var db = await this.db;
    var r = await db.update(
      scheduleTableName,
      schedule.toJson(),
      where: "${ScheduleFields.id} = ?",
      whereArgs: [schedule.id],
    );

    return r;
  }

  //Close DB connection
  Future close() async {
    var db = await this.db;
    db.close();
  }
}
