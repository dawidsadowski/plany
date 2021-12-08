
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SubjectModel {
  String? name;
  String? instructor;
  String? hall;
  Timestamp? beginTime;
  Timestamp? endTime;
  SingingCharacter? type;
  List<bool>? weeks;
  WeekDays? day;
  DocumentReference<Object?>? reference;

  SubjectModel(
      this.name,
      this.instructor,
      this.hall,
      this.beginTime,
      this.endTime,
      this.type,
      this.weeks,
      this.day);


  SubjectModel.withoutWeeks(this.name, this.instructor, this.hall, this.beginTime,
      this.endTime, this.type, this.day, this.reference);

  Map<String, dynamic> sendToSchedule() {
    return {
      'day': day!.index,
      'hall': hall,
      'instructor': instructor,
      'name': name,
      'type': type!.index,
      'weeks': weeks,
      'beginTime': beginTime,
      'endTime': endTime
    };
  }
}

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum TimeType { all, x1, x2 }

enum SingingCharacter { lecture, exercise, laboratory, seminary, other }
