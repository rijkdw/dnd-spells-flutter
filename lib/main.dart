import 'package:dnd_spells_flutter/screens/mainscreen.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchManager()),
      ],
      child: MaterialApp(
        title: 'D&D 5e Spell Seeker',
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.white,
        ),
        home: MainScreen(),
      ),
    );
  }
}
