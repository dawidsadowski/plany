import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
                    MaterialPageRoute(builder: (context) => const SettingsView()),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: Text("Ustawienia"),
                  value: 0,
                ),
              ]
          )
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
                  Icon(
                      Icons.today,
                      color: Colors.black54
                  ),
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
      Navigator.pop(context);
    });
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
