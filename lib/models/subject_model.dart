class SubjectModel{
  String? email;
  String? name;
  String? instructor;
  String? hall;
  SingingCharacter? type;
  List<bool>? weeks;
  Days? day;

}

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum TimeType { all, x1, x2 }

enum SingingCharacter { Lecture, Excercise, Laboratorium, Seminary }
