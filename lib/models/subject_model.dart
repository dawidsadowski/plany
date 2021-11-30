
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SubjectModel {
  String? name;
  String? instructor;
  String? hall;
  String? beginTime;
  String? endTime;
  SingingCharacter? type;
  List<bool>? weeks;
  WeekDays? day;

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
      this.endTime, this.type, this.day);

  Map<String, dynamic> sendToSchedule() {
    return {
      'day': day!.index,
      'hall': hall,
      'instructor': instructor,
      'name': name,
      'type': type!.index,
      'weeks': weeks,
    };
  }
}

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum TimeType { all, x1, x2 }

enum SingingCharacter { lecture, exercise, laboratory, seminary }
