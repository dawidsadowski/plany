import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  bool _passwordHidden = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0),
                Text(
                  "Witaj ponownie",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Zaloguj się, aby kontynuować",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  validator: (val) => val!.isNotEmpty ? null : "Wprowadź adres e-mail.",
                  decoration: InputDecoration(
                    hintText: "E-mail",
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _passwordController,
                  validator: (val) => val!.length < 6 ? "Wprowadź więcej niż 6 znaków" : null,
                  obscureText: !_passwordHidden,
                  decoration: InputDecoration(
                      hintText: "Hasło",
                      prefixIcon: Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                          icon: Icon(_passwordHidden ? Icons.remove_red_eye_rounded : Icons.remove_red_eye_outlined ),
                          onPressed: () {
                            setState(() {
                              _passwordHidden = !_passwordHidden;
                            });
                      }),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                SizedBox(height: 30),
                MaterialButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()) { // TODO: Uwierzytelnianie
                      print("Email: ${_emailController.text}");
                      print("Email: ${_passwordController.text}");
                    }
                  },
                  height: 60,
                  minWidth: double.infinity,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Zaloguj się",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
