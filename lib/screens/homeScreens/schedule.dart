import 'dart:ui';

import 'package:delta_squad_app/classes/subject.dart';
import 'package:delta_squad_app/screens/homeScreens/actions/add_subject.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  int _selectedDestination = 0;
  List<Subject> subjects = <Subject>[];
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
          child: ListView(children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Delta Szwadron",
            style: TextStyle(
              fontFeatures: [FontFeature.enable('smcp')],
              fontSize: 25,
              color: Colors.black54,
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        ListTile(
          leading: Icon(Icons.calendar_view_day),
          title: Text('Dzień'),
          selected: _selectedDestination == 0,
          onTap: () => selectDestination(0),
        ),
        ListTile(
          leading: Icon(Icons.calendar_view_week),
          title: Text('Tydzień'),
          selected: _selectedDestination == 1,
          onTap: () => selectDestination(1),
        ),
        ListTile(
          leading: Icon(Icons.calendar_view_month),
          title: Text('Miesiąc'),
          selected: _selectedDestination == 2,
          onTap: () => selectDestination(2),
        ),
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
          onTap: (details) {
            setState(() {
              _details = details;
            });
          },
          view: CalendarView.day,
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

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Subject> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
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
