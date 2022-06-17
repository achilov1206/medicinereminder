import 'package:flutter/material.dart';
import '../pages/detail_schedule.dart';

class TaskCard extends StatelessWidget {
  final String? medicineName;
  final int? scheduleId;
  const TaskCard({
    Key? key,
    @required this.medicineName,
    @required this.scheduleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(
          Icons.medication_sharp,
          color: Colors.amber,
          size: 40,
        ),
        title: Text(
          medicineName!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          '09:00 AM',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30,
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(ScheduleDetail.routeName, arguments: scheduleId!);
        },
      ),
    );
  }
}
