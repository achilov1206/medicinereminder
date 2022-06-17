import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/schedule.dart';
import '../helpers/helpers.dart';
import '../models/schedule.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_switch.dart';
import '../widgets/dosage_selector.dart';
import '../widgets/add_schedule/times_per_day_section.dart';
import '../widgets/add_schedule/start_time_section.dart';
import '../widgets/add_schedule/intake_days_section.dart';
import '../widgets/add_schedule/duration_section.dart';
import '../widgets/buttons.dart';

class AddSchedule extends StatefulWidget {
  static const routeName = '/add-schedule';

  const AddSchedule({Key? key}) : super(key: key);

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final _form = GlobalKey<FormState>();

  Schedule? _mySchedule;
  var _isInit = true;
  var _edit = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      dynamic scheduleId = ModalRoute.of(context)!.settings.arguments;
      if (scheduleId != null) {
        _edit = true;
        Provider.of<ScheduleProvider>(context, listen: false)
            .getSchedule(scheduleId)
            .then(
          (value) {
            setState(() {
              _mySchedule = value;
            });
          },
        );
      } else {
        _mySchedule = Schedule.withInitialValues();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('Builded');
    print(_mySchedule);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: _edit
            ? Text(
                _mySchedule!.medicineName!,
                style: const TextStyle(
                  fontFamily: 'Merriweather',
                ),
              )
            : const Text(
                'Add new Schedule',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                ),
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Medicine name Section
              TextFormField(
                cursorColor: Colors.orange,
                initialValue: _mySchedule!.medicineName!,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Medicine name',
                  floatingLabelStyle: TextStyle(color: Colors.orange),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter medicine name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _mySchedule!.medicineName = value;
                },
              ),
              //end of Medicine name Section

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                  child: Column(
                    children: [
                      //medicineUnitType section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Unit',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomDropdown(
                            itemsList: Helpers.medicineUnitTypes,
                            defaultValue: _mySchedule!.medicineUnitType!,
                            dropdownHint: 'Select Required Option',
                            onValueChanged: (value) {
                              _mySchedule!.medicineUnitType = value;
                            },
                          ),
                        ],
                      ),
                      // End of medicineUnitType section
                      const SizedBox(height: 5),
                      // dosageAtOnce section
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
                                  text: 'Dosage ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(text: '(at once)')
                              ],
                            ),
                          ),
                          DosageSelector(
                            defaultValue: _mySchedule!.dosageAtOnce!,
                            step: 0.25,
                            minValue: 0.25,
                            onChanged: (value) {
                              _mySchedule!.dosageAtOnce = value;
                            },
                          ),
                        ],
                      ),
                      // End of dosageAtOnce section
                      const SizedBox(height: 15),
                      // timesPerDay section
                      TimesPerDay(mySchedule: _mySchedule),
                      // End of timesPerDay section
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Column(
                    children: [
                      //startTime section
                      StartTimeSection(
                        startTime: _mySchedule!.startDate!,
                        onStartTimeChanged: (value) {
                          setState(() {
                            _mySchedule!.startDate = value;
                          });
                        },
                        edit: _edit,
                      ),
                      //End of startTime section
                      const SizedBox(height: 10),
                      //intakeDays section
                      IntakeDaysSection(
                        intakeDays: _mySchedule!.intakeDays!,
                        onChange: (value) {
                          _mySchedule!.intakeDays = value;
                        },
                      ),
                      //end of intakeDays section
                      const SizedBox(height: 10),
                      //duration section
                      DurationSection(
                        duration: _mySchedule!.duration!,
                        startTime: _mySchedule!.startDate!,
                        onChange: (value) {
                          _mySchedule!.duration = value;
                        },
                      ),
                      //end of duration section
                      const SizedBox(height: 10),
                      //alarm section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Alarm',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomSwitch(
                            defaultValue: _mySchedule!.alarm!,
                            onChanged: (value) {
                              _mySchedule!.alarm = value;
                            },
                          ),
                        ],
                      ),
                      //End of alarm section
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SubmitButton(
                    text: _edit == true ? 'Edit' : 'Add Schedule',
                    minSize: const Size(150, 40),
                    onpressed: () {
                      if (_form.currentState!.validate()) {
                        String message = '';
                        _form.currentState!.save();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        if (_edit == true) {
                          Provider.of<ScheduleProvider>(context, listen: false)
                              .updateSchedule(_mySchedule!)
                              .then((value) {
                            if (value == 0) {
                              message = 'Schedule not updated, smth went wrong';
                            } else {
                              message = 'Schedule updated';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          });
                        } else {
                          Provider.of<ScheduleProvider>(context, listen: false)
                              .insertSchedule(_mySchedule!)
                              .then((value) {
                            if (value == 0) {
                              message = 'Schedule not added, smth went wrong';
                            } else {
                              message = 'New Schedule added';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          });
                        }

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  SubmitButton(
                    text: 'Cancel',
                    minSize: const Size(150, 40),
                    color: Colors.redAccent,
                    onpressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
