import 'package:flutter/material.dart';

class GroupSettings extends StatefulWidget {
  const GroupSettings({Key? key}) : super(key: key);

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  String dropdownValueFirst = 'One';
  String dropdownValueSecond = 'One';
  String dropdownValueThird = 'One';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Grupy",
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title:const Text("Ustawienia"),
            ),
            body: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios,
                            color: Theme.of(context).primaryColor)),
                  ),
                  Container(
                      child: Column(
                    children: [
                      const Text("Wybierz wydział"),
                      DropdownButton(
                        value: dropdownValueFirst,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueFirst = newValue!;
                          });
                        },
                        items: <String>['One', 'Two', 'Three', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  )),
                  Container(
                      child: Column(
                    children: [
                      const Text("Wybierz Kierunek"),
                      DropdownButton(
                        value: dropdownValueSecond,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueSecond = newValue!;
                          });
                        },
                        items: <String>['One', 'Two', 'Three', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  )),
                  Container(
                      child: Column(
                    children: [
                      const Text("Wybierz Grupa"),
                      DropdownButton(
                        value: dropdownValueThird,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueThird = newValue!;
                          });
                        },
                        items: <String>['One', 'Two', 'Three', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  )
                ),
              ],
            ),
        )
      )
    );
  }
}
