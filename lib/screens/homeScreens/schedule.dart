import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/models/subject_model.dart';
import 'package:delta_squad_app/models/timetable_model.dart';
import 'package:delta_squad_app/screens/homeScreens/actions/add_subject.dart';
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
  List<Appointment> subjects = <Appointment>[];
  CalendarTapDetails? _details;
  List<TimeTable> list = [];
  List<SubjectModel> schedule = [];

  @override
  void initState() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    User? user = firebaseAuth.currentUser;

    var docRef = firebaseFirestore
        .collection("semester")
        .doc("winter21-22")
        .collection("days");
    var pon = firebaseFirestore
        .collection("users")
        .doc(user!.email)
        .collection("schedule")
        .doc("1")
        .collection("subjects");
    var wt = firebaseFirestore
        .collection("users")
        .doc(user.email)
        .collection("schedule")
        .doc("2")
        .collection("subjects");
    var sr = firebaseFirestore
        .collection("users")
        .doc(user.email)
        .collection("schedule")
        .doc("3")
        .collection("subjects");
    var czw = firebaseFirestore
        .collection("users")
        .doc(user.email)
        .collection("schedule")
        .doc("4")
        .collection("subjects");
    var pt = firebaseFirestore
        .collection("users")
        .doc(user.email)
        .collection("schedule")
        .doc("5")
        .collection("subjects");

    getData(docRef, (data) {
      List<dynamic> lista = data.docs.map((doc) => doc.data()).toList();
      for (int i = 0; i < lista.length; i++) {
        dynamic t = lista.elementAt(i);
        TimeTable tt = TimeTable(t['monthOfYear'], t['weekOfSemester'],
            t['dayOfWeek'], t['dayOfMonth']);
        list.add(tt);
      }
      print(list[0].weekOfSemester);

      getSchedule(pon, (data) {
        List<dynamic> sch_pon = data.docs.map((doc) => doc.data()).toList();

        for (int i = 0; i < sch_pon.length; i++) {
          dynamic sch = sch_pon.elementAt(i);
          SubjectModel sub = SubjectModel.withoutWeeks(
              sch['name'],
              sch['instructor'],
              sch['hall'],
              "8:00",
              "10:00",
              SingingCharacter.values[sch['type']],
              WeekDays.values[sch['day']]);
          List<bool> wee = sch['weeks'].cast<bool>();
          sub.weeks = wee;
          schedule.add(sub);
        }
      });

      getSchedule(pon, (data) {
        List<dynamic> sch_pon = data.docs.map((doc) => doc.data()).toList();

        for (int i = 0; i < sch_pon.length; i++) {
          dynamic sch = sch_pon.elementAt(i);
          SubjectModel sub = SubjectModel.withoutWeeks(
              sch['name'],
              sch['instructor'],
              sch['hall'],
              "8:00",
              "10:00",
              SingingCharacter.values[sch['type']],
              WeekDays.values[sch['day']]);
          List<bool> wee = sch['weeks'].cast<bool>();
          sub.weeks = wee;
          schedule.add(sub);
        }
      });

      getSchedule(wt, (data) {
        List<dynamic> sch_pon = data.docs.map((doc) => doc.data()).toList();

        for (int i = 0; i < sch_pon.length; i++) {
          dynamic sch = sch_pon.elementAt(i);
          SubjectModel sub = SubjectModel.withoutWeeks(
              sch['name'],
              sch['instructor'],
              sch['hall'],
              "8:00",
              "10:00",
              SingingCharacter.values[sch['type']],
              WeekDays.values[sch['day']]);
          List<bool> wee = sch['weeks'].cast<bool>();
          sub.weeks = wee;
          schedule.add(sub);
        }
      });

      getSchedule(sr, (data) {
        List<dynamic> sch_pon = data.docs.map((doc) => doc.data()).toList();

        for (int i = 0; i < sch_pon.length; i++) {
          dynamic sch = sch_pon.elementAt(i);
          SubjectModel sub = SubjectModel.withoutWeeks(
              sch['name'],
              sch['instructor'],
              sch['hall'],
              "8:00",
              "10:00",
              SingingCharacter.values[sch['type']],
              WeekDays.values[sch['day']]);
          List<bool> wee = sch['weeks'].cast<bool>();
          sub.weeks = wee;
          schedule.add(sub);
        }
      });

      getSchedule(czw, (data) {
        List<dynamic> sch_pon = data.docs.map((doc) => doc.data()).toList();

        for (int i = 0; i < sch_pon.length; i++) {
          dynamic sch = sch_pon.elementAt(i);
          SubjectModel sub = SubjectModel.withoutWeeks(
              sch['name'],
              sch['instructor'],
              sch['hall'],
              "8:00",
              "10:00",
              SingingCharacter.values[sch['type']],
              WeekDays.values[sch['day']]);
          List<bool> wee = sch['weeks'].cast<bool>();
          sub.weeks = wee;
          schedule.add(sub);
        }
      });

      getSchedule(pt, (data) {
        List<dynamic> sch_pon = data.docs.map((doc) => doc.data()).toList();

        for (int i = 0; i < sch_pon.length; i++) {
          dynamic sch = sch_pon.elementAt(i);
          SubjectModel sub = SubjectModel.withoutWeeks(
              sch['name'],
              sch['instructor'],
              sch['hall'],
              "8:00",
              "10:00",
              SingingCharacter.values[sch['type']],
              WeekDays.values[sch['day']]);

          List<bool> wee = sch['weeks'].cast<bool>();
          sub.weeks = wee;

          schedule.add(sub);
          print(sub.name);
        }

        for (int i = 0; i < list.length; i++) {
          for (int j = 0; j < schedule.length; j++) {
            if (WeekDays.values[list[i].dayOfWeek] == schedule[j].day) {
              DateTime dd =
                  DateTime(2021, list[i].monthOfYear, list[i].dayOfMonth, 12);
              subjects.add(Appointment(
                startTime:
                    DateTime(2021, list[i].monthOfYear, list[i].dayOfMonth, 12),
                endTime:
                    DateTime(2021, list[i].monthOfYear, list[i].dayOfMonth, 12)
                        .add(Duration(hours: 2)),
                subject:
                    '${schedule[j].name}\n${schedule[j].instructor}\n${schedule[j].hall}',
                color: Colors.orange,
                //recurrenceRule: SfCalendar.generateRRule(recurrence, beginTime, endTime)
              ));
            }
          }
        }
      });
    });

    sleep(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plan zajęć"),
        actions: [
          GestureDetector(
            onTap: () {},
            child: IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
          ),
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
                value: true,
                onChanged: (value) {}),
            CheckboxListTile(
                activeColor: Colors.teal,
                title: Text("Ćwiczenia"),
                controlAffinity: ListTileControlAffinity.leading,
                value: true,
                onChanged: (value) {}),
            CheckboxListTile(
                activeColor: Colors.blue,
                title: Text("Laboratoria"),
                controlAffinity: ListTileControlAffinity.leading,
                value: true,
                onChanged: (value) {}),
            CheckboxListTile(
                activeColor: Colors.redAccent,
                title: Text("Seminaria"),
                controlAffinity: ListTileControlAffinity.leading,
                value: true,
                onChanged: (value) {}),
            CheckboxListTile(
                activeColor: Colors.black54,
                title: Text("Inne"),
                controlAffinity: ListTileControlAffinity.leading,
                value: true,
                onChanged: (value) {}),
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
            CheckboxListTile(
                title: Text("TM6"),
                controlAffinity: ListTileControlAffinity.leading,
                value: true,
                onChanged: (value) {}),
            CheckboxListTile(
                title: Text("TIZJO1"),
                controlAffinity: ListTileControlAffinity.leading,
                value: true,
                onChanged: (value) {}),
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

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SfCalendar(
          controller: _controller,
          onTap: (details) {
            setState(() {
              _details = details;
            });
          },
          view: _calendarView,
          dataSource: MeetingDataSource(subjects),
          timeSlotViewSettings: const TimeSlotViewSettings(
            timeFormat: "HH:mm",
            // startHour: 0,
            // endHour: 23,
            // nonWorkingDays: <int>[DateTime.friday, DateTime.saturday]
          ),
        ),
      ),
    );
  }

  void selectCalendarView(CalendarView calendarView) {
    setState(() {
      _calendarView = calendarView;
      _controller.view = calendarView;
      Navigator.pop(context);
    });
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
  MeetingDataSource(List<Appointment> source) {
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

  Appointment _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Appointment meetingData;
    if (meeting is Appointment) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
