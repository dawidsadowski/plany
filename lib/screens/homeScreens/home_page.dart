import 'package:delta_squad_app/services/authentication/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Strona główna"),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async => await loginProvider.logout(),
          )
        ],
      ),
      body: Center(
        child: Image.asset(
            'assets/logo.png',
            width: 200,
        ),
      ),
    );
  }
}
