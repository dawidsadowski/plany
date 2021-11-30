import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/models/subject_model.dart';
import 'package:delta_squad_app/models/timetable_model.dart';
import 'package:delta_squad_app/screens/homeScreens/actions/add_subject.dart';
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
  List<Appointment> subjects = <Appointment>[];
  CalendarTapDetails? _details;
  List<TimeTable> list = [];
  List<SubjectModel> schedule = [];

  @override
  void initState() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;

    list = [];
    schedule = [];
    subjects = <Appointment>[];

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
        getScheduleData(data);

        getSchedule(wt, (data) {
          getScheduleData(data);

          getSchedule(sr, (data) {
            getScheduleData(data);

            getSchedule(czw, (data) {
              getScheduleData(data);

              getSchedule(pt, (data) {
                List<dynamic> sch_pon =
                    data.docs.map((doc) => doc.data()).toList();

                for (int i = 0; i < sch_pon.length; i++) {
                  dynamic sch = sch_pon.elementAt(i);
                  SubjectModel sub = SubjectModel.withoutWeeks(
                      sch['name'],
                      sch['instructor'],
                      sch['hall'],
                      sch['beginTime'],
                      sch['endTime'],
                      SingingCharacter.values[sch['type']],
                      WeekDays.values[sch['day']]);

                  List<bool> wee = sch['weeks'].cast<bool>();
                  sub.weeks = wee;

                  setState(() {
                    schedule.add(sub);
                  });
                  print(sub.name);
                }

                for (int i = 0; i < list.length; i++) {
                  for (int j = 0; j < schedule.length; j++) {
                    if (WeekDays.values[list[i].dayOfWeek] == schedule[j].day) {
                      int weeek = list[i].weekOfSemester - 1;
                      if (schedule[j].weeks![weeek]) {
                        DateTime beginTime =
                            DateTime.fromMicrosecondsSinceEpoch(
                                schedule[j].beginTime!.microsecondsSinceEpoch);
                        DateTime endTime = DateTime.fromMicrosecondsSinceEpoch(
                            schedule[j].endTime!.microsecondsSinceEpoch);

                        Color color = Colors.blue;

                        switch (schedule[j].type) {
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

                        setState(() {
                          subjects.add(Appointment(
                            startTime: DateTime(
                                2021,
                                list[i].monthOfYear,
                                list[i].dayOfMonth,
                                beginTime.hour,
                                beginTime.minute),
                            endTime: DateTime(
                                2021,
                                list[i].monthOfYear,
                                list[i].dayOfMonth,
                                endTime.hour,
                                endTime.minute),
                            subject:
                                '${schedule[j].name}\n${schedule[j].instructor}\n${schedule[j].hall}',
                            color: color,
                            //recurrenceRule: SfCalendar.generateRRule(recurrence, beginTime, endTime)
                          ));
                        });
                      }
                    }
                  }
                }

                setState(() {});
              });
            });
          });
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
          WeekDays.values[sch['day']]);
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
          PopupMenuButton(
              onSelected: (result) {
                if (result == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsView()),
                  );
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Ustawienia"),
                      value: 0,
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

          initState();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SfCalendar(
          appointmentTextStyle: const TextStyle(fontSize: 20),
          controller: _controller,
          onLongPress: (details) {
            if(_calendarView == CalendarView.month) {
              setState(() {
                _calendarView = CalendarView.day;
                _controller.view = CalendarView.day;
              });
            }
          },
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
