import 'package:delta_squad_app/classes/subject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key, required this.subjects}) : super(key: key);

  final List<Subject> subjects;

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum TimeType { all, x1, x2 }

enum SingingCharacter { Lecture, Excercise, Laboratorium, Seminary }

class _AddSubjectState extends State<AddSubject> {
  late TextEditingController _subjectController;
  late TextEditingController _teacherController;
  late TextEditingController _roomController;

  Days? _days = Days.monday;
  TimeType? _typy = TimeType.all;

  late bool _switchValue;

  late TextEditingController _beginTime;
  late TextEditingController _endTime;
  DateFormat dateFormat = DateFormat("HH:mm");

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  final _formKey = GlobalKey<FormState>();

  final List<bool> _subjectWeekValues = List.generate(15, (index) => false);

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
    setState(() {
      final now = new DateTime.now();
      var now2 =
          DateTime(now.year, now.month, now.day, newTime!.hour, newTime.minute);
      txt.text = dateFormat.format(now2);
    });
  }

  @override
  void initState() {
    _subjectController = TextEditingController();
    _teacherController = TextEditingController();
    _roomController = TextEditingController();
    _beginTime = TextEditingController();
    _endTime = TextEditingController();
    _switchValue = false;

    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    _beginTime.dispose();
    _endTime.dispose();

    super.dispose();
  }

  int val = -1;
  SingingCharacter? _character = SingingCharacter.Lecture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj przedmiot"),
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
                      value: SingingCharacter.Lecture,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.Lecture;
                        });
                      }),
                  RadioListTile(
                      title: Text("Ćwiczenia"),
                      value: SingingCharacter.Excercise,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.Excercise;
                        });
                      }),
                  RadioListTile(
                      title: Text("Laboratorium"),
                      value: SingingCharacter.Laboratorium,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.Laboratorium;
                        });
                      }),
                  RadioListTile(
                      title: Text("Seminarium"),
                      value: SingingCharacter.Seminary,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.Seminary;
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
                              value: Days.monday,
                              groupValue: _days,
                              onChanged: (Days? value) {
                                setState(() {
                                  _days = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Wtorek'),
                              value: Days.tuesday,
                              groupValue: _days,
                              onChanged: (Days? value) {
                                setState(() {
                                  _days = value;
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
                              title: const Text('Sroda'),
                              value: Days.wednesday,
                              groupValue: _days,
                              onChanged: (Days? value) {
                                setState(() {
                                  _days = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Czwartek'),
                              value: Days.thursday,
                              groupValue: _days,
                              onChanged: (Days? value) {
                                setState(() {
                                  _days = value;
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
                              value: Days.friday,
                              groupValue: _days,
                              onChanged: (Days? value) {
                                setState(() {
                                  _days = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Sobota'),
                              value: Days.saturday,
                              groupValue: _days,
                              onChanged: (Days? value) {
                                setState(() {
                                  _days = value;
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
                            value: Days.sunday,
                            groupValue: _days,
                            onChanged: (Days? value) {
                              setState(() {
                                _days = value;
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
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width - 40,
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal:
                                    (MediaQuery.of(context).size.width / 2) -
                                        50),
                            value: _switchValue,
                            activeColor: Colors.blue,
                            onChanged: (bool value) {
                              setState(() {
                                _switchValue = !_switchValue;
                              });
                            },
                          )),
                    ],
                  ),

                  Row(
                    children: [
                      if (_switchValue == true)
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
                      if (_switchValue == false)
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
                                      groupValue: _typy,
                                      onChanged: (TimeType? value) {
                                        setState(() {
                                          _typy = value;
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
                                      groupValue: _typy,
                                      onChanged: (TimeType? value) {
                                        setState(() {
                                          _typy = value;
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
                                      groupValue: _typy,
                                      onChanged: (TimeType? value) {
                                        setState(() {
                                          _typy = value;
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
                    child: const Text('Dodaj'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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

  addSubject() {
    final DateTime today = DateTime.now();
    DateTime startTime = DateTime(today.year, today.month, today.day, 8, 0, 0);
    DateTime endTime = startTime.add(const Duration(hours: 2));

    Color color;

    switch (_character) {
      case SingingCharacter.Lecture:
        color = Colors.orange;
        break;
      case SingingCharacter.Excercise:
        color = Colors.teal;
        break;
      case SingingCharacter.Laboratorium:
        color = Colors.blue;
        break;
      case SingingCharacter.Seminary:
        color = Colors.redAccent;
        break;
      default:
        color = Colors.lime;
    }

    widget.subjects.add(Subject(
        '${_subjectController.text}\n${_teacherController.text}\n${_roomController.text}',
        startTime,
        endTime,
        color,
        false));
  }

  Widget _buildCheckBoxes(int start, int end, List<bool> values) {
    List<Widget> list = [];
    Widget cb, ca;
    Widget ex;

    for (int i = start; i <= end; ++i) {
      cb = CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Text(i.toString()),
          value: values[i - 1],
          onChanged: (value) {
            setState(() {
              values[i - 1] = !values[i - 1];
            });
          });
      ca = ListTile(
        dense: true,
        leading: Checkbox(
          value: false,
          onChanged: (bool? value) {},
        ),
        title: Text(i.toString()),
      );
      ex = Expanded(
        child: ca,
      );
      list.add(ex);
    }
    print(list);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: list);
  }
}
