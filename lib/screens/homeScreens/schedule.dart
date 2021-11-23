import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var startingIndex = 999;
  late PageController controller;
  DateTime now = DateTime.now();
  late DateTime date;
  late int _index;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    controller = PageController(initialPage: startingIndex);
    date = DateTime(now.year, now.month, now.day);
    _index = startingIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(dateFormat.format(date.add(Duration(days: _index - startingIndex)))),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: const Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom, // TODO: Fix it somehow
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        _index = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return  Container(
                          child: SingleChildScrollView(
                            child:
                              Column(
                                children: [
                                  Text(
                                      "${dateFormat.format(date.add(Duration(days: index-startingIndex)))} "
                                          "(${DateFormat('EEEE').format(date.add(Duration(days: index-startingIndex)))})",
                                      style: const TextStyle(
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  Text(
                                      "${dateFormat.format(date.add(Duration(days: index-startingIndex)))} "
                                          "(${DateFormat('EEEE').format(date.add(Duration(days: index-startingIndex)))})",
                                      style: const TextStyle(
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                ],
                              ),
                          )
                      );
                    },
                  ),
                ),
              ],
            ),
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


