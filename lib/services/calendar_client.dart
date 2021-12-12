import 'dart:developer';

import 'package:delta_squad_app/classes/subject.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarClient {
  var _scopes = [CalendarApi.calendarScope];

  insert(List<Subject> subjects){
    var _clientID = new ClientId("593458370937-7n5nk6pk6qfvjlbraoef3u35m3bfun5i.apps.googleusercontent.com", "");
    clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
      var calendar = CalendarApi(client);
      String calendarId = "primary";
      for (var element in subjects) {

        Event event = Event(); // Create object of event

        event.summary = element.subject;

        EventDateTime start = new EventDateTime();
        start.dateTime = element.startTime;
        event.start = start;

        EventDateTime end = new EventDateTime();
        end.dateTime = element.endTime;
        event.end = end;
        try {
          calendar.events.insert(event, calendarId).then((value) {
            if (value.status == "confirmed") {
              log('Event added in google calendar');
            } else {
              log("Unable to add event in google calendar");
            }
          });
        } catch (e) {
          log('Error creating event $e');
        }

      }
    });
  }

  void prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}