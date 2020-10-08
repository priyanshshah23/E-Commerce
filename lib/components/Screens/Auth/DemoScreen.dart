import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/Auth/SearchComponent.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatefulWidget {
  static const route = "DemoScreen";

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SearchComponent(
            title: "amount",
            min: 100,
            max: 300,
          ),
          SearchComponent(
            title: "data",
            min: 100,
            max: 300,
          ),
        ],
      ),
    );
  }
}
