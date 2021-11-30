import 'dart:html';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class SubjectModel{
  String? email;
  String? name;
  String? instructor;
  String? hall;
  String? beginTime;
  String? endTime;
  SingingCharacter? type;
  List<bool>? weeks;
  WeekDays? day;

  SubjectModel(this.email, this.name, this.instructor, this.hall,this.beginTime,this.endTime, this.type,
      this.weeks, this.day);

  Map<String, dynamic> sendToSchedule() {
    return{
      'email':email,
      'day':day,
      'hall':hall,
      'instructor':instructor,
      'name':name,
      'type':type,
      'weeks':weeks,

    };
  }
}

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum TimeType { all, x1, x2 }

enum SingingCharacter { lecture, exercise, laboratory, seminary }
