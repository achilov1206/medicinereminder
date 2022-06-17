import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/schedule.dart';
import './task_card.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: Provider.of<ScheduleProvider>(context).getSchedules(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.error != null || snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            } else {
              if (snapshot.data.length < 1) {
                return const Center(
                  child: Text('Uuups! '),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskCard(
                    medicineName: snapshot.data[index].medicineName,
                    scheduleId: snapshot.data[index].id,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
