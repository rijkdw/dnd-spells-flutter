import 'package:dnd_spells_flutter/screens/mainscreen.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/singletons.dart' as singletons;
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() {
//  singletons.initialiseSingletons();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchManager()),
        ChangeNotifierProvider(create: (_) => SpellRepository()),
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
