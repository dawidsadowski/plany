
class TimeTable{
  var monthOfYear;
  var weekOfSemester;
  var dayOfWeek;
  var dayOfMonth;
  var year;

  TimeTable(
      this.monthOfYear,
      this.weekOfSemester,
      this.dayOfWeek,
      this.dayOfMonth,
      this.year
      );

  Map<String, dynamic> sendToSemester() {
    return {
      'monthOfYear': monthOfYear,
      'weekOfSemester': weekOfSemester,
      'dayOfWeek': dayOfWeek,
      'dayOfMonth': dayOfMonth,
      'year': year,
    };
  }
}

