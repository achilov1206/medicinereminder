import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/schedule.dart';
import '../providers/schedule.dart';
import '../pages/add_schedule.dart';
import '../widgets/buttons.dart';
import '../helpers/helpers.dart';

class ScheduleDetail extends StatelessWidget {
  static const routeName = '/schedule-detail';
  const ScheduleDetail({Key? key}) : super(key: key);

  Widget timeWidget(TimeOfDay timeOfDay) {
    String tof = Helpers.formatTime(timeOfDay, isShort: true);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tof,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _scheduleId = ModalRoute.of(context)!.settings.arguments as int;
    final _scheduleFuture =
        Provider.of<ScheduleProvider>(context).getSchedule(_scheduleId);
    return FutureBuilder(
      future: _scheduleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.error != null || snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
            body: const Center(
              child: Text(
                'Smth went wrong, please reload text',
                softWrap: true,
              ),
            ),
          );
        } else {
          Schedule _schedule = snapshot.data as Schedule;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(_schedule.medicineName!),
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 0,
                      child: Text('Change Schedule'),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Delete Schedule'),
                    )
                  ],
                  onSelected: (item) {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dosage',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '${_schedule.timesPerDay!.toInt()} time${_schedule.timesPerDay!.toInt() > 1 ? 's' : ''} by ${_schedule.dosageAtOnce!} ${_schedule.medicineUnitType}: ',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Wrap(
                            runSpacing: 5,
                            children: _schedule.medicineTakingTimes!
                                .map(
                                  (e) => timeWidget(
                                    TimeOfDay(
                                        hour: e['hour'], minute: e['minute']),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Program',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Started date: ${Helpers.dateTimeFormat(_schedule.startDate!, 'yMMMd')}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'End Date: ${_schedule.totalDays == -1 ? 'No end Date' : Helpers.dateTimeFormat(_schedule.endDate, 'yMMMd')}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const Divider(
                            height: 10,
                            thickness: 2,
                            color: Colors.green,
                          ),
                          Text(
                            _schedule.totalDays == -1
                                ? ""
                                : "Total ${_schedule.totalDays.abs()} days: ${_schedule.leftDays.abs()} days left",
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            'Frequency of Intake: ${Helpers.intakeDaysAsString(_schedule.intakeDays!)}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          // const Text(
                          //   'Quantity',
                          //   style: TextStyle(
                          //     fontSize: 17,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          // Text(
                          //   'Total 168 tablet: 126 tablet left',
                          //   style: const TextStyle(fontSize: 15),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SubmitButton(
                        text: 'Edit',
                        minSize: const Size(80, 40),
                        onpressed: () => Navigator.pushNamed(
                          context,
                          AddSchedule.routeName,
                          arguments: _scheduleId,
                        ),
                      ),
                      SubmitButton(
                        text: 'Delete',
                        minSize: const Size(80, 40),
                        color: Colors.redAccent,
                        onpressed: () {
                          // Cancel button
                          Widget cancelButton = TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          //Submit button
                          Widget continueButton = TextButton(
                            child: const Text("Continue"),
                            onPressed: () {
                              Provider.of<ScheduleProvider>(context,
                                      listen: false)
                                  .deleteSchedule(_schedule.id!);
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                            },
                          );
                          //set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: const Text("Delete"),
                            content: Text(
                              'Would you like to delete - ${_schedule.medicineName!}?',
                            ),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );
                          //show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
