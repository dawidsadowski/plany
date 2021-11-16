import 'package:flutter/material.dart';

class GroupSettings extends StatefulWidget {
  const GroupSettings({Key? key}) : super(key: key);
  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Grupy",
        home: Scaffold(
          body: Center(
            child:IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor)),
          ),
        )
    );
  }
}