import 'package:flutter/material.dart';
import '/screens/authentication/login.dart';
import 'schedule.dart';
import 'settings.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strona domowa',
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                        image:  AssetImage('assets/logo.png')
                    ),
                    SizedBox(height: 30),
                    const Text(
                      "User.name User.surname",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    const Text(
                      "Wydział XXX\n Kierunek YYY\n Grupa ZZZ",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                      child: const Text('Przejdź do planu'),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Schedule()),
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
                      child: const Text('Ustawienia'),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Settings()),
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
                      child: const Text('Wyloguj się'),
                      onPressed: (){
                        Navigator.pop(context);
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
}