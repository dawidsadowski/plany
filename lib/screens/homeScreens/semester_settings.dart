import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/models/timetable_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class SemesterSettingsView extends StatefulWidget {
  const SemesterSettingsView({Key? key}) : super(key: key);

  @override
  State<SemesterSettingsView> createState() => _SemesterSettingsViewState();
}

class _SemesterSettingsViewState extends State<SemesterSettingsView> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Appointment> days = [];

  var daysOfWeek = ['poniedziałek', 'wtorek', 'środa', 'czwartek', 'piątek', 'sobota', 'niedziela'];
  String dayOfWeek = 'poniedziałek';
  String week = '1';

  @override
  void initState() {
    refreshCalendar();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ustawienia semestru"),
      ),
      body: SafeArea(
        child: SfCalendar(
          dataSource: MeetingDataSource(days),
          onTap: (data) async {
            DateTime date = data.date!;

            dayOfWeek = daysOfWeek[date.weekday - 1];

            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(DateFormat('yyyy-MM-dd').format(date)),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text('Dzień tygodnia'),
                                  DropdownButton<String>(
                                    value: dayOfWeek,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 32,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dayOfWeek = newValue!;
                                      });
                                    },
                                    items: daysOfWeek
                                        .map<DropdownMenuItem<String>>((
                                        String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text('Numer tygodnia'),
                                  DropdownButton<String>(
                                    value: week,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 32,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        week = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8',
                                      '9',
                                      '10',
                                      '11',
                                      '12',
                                      '13',
                                      '14',
                                      '15'
                                    ]
                                        .map<DropdownMenuItem<String>>((
                                        String value) =>
                                        DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        )
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    actions: [
                      MaterialButton(
                        textColor: Colors.blue,
                        child: Text('Zapisz'),
                        onPressed: () async {

                          int dayOfWeekNumber = 0;
                          int weekNumber = int.parse(week);

                          switch(dayOfWeek) {
                            case 'poniedziałek':
                              dayOfWeekNumber = 1;
                              break;
                            case 'wtorek':
                              dayOfWeekNumber = 2;
                              break;
                            case 'środa':
                              dayOfWeekNumber = 3;
                              break;
                            case 'czwartek':
                              dayOfWeekNumber = 4;
                              break;
                            case 'piątek':
                              dayOfWeekNumber = 5;
                              break;
                            case 'sobota':
                              dayOfWeekNumber = 6;
                              break;
                            case 'niedziela':
                              dayOfWeekNumber = 7;
                              break;
                          }

                          TimeTable timeTable = TimeTable(
                              date.month,
                              weekNumber,
                              dayOfWeekNumber,
                              date.day,
                              date.year
                          );

                          await firebaseFirestore
                              .collection("semester")
                              .doc("winter21-22")
                              .collection("days")
                              .doc("${date.year}.${date.month}.${date.day}")
                              .set(timeTable.sendToSemester());

                          setState(() {
                            Navigator.pop(context);
                            refreshCalendar();
                          });
                        },
                      ),
                      MaterialButton(
                        textColor: Colors.blue,
                        child: Text('Anuluj'),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  );
                });
          },
          view: CalendarView.month,
        ),
      ),
    );
  }

  Future<void> getData(CollectionReference collectionReference, Function callback) async {
    QuerySnapshot querySnapshot = await collectionReference.get();
    callback(querySnapshot);
  }

  void refreshCalendar() {
    days = [];

    var docRef = firebaseFirestore
        .collection("semester")
        .doc("winter21-22")
        .collection("days");

    getData(docRef, (data) {
      List<dynamic> lista = data.docs.map((doc) => doc.data()).toList();
      for (int i = 0; i < lista.length; i++) {
        dynamic t = lista.elementAt(i);
        TimeTable tt = TimeTable(
            t['monthOfYear'],
            t['weekOfSemester'],
            t['dayOfWeek'],
            t['dayOfMonth'],
            t['year']
        );

        setState(() {
          days.add(Appointment(
            startTime: DateTime(tt.year, tt.monthOfYear, tt.dayOfMonth),
            endTime: DateTime(tt.year, tt.monthOfYear, tt.dayOfMonth).add(Duration(hours: 13)),
            color: Colors.black,
          )
          );
        });

      }
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
