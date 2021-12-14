import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _newPasswordCheckController;
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _newPasswordCheckController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordCheckController.dispose();
    super.dispose();
  }

  showInfoDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Zmiana hasła"),
      content: Text("Zmieniono hasło"),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  showConfirmDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Anuluj"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Zmień hasło",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        _changePassword();

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Zmiana hasła"),
      content: Text("Czy chcesz zmienić hasło?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _changePassword() async {

      print(firebaseAuth.currentUser!.email!);
      print(_oldPasswordController.text);
      User? user = firebaseAuth.currentUser;
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: firebaseAuth.currentUser!.email!,
        password: _oldPasswordController.text,
      );


     user?.updatePassword(_newPasswordController.text).then((value) {
       showInfoDialog(context);
     });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zmiana hasła"),
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
                    controller: _oldPasswordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        label: Text("Stare hasło"),
                        prefixIcon: const Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        label: Text("Nowe hasło"),
                        prefixIcon: Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            icon: Icon(_passwordVisible
                                ? Icons.remove_red_eye_rounded
                                : Icons.remove_red_eye_outlined),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _newPasswordCheckController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        label: Text("Powtórz nowe hasło"),
                        prefixIcon: Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            icon: Icon(_passwordVisible
                                ? Icons.remove_red_eye_rounded
                                : Icons.remove_red_eye_outlined),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                      onPressed: () {
                        //todo: logika i backend
                        showConfirmDialog(context);
                      },
                      height: 60,
                      minWidth: double.infinity,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("Zmień hasło",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}