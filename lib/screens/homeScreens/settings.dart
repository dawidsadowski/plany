import 'package:delta_squad_app/screens/homeScreens/group_settings.dart';
import 'package:flutter/material.dart';
import 'change_password.dart';

class SettingsView extends StatefulWidget{
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ustawienia"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Image(
                    image:  AssetImage('assets/logo.png')
                ),
                SizedBox(height: 30),
                SizedBox(height: 30),
                MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text('Dołącz do grupy'),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GroupSettings()),
                    );
                  },
                ),
                SizedBox(height: 30),
                MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text('Zmień hasło'),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ChangePassword()),
                    );
                  },
                ),
                SizedBox(height: 30),
                MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text('Eksportuj plan do kalendarza'),
                  onPressed: (){
                    //Navigator.pop(context);
                  },
                ),
                SizedBox(height: 30),
                MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text('Udostępnij swój plan'),
                  onPressed: (){
                    //Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }
}