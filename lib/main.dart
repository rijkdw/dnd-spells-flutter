import 'package:dnd_spells_flutter/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D 5e Spell Seeker',
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.white,
      ),
      home: MainScreen(),
    );
  }
}
