import 'package:delta_squad_app/classes/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key, required this.subjects}) : super(key: key);

  final List<Subject> subjects;

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

enum SingingCharacter { Lecture, Excercise, Laboratorium, Seminary }

class _AddSubjectState extends State<AddSubject> {
  late TextEditingController _subjectController;
  late TextEditingController _teacherController;
  late TextEditingController _roomController;

  final _formKey = GlobalKey<FormState>();

  final List<bool> _subjectWeekValues = List.generate(15, (index) => false);

  @override
  void initState() {
    _subjectController = TextEditingController();
    _teacherController = TextEditingController();
    _roomController = TextEditingController();


    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _teacherController.dispose();
    _roomController.dispose();

    super.dispose();
  }

  int val = -1;
  SingingCharacter? _character = SingingCharacter.Lecture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj przedmiot"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _subjectController,
                    validator: (text) =>
                      text!.length > 0 ? null : "Wprowadź nazwę przedmiotu",
                    decoration: InputDecoration(
                        label: Text("Nazwa przedmiotu"),
                        prefixIcon: Icon(Icons.short_text),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _teacherController,
                    validator: (text) =>
                    text!.length > 0 ? null : "Wprowadź nazwisko osoby prowadzącej zajęcia",
                    decoration: InputDecoration(
                        label: Text("Prowadzący"),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _roomController,
                    validator: (text) =>
                    text!.length > 0 ? null : "Wprowadź identyfikator sali",
                    decoration: InputDecoration(
                        label: Text("Sala"),
                        prefixIcon: Icon(Icons.room),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 25,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5,
                  ),
                  RadioListTile(
                      title: Text("Wykład"),
                      value: SingingCharacter.Lecture,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.Lecture;
                        });
                      }),
                  RadioListTile(
                      title: Text("Ćwiczenia"),
                      value: SingingCharacter.Excercise,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.Excercise;
                        });
                      }),
                  RadioListTile(
                      title: Text("Laboratorium"),
                      value: SingingCharacter.Laboratorium,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.Laboratorium;
                        });
                      }),
                  RadioListTile(
                      title: Text("Seminarium"),
                      value: SingingCharacter.Seminary,
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = SingingCharacter.Seminary;
                        });
                      }),
                  const Divider(
                    color: Colors.black,
                    height: 25,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RadioListTile(
                                  value: 1,
                                  groupValue: val,
                                  onChanged: (value) {
                                    setState(() {

                                    });
                                  }),
                            ],
                          )
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.69,
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCheckBoxes(1, 3, _subjectWeekValues),
                              _buildCheckBoxes(4, 6, _subjectWeekValues),
                              _buildCheckBoxes(7, 9, _subjectWeekValues),
                              _buildCheckBoxes(10, 12, _subjectWeekValues),
                              _buildCheckBoxes(13, 15, _subjectWeekValues),
                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    height: 60,
                    minWidth: double.infinity,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text('Dodaj'),
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        addSubject();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addSubject() {


    final DateTime today = DateTime.now();
    DateTime startTime = DateTime(today.year, today.month, today.day, 8, 0, 0);
    DateTime endTime = startTime.add(const Duration(hours: 2));

    Color color;

    switch(_character) {
      case SingingCharacter.Lecture:
        color = Colors.orange;
        break;
      case SingingCharacter.Excercise:
        color = Colors.teal;
        break;
      case SingingCharacter.Laboratorium:
        color = Colors.blue;
        break;
      case SingingCharacter.Seminary:
        color = Colors.redAccent;
        break;
      default:
        color = Colors.lime;
    }

    widget.subjects.add(Subject('${_subjectController.text}\n${_teacherController.text}\n${_roomController.text}', startTime, endTime, color, false));
  }

  Widget _buildCheckBoxes(int start, int end, List<bool> values) {
    List<Widget> list = [];
    Widget cb,ca;
    Widget ex;

    for (int i=start;i<=end;++i) {
      cb = CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Text(i.toString()),
          value: values[i - 1],
          onChanged: (value) {
            setState(() {
              values[i - 1] = !values[i - 1];
            });
          });
      ca = ListTile(
        leading: Checkbox(
          value: false,
          onChanged: (bool? value) {  },
        ),
        title: Text(i.toString()),
      );
      ex = Expanded(
        child: cb,
      );
      list.add(ex);
    }
    print(list);
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list
    );
  }
}
