import 'package:flutter/material.dart';

import '../widgets/date_selector.dart';
import './add_schedule.dart';
import '../widgets/schedule_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Medecine Reminder',
          style: TextStyle(
            fontFamily: 'Merriweather',
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: orientation == Orientation.portrait
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Medicine',
                                style: TextStyle(
                                  letterSpacing: 3,
                                  color: Colors.black,
                                  fontFamily: 'Merriweather',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Reminder',
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 3,
                                  fontFamily: 'Merriweather',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 200,
                            height: 150,
                            child: Image.asset('assets/images/drug_photo.jpg'),
                          ),
                        ],
                      )
                    ],
                  )
                : const SizedBox(
                    height: 5,
                  ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: DateSelector(),
          ),
          const ScheduleList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add_task,
          size: 30,
        ),
        onPressed: () => Navigator.of(context).pushNamed(AddSchedule.routeName),
      ),
    );
  }
}
