import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './theme.dart';
import './pages/home.dart';
import './pages/add_schedule.dart';
import './pages/detail_schedule.dart';
import './providers/schedule.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScheduleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      debugShowCheckedModeBanner: false,
      theme: globalTheme,
      home: const HomePage(),
      routes: {
        AddSchedule.routeName: (context) => const AddSchedule(),
        ScheduleDetail.routeName: (context) => const ScheduleDetail(),
      },
    );
  }
}
