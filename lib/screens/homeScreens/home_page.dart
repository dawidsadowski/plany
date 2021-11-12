import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Strona główna"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: Text("Strona gówna"),
      ),
    );
  }
}
