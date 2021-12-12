import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/classes/subject.dart';
import 'package:delta_squad_app/models/subject_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EditSubject extends StatefulWidget {
  const EditSubject({Key? key, required this.subjects, required this.details})
      : super(key: key);

  final List<Subject> subjects;
  final CalendarTapDetails? details;

  @override
  _EditSubjectState createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  late TextEditingController _subjectController;
  late TextEditingController _teacherController;
  late TextEditingController _roomController;
  late TextEditingController _beginTimeController;
  late TextEditingController _endTimeController;
  late bool _showSpecificWeeks;

  WeekDays _weekDay = WeekDays.monday;
  TimeType? _types = TimeType.all;
  DateFormat timeFormat = DateFormat("HH:mm");

  final _formKey = GlobalKey<FormState>();
  final List<bool> _subjectWeekValues = List.generate(15, (index) => false);

  DocumentReference? _subjectReference;

  @override
  void initState() {
    _subjectController = TextEditingController();
    _teacherController = TextEditingController();
    _roomController = TextEditingController();
    _beginTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _showSpecificWeeks = false;

    if (widget.details != null) {
      _beginTimeController.text = timeFormat.format(widget.details!.date!);
      _endTimeController.text = timeFormat
          .format(widget.details!.date!.add(const Duration(hours: 1)));

      switch (widget.details!.date!.weekday) {
        case 1:
          _weekDay = WeekDays.monday;
          break;
        case 2:
          _weekDay = WeekDays.tuesday;
          break;
        case 3:
          _weekDay = WeekDays.wednesday;
          break;
        case 4:
          _weekDay = WeekDays.thursday;
          break;
        case 5:
          _weekDay = WeekDays.friday;
          break;
        case 6:
          _weekDay = WeekDays.saturday;
          break;
        case 7:
          _weekDay = WeekDays.sunday;
          break;
      }
    } else {
      _beginTimeController.text = "08:00";
      _endTimeController.text = "09:00";
    }

    Subject? subject = widget.details?.appointments![0];

    if (subject != null) {
      _subjectController.text = subject.subjectModel!.name!;
      _teacherController.text = subject.subjectModel!.instructor!;
      _roomController.text = subject.subjectModel!.hall!;
      _character = subject.subjectModel!.type;
      _weekDay = subject.subjectModel!.day!;
      _beginTimeController.text =
          timeFormat.format(subject.subjectModel!.beginTime!.toDate());
      _endTimeController.text =
          timeFormat.format(subject.subjectModel!.endTime!.toDate());

      _showSpecificWeeks = true;

      for (int i = 0; i < subject.subjectModel!.weeks!.length; i++) {
        _subjectWeekValues[i] = subject.subjectModel!.weeks![i];
      }

      _subjectReference = subject.reference;
    }

    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    _beginTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  int val = -1;
  SingingCharacter? _character = SingingCharacter.lecture;

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Anuluj"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Usuń",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        _subjectReference!.delete();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Usuwanie przedmiotu"),
      content: Text("Czy na pewno chcesz usunąć ten przedmiot z planu zajęć?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showAlertDialog(context);
              },
              icon: Icon(Icons.delete)),
        ],
        title: Text("Edytuj przedmiot"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _subjectController,
                    textInputAction: TextInputAction.next,
                    validator: (text) =>
                        text!.length > 0 ? null : "Wprowadź nazwę przedmiotu",
                    decoration: InputDecoration(
                        label: const Text("Nazwa przedmiotu"),
                        prefixIcon: Icon(Icons.short_text),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _teacherController,
                    textInputAction: TextInputAction.next,
                    validator: (text) => text!.length > 0
                        ? null
                        : "Wprowadź nazwisko osoby prowadzącej zajęcia",
                    decoration: InputDecoration(
                        label: const Text("Prowadzący"),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _roomController,
                    textInputAction: TextInputAction.next,
                    validator: (text) =>
                        text!.length > 0 ? null : "Wprowadź identyfikator sali",
                    decoration: InputDecoration(
                        label: Text("Sala"),
                        prefixIcon: Icon(Icons.room),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 25,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5,
                  ),
                  RadioListTile(
                      title: Text("Wykład"),
                      value: SingingCharacter.lecture,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.lecture;
                        });
                      }),
                  RadioListTile(
                      title: Text("Ćwiczenia"),
                      value: SingingCharacter.exercise,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.exercise;
                        });
                      }),
                  RadioListTile(
                      title: Text("Laboratorium"),
                      value: SingingCharacter.laboratory,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.laboratory;
                        });
                      }),
                  RadioListTile(
                      title: Text("Seminarium"),
                      value: SingingCharacter.seminary,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.seminary;
                        });
                      }),
                  const Divider(
                    color: Colors.black,
                    height: 25,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Poniedziałek'),
                              value: WeekDays.monday,
                              groupValue: _weekDay,
                              onChanged: (WeekDays? value) {
                                setState(() {
                                  _weekDay = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Wtorek'),
                              value: WeekDays.tuesday,
                              groupValue: _weekDay,
                              onChanged: (WeekDays? value) {
                                setState(() {
                                  _weekDay = value!;
                                });
                              },
                            ),
                          )
                        ],
                      ), //monday,tuesday
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Środa'),
                              value: WeekDays.wednesday,
                              groupValue: _weekDay,
                              onChanged: (WeekDays? value) {
                                setState(() {
                                  _weekDay = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Czwartek'),
                              value: WeekDays.thursday,
                              groupValue: _weekDay,
                              onChanged: (WeekDays? value) {
                                setState(() {
                                  _weekDay = value!;
                                });
                              },
                            ),
                          )
                        ],
                      ), //wednesday,thursday
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Piątek'),
                              value: WeekDays.friday,
                              groupValue: _weekDay,
                              onChanged: (WeekDays? value) {
                                setState(() {
                                  _weekDay = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Sobota'),
                              value: WeekDays.saturday,
                              groupValue: _weekDay,
                              onChanged: (WeekDays? value) {
                                setState(() {
                                  _weekDay = value!;
                                });
                              },
                            ),
                          )
                        ],
                      ), //friday,saturday
                      Row(children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 40) / 2,
                          child: RadioListTile(
                            dense: true,
                            title: const Text('Niedziela'),
                            value: WeekDays.sunday,
                            groupValue: _weekDay,
                            onChanged: (WeekDays? value) {
                              setState(() {
                                _weekDay = value!;
                              });
                            },
                          ),
                        )
                      ]),
                    ],
                  ),
                  //sunday

                  const Divider(
                    color: Colors.black,
                    height: 25,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 160,
                        child: TextFormField(
                          validator: _validateTime,
                          keyboardType: TextInputType.datetime,
                          controller: _beginTimeController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () =>
                                    _selectTime(_beginTimeController),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      SizedBox(
                        width: 160, // TODO: Calculate dynamically
                        child: TextFormField(
                          validator: _validateTime,
                          keyboardType: TextInputType.datetime,
                          controller: _endTimeController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () =>
                                    _selectTime(_endTimeController),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 25,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Container(
                    child: SwitchListTile(
                      title: Text("Wybierz konkretne tygodnie"),
                      value: _showSpecificWeeks,
                      activeColor: Colors.blue,
                      onChanged: (bool value) {
                        setState(() {
                          _showSpecificWeeks = !_showSpecificWeeks;
                        });
                      },
                    ),
                  ),

                  Row(
                    children: [
                      if (_showSpecificWeeks == true)
                        Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCheckBoxes(1, 3, _subjectWeekValues),
                                _buildCheckBoxes(4, 6, _subjectWeekValues),
                                _buildCheckBoxes(7, 9, _subjectWeekValues),
                                _buildCheckBoxes(10, 12, _subjectWeekValues),
                                _buildCheckBoxes(13, 15, _subjectWeekValues),
                              ],
                            )),
                      if (_showSpecificWeeks == false)
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            40) /
                                        3,
                                    child: RadioListTile(
                                      title: const Text('ALL'),
                                      value: TimeType.all,
                                      groupValue: _types,
                                      onChanged: (TimeType? value) {
                                        setState(() {
                                          _types = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            40) /
                                        3,
                                    child: RadioListTile(
                                      title: const Text('X1'),
                                      value: TimeType.x1,
                                      groupValue: _types,
                                      onChanged: (TimeType? value) {
                                        setState(() {
                                          _types = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            40) /
                                        3,
                                    child: RadioListTile(
                                      title: const Text('X2'),
                                      value: TimeType.x2,
                                      groupValue: _types,
                                      onChanged: (TimeType? value) {
                                        setState(() {
                                          _types = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    height: 60,
                    minWidth: double.infinity,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text('Zapisz'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addToDataBase(
                            _subjectController,
                            _teacherController,
                            _roomController,
                            _beginTimeController,
                            _endTimeController,
                            _weekDay,
                            _character,
                            _showSpecificWeeks,
                            _subjectWeekValues,
                            _types);
                        addSubject();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime getNearestDateByDayOfTheWeek(WeekDays day) {
    var now = DateTime.now();

    while (now.weekday % 7 != day.index) {
      now = now.add(const Duration(days: 1));
    }

    return now;
  }

  addSubject() {
    final DateTime now = getNearestDateByDayOfTheWeek(_weekDay);
    DateTime _beginTime = timeFormat.parse(_beginTimeController.text);
    DateTime _endTime = timeFormat.parse(_endTimeController.text);
    DateTime beginTime = DateTime(
        now.year, now.month, now.day, _beginTime.hour, _beginTime.minute);
    DateTime endTime =
        DateTime(now.year, now.month, now.day, _endTime.hour, _endTime.minute);
    Color color;

    switch (_character) {
      case SingingCharacter.lecture:
        color = Colors.orange;
        break;
      case SingingCharacter.exercise:
        color = Colors.teal;
        break;
      case SingingCharacter.laboratory:
        color = Colors.blue;
        break;
      case SingingCharacter.seminary:
        color = Colors.redAccent;
        break;
      default:
        color = Colors.lime;
    }

    // Appointment
    // widget.subjects.add(Subject(
    //     '${_subjectController.text}\n${_teacherController.text}\n${_roomController.text}',
    //     beginTime,
    //     endTime,
    //     color,
    //     false));

    widget.subjects.add(Subject(
      startTime: beginTime,
      endTime: endTime,
      subject:
          '${_subjectController.text}\n\n${_teacherController.text}\n\n${_roomController.text}',
      color: color,
    ));
  }

  void _selectTime(TextEditingController txt) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 7, minute: 15),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (newTime != null) {
      setState(() {
        final now = new DateTime.now();
        var now2 = DateTime(
            now.year, now.month, now.day, newTime.hour, newTime.minute);
        txt.text = timeFormat.format(now2);
      });
    }
  }

  Widget _buildCheckBoxes(int start, int end, List<bool> values) {
    List<Widget> list = [];
    Widget cb;
    Widget ex;

    for (int i = start; i <= end; ++i) {
      cb = CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Text(i.toString()),
          value: values[i - 1],
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (value) {
            setState(() {
              values[i - 1] = !values[i - 1];
            });
          });
      ex = Expanded(
        child: cb,
      );
      list.add(ex);
    }
    //print(list);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: list);
  }

  String? _validateTime(timeString) {
    try {
      timeFormat.parse(timeString);
    } on Exception {
      return "Nieprawidłowy format czsau";
    }

    return null;
  }

  void addToDataBase(
      TextEditingController subjectController,
      TextEditingController teacherController,
      TextEditingController roomController,
      TextEditingController beginTime,
      TextEditingController endTime,
      WeekDays day,
      SingingCharacter? character,
      bool switchValue,
      List<bool> subjectWeekValues,
      TimeType? types) async {
    if (!switchValue) {
      if (types == TimeType.x1) {
        for (int i = 0; i < 15; i++) {
          if (i % 2 == 0) {
            subjectWeekValues[i] = true;
          } else {
            subjectWeekValues[i] = false;
          }
        }
      } else if (types == TimeType.x2) {
        for (int i = 0; i < 15; i++) {
          if (i % 2 == 0) {
            subjectWeekValues[i] = false;
          } else {
            subjectWeekValues[i] = true;
          }
        }
      } else {
        for (int i = 0; i < 15; i++) {
          subjectWeekValues[i] = true;
        }
      }
    }

    SubjectModel model = SubjectModel(
        subjectController.text,
        teacherController.text,
        roomController.text,
        Timestamp.fromDate(timeFormat.parse(_beginTimeController.text)),
        Timestamp.fromDate(timeFormat.parse(_endTimeController.text)),
        character,
        subjectWeekValues,
        day);

    _subjectReference?.set(model.sendToSchedule());
  }
}
