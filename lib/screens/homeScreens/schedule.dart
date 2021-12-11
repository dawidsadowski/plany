import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/classes/subject.dart';
import 'package:delta_squad_app/models/subject_model.dart';
import 'package:delta_squad_app/models/timetable_model.dart';
import 'package:delta_squad_app/screens/homeScreens/actions/add_subject.dart';
import 'package:delta_squad_app/screens/homeScreens/actions/add_subject_group.dart';
import 'package:delta_squad_app/screens/homeScreens/semester_settings.dart';
import 'package:delta_squad_app/screens/homeScreens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final CalendarController _controller = CalendarController();
  CalendarView _calendarView = CalendarView.day;
  List<Subject> subjects = <Subject>[];
  CalendarTapDetails? _details;
  List<TimeTable> list = [];
  List<SubjectModel> schedule = [];

  bool isRefreshed = true;
  bool showLectures = true;
  bool showExercises = true;
  bool showLaboratories = true;
  bool showSeminaries = true;
  bool showOther = true;

  @override
  void initState() {
    refreshCalendar();
  }

  void refreshCalendar() {
    if (!isRefreshed) {
      return;
    }

    isRefreshed = !isRefreshed;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;

    list = [];
    schedule = [];
    subjects = <Subject>[];

    var docRef = firebaseFirestore
        .collection("semester")
        .doc("winter21-22")
        .collection("days");

    var scheduleRef = firebaseFirestore
        .collection("users")
        .doc(user!.email)
        .collection("schedule");



    getData(docRef, (data) {
      List<dynamic> lista = data.docs.map((doc) => doc.data()).toList();
      for (int i = 0; i < lista.length; i++) {
        dynamic t = lista.elementAt(i);
        TimeTable tt = TimeTable(t['monthOfYear'], t['weekOfSemester'],
            t['dayOfWeek'], t['dayOfMonth'], t['year']);
        list.add(tt);
      }

      getSchedule(scheduleRef, (data) {
        getScheduleData(data);

        for (int i = 0; i < list.length; i++) {
          for (int j = 0; j < schedule.length; j++) {
            if (WeekDays.values[list[i].dayOfWeek] == schedule[j].day) {
              int weeek = list[i].weekOfSemester - 1;
              if (schedule[j].weeks![weeek]) {
                DateTime beginTime = DateTime.fromMicrosecondsSinceEpoch(
                    schedule[j].beginTime!.microsecondsSinceEpoch);
                DateTime endTime = DateTime.fromMicrosecondsSinceEpoch(
                    schedule[j].endTime!.microsecondsSinceEpoch);

                Color color = Colors.blue;

                switch (schedule[j].type) {
                  case SingingCharacter.lecture:
                    if (!showLectures) continue;
                    color = Colors.orange;
                    break;
                  case SingingCharacter.exercise:
                    if (!showExercises) continue;
                    color = Colors.teal;
                    break;
                  case SingingCharacter.laboratory:
                    if (!showLaboratories) continue;
                    color = Colors.blue;
                    break;
                  case SingingCharacter.seminary:
                    if (!showSeminaries) continue;
                    color = Colors.redAccent;
                    break;
                  default:
                    if (!showOther) continue;
                    color = Colors.grey;
                }

                setState(() {
                  subjects.add(Subject(
                    startTime: DateTime(list[i].year, list[i].monthOfYear,
                        list[i].dayOfMonth, beginTime.hour, beginTime.minute),
                    endTime: DateTime(list[i].year, list[i].monthOfYear,
                        list[i].dayOfMonth, endTime.hour, endTime.minute),
                    subject:
                        '${schedule[j].name}\n${schedule[j].instructor}\n${schedule[j].hall}',
                    color: color,
                    reference: schedule[j].reference,
                    //recurrenceRule: SfCalendar.generateRRule(recurrence, beginTime, endTime)
                  ));
                });
              }
            }
          }
        }

        setState(() {
          isRefreshed = !isRefreshed;
        });
      });
    });
  }

  void getScheduleData(data) {
    List<dynamic> sch_pon = data.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < sch_pon.length; i++) {
      dynamic sch = sch_pon.elementAt(i);
      SubjectModel sub = SubjectModel.withoutWeeks(
          sch['name'],
          sch['instructor'],
          sch['hall'],
          sch['beginTime'],
          sch['endTime'],
          SingingCharacter.values[sch['type']],
          WeekDays.values[sch['day']],
          data.docs.elementAt(i).reference);

      List<bool> wee = sch['weeks'].cast<bool>();
      sub.weeks = wee;

      setState(() {
        schedule.add(sub);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plan zajęć"),
        actions: [
          PopupMenuButton(
              onSelected: (result) async {
                if (result == -1) {
                } else if (result == 0) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsView()),
                  );
                } else if (result == 1) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SemesterSettingsView()),
                  );
                } else if (result == 2) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSubjectGroup(
                            subjects: subjects, details: _details)),
                  );
                }

                refreshCalendar();
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Odśwież"),
                      value: -1,
                    ),
                    const PopupMenuItem(
                      child: Text("Ustawienia"),
                      value: 0,
                    ),
                    const PopupMenuItem(
                      child: Text("Ustawienia semestru"),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text("Dodaj przedmiot grupowy"),
                      value: 2,
                    ),
                  ])
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Delta Szwadron",
                    style: TextStyle(
                      fontFeatures: [FontFeature.enable('smcp')],
                      fontSize: 25,
                      color: Colors.black54,
                    ),
                  ),
                  Icon(Icons.today, color: Colors.black54),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.calendar_view_day),
              title: Text('Dzień'),
              selected: _calendarView == CalendarView.day,
              onTap: () => selectCalendarView(CalendarView.day),
            ),
            ListTile(
              leading: Icon(Icons.calendar_view_week),
              title: Text('Tydzień'),
              selected: _calendarView == CalendarView.week,
              onTap: () => selectCalendarView(CalendarView.week),
            ),
            ListTile(
              leading: Icon(Icons.calendar_view_month),
              title: Text('Miesiąc'),
              selected: _calendarView == CalendarView.month,
              onTap: () => selectCalendarView(CalendarView.month),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Rodzaj zajęć',
              ),
            ),
            CheckboxListTile(
                activeColor: Colors.orange,
                title: Text("Wykłady"),
                controlAffinity: ListTileControlAffinity.leading,
                value: showLectures,
                onChanged: (value) {
                  setState(() {
                    showLectures = !showLectures;
                  });

                  refreshCalendar();
                }),
            CheckboxListTile(
                activeColor: Colors.teal,
                title: Text("Ćwiczenia"),
                controlAffinity: ListTileControlAffinity.leading,
                value: showExercises,
                onChanged: (value) {
                  setState(() {
                    showExercises = !showExercises;
                  });

                  refreshCalendar();
                }),
            CheckboxListTile(
                activeColor: Colors.blue,
                title: Text("Laboratoria"),
                controlAffinity: ListTileControlAffinity.leading,
                value: showLaboratories,
                onChanged: (value) {
                  setState(() {
                    showLaboratories = !showLaboratories;
                  });

                  refreshCalendar();
                }),
            CheckboxListTile(
                activeColor: Colors.redAccent,
                title: Text("Seminaria"),
                controlAffinity: ListTileControlAffinity.leading,
                value: showSeminaries,
                onChanged: (value) {
                  setState(() {
                    showSeminaries = !showSeminaries;
                  });

                  refreshCalendar();
                }),
            CheckboxListTile(
                activeColor: Colors.black54,
                title: Text("Inne"),
                controlAffinity: ListTileControlAffinity.leading,
                value: showOther,
                onChanged: (value) {
                  setState(() {
                    showOther = !showOther;
                  });

                  refreshCalendar();
                }),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Grupy',
              ),
            ),
            Column(
              children: getStudentGroups(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddSubject(subjects: subjects, details: _details)),
          );

          refreshCalendar();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SfCalendar(
          controller: _controller,
          onLongPress: (details) {
            if (_calendarView == CalendarView.month) {
              setState(() {
                _calendarView = CalendarView.day;
                _controller.view = CalendarView.day;
              });
            }

            // TODO: Implement Subject editing
            if (_calendarView == CalendarView.day) {
              if (details.appointments != null) {
                // TODO: Add removal confirmation dialog
                // // Just for visual aspect
                // setState(() {
                //   subjects.remove(_selectedSubject);
                // });
                //
                // _selectedSubject!.reference!.delete().then((value) {
                //   refreshCalendar();
                //   Fluttertoast.showToast(msg: 'Usunięto ${_selectedSubject!.subject.split('\n')[0]}');
                // });
              }
            }
          },
          appointmentTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          onTap: (details) {
            setState(() {
              _details = details;
            });
          },
          view: _calendarView,
          dataSource: MeetingDataSource(subjects),
          timeSlotViewSettings: const TimeSlotViewSettings(
            timeFormat: "HH:mm",
            startHour: 7,
            endHour: 21,
            timeRulerSize: 60,
            timeIntervalHeight: 70,
            timeTextStyle: TextStyle(fontSize: 16, color: Colors.black54),
            // nonWorkingDays: <int>[DateTime.friday, DateTime.saturday]
          ),
        ),
      ),
    );
  }

  List<Widget> getStudentGroups() {
    User? user = FirebaseAuth.instance.currentUser;
    List<Widget> groupTiles = [];

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.email)
        .collection("groups")
        .get()
        .then((value) {
      for (var element in value.docs) {
        groupTiles.add(
          CheckboxListTile(
              title: Text(element.id),
              controlAffinity: ListTileControlAffinity.leading,
              value: true,
              onChanged: (value) {}),
        );
      }
    });

    return groupTiles;
  }

  void selectCalendarView(CalendarView calendarView) {
    setState(() {
      _calendarView = calendarView;
      _controller.view = calendarView;
    });

    Navigator.pop(context);
  }

  Future<void> getData(
      CollectionReference collectionReference, Function callback) async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionReference.get();

    callback(querySnapshot);

    // Get data from docs and convert map to List
  }

  void getSchedule(
      CollectionReference collectionReference, Function function) async {
    QuerySnapshot querySnapshot = await collectionReference.get();
    function(querySnapshot);
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Subject> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).endTime;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).subject;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).color;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Subject _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Subject meetingData;
    if (meeting is Subject) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
