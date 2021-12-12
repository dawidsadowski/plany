import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Subject extends Appointment {
  DocumentReference<Object?>? reference;
  bool? editable;
  SubjectModel? subjectModel;

  Subject({
    this.reference,
    this.editable,
    this.subjectModel,
    String? startTimeZone,
    String? endTimeZone,
    String? recurrenceRule,
    bool isAllDay = false,
    String? notes,
    String? location,
    List<Object>? resourceIds,
    Object? recurrenceId,
    Object? id,
    required DateTime startTime,
    required DateTime endTime,
    String subject = '',
    Color color = Colors.lightBlue,
    List<DateTime>? recurrenceExceptionDates,
  }) : super(
      startTimeZone: startTimeZone,
      endTimeZone: endTimeZone,
      recurrenceRule: recurrenceRule,
      isAllDay: isAllDay,
      notes: notes,
      location: location,
      resourceIds: resourceIds,
      recurrenceId: recurrenceId,
      id: id,
      endTime: endTime,
      startTime: startTime,
      subject: subject,
      color: color,
      recurrenceExceptionDates: recurrenceExceptionDates,
  );
}
