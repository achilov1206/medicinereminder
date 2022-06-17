import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../helpers/helpers.dart';
import '../dosage_selector.dart';

class TimesPerDay extends StatefulWidget {
  final Schedule? mySchedule;
  const TimesPerDay({Key? key, this.mySchedule}) : super(key: key);

  @override
  State<TimesPerDay> createState() => _TimesPerDayState();
}

class _TimesPerDayState extends State<TimesPerDay> {
  void onTimeChange(TimeOfDay time) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: time.hour, minute: time.minute),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    setState(() {
      widget.mySchedule!.updateTakingTimesList(time, newTime!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: 'Times ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(text: '(per day)')
                ],
              ),
            ),
            DosageSelector(
              defaultValue: widget.mySchedule!.timesPerDay ?? 1,
              step: 1,
              minValue: 1,
              maxDosage: 24,
              onChanged: (value) {
                widget.mySchedule!.timesPerDay = value;
                setState(() {
                  widget.mySchedule!.setTakingTimes(value);
                });
              },
            ),
          ],
        ),
        // End of timesPerDay section
        const SizedBox(height: 15),
        //medicineTakingTimes section
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: widget.mySchedule!.medicineTakingTimes!.map((timeObj) {
            return GestureDetector(
              onTap: () => onTimeChange(
                TimeOfDay(
                  hour: timeObj['hour']!,
                  minute: timeObj['minute'],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.watch_later_outlined,
                      size: 14,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      Helpers.formatTime(TimeOfDay(
                          hour: timeObj['hour']!, minute: timeObj['minute']!)),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        //End of medicineTakingTimes section
      ],
    );
  }
}
