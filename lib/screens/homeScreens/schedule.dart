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
  List<Subject> subjects = <Subject>[];
  bool _menuOpened = false;

  CalendarTapDetails? _details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plan zajęć"),
        leading: GestureDetector(
            onTap: () {},
            child: IconButton(
                splashRadius: 20,
                onPressed: () {
                  setState(() {
                    _menuOpened = !_menuOpened;
                  });
                },
                icon: Icon(_menuOpened ? Icons.arrow_back : Icons.menu))),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSubject(subjects: subjects, details: _details)),
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


