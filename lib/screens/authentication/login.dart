import 'package:delta_squad_app/services/authentication/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  final Function toggleScreen;

  Login({Key? key, required this.toggleScreen}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

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
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Logowanie",
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
                    validator: (val) =>
                        val!.isNotEmpty ? null : "Wprowadź adres e-mail",
                    decoration: InputDecoration(
                        label: Text("E-mail"),
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController,
                    validator: (val) =>
                        val!.length < 6 ? "Wprowadź więcej niż 6 znaków" : null,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        label: Text("Hasło"),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          print("Email:    ${_emailController.text}");
                          print("Password: ${_passwordController.text}");
                          await loginProvider.loginWithEmail(
                              _emailController.text.trim(),
                              _passwordController.text.trim());
                        }
                      },
                      height: 60,
                      minWidth: double.infinity,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: loginProvider.isLoading
                          ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white))
                          : Text("Zaloguj się",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nie posiadasz konta?"),
                      TextButton(
                          onPressed: () => widget.toggleScreen(),
                          child: Text("Zarejestruj się"))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SignInButton(
                            Buttons.Google,
                            text: "Zaloguj się z Google",
                            onPressed: () => loginProvider.loginWithGoogle(),
                          ),
                          SignInButton(
                            Buttons.Facebook,
                            text: "Zaloguj się z Facebook",
                            onPressed: () => loginProvider.loginWithFacebook(),
                          ),
                        ],
                      ),
                    ],
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
