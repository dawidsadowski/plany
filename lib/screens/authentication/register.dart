import 'package:delta_squad_app/services/authentication/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  final Function toggleScreen;

  Register({Key? key, required this.toggleScreen}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<AuthServices>(context);

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
                    "Rejestracja",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Utwórz konto, aby kontynuować",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Wprowadź imię",
                    decoration: InputDecoration(
                        label: Text("Imię"),
                        prefixIcon: Icon(Icons.perm_identity),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _surnameController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Wprowadź nazwisko",
                    decoration: InputDecoration(
                        label: Text("Nazwisko"),
                        prefixIcon: Icon(Icons.perm_identity),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                          // TODO: Uwierzytelnianie
                          print("Email: ${_emailController.text}");
                          print("Password: ${_passwordController.text}");

                          await registerProvider.register(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _nameController.text.trim(),
                            _surnameController.text.trim(),
                          );
                        }
                      },
                      height: 60,
                      minWidth:
                          registerProvider.isLoading ? null : double.infinity,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: registerProvider.isLoading
                          ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white))
                          : Text("Zarejestuj się",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Posiadasz już konto?"),
                      TextButton(
                          onPressed: () => widget.toggleScreen(),
                          child: Text("Zaloguj się"))
                    ],
                  ),
                  SizedBox(height: 20),
                  if (registerProvider.errorMessage != "_hidden")
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        color: Colors.amberAccent,
                        child: ListTile(
                            title: Text(registerProvider.errorMessage),
                            leading: Icon(Icons.error),
                            trailing: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () =>
                                  registerProvider.setMessage(null),
                            )
                        )
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
