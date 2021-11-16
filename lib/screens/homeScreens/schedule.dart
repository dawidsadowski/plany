import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var startingIndex=999;
  late PageController controller;
  DateTime now = DateTime.now();
  late DateTime date;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    controller = PageController(initialPage: startingIndex);
    date = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                child: const Text(
                  "Plan Zajęć",
                  style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold
                  )
                )
              ),
              Container(
                height: 650,
                child: PageView.builder(
                  controller: controller,
                  itemBuilder: (context, index) {
                    return  Container(
                        color: Colors.grey,
                        padding: EdgeInsets.all(40.0),
                        margin: EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Text(
                                "${dateFormat.format(date.add(Duration(days: index-startingIndex)))} "
                                    "(${DateFormat('EEEE').format(date.add(Duration(days: index-startingIndex)))})",
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold
                                )
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
              Container(
                child: MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text('Dodaj przedmiot'),
                  onPressed: (){

                    }
                  ),
                ),
            ],
          ),
        )
      )
    );
  }
}
/*
PageView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return  Container(
                color: Colors.grey,
                padding: EdgeInsets.all(40.0),
                margin: EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Text(
                        "${dateFormat.format(date.add(Duration(days: index-startingIndex)))} "
                            "(${DateFormat('EEEE').format(date.add(Duration(days: index-startingIndex)))})",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold
                        )
                    ),
                  ],
                )
            );
          },
        )
*/