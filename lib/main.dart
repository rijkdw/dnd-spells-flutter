import 'package:dnd_spells_flutter/screens/mainscreen.dart';
import 'package:dnd_spells_flutter/screens/pages/searchpage.dart';
import 'package:dnd_spells_flutter/services/appstatemanager.dart';
import 'package:dnd_spells_flutter/services/conditionrepository.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/material.dart';
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
        ChangeNotifierProvider(create: (_) => ConditionRepository()),
        ChangeNotifierProvider(create: (_) => AppStateManager()),
        ChangeNotifierProvider(create: (_) => SpellListManager()),
        ChangeNotifierProvider(create: (_) => HistoryManager()),
      ],
      child: MaterialApp(
        title: 'D&D 5e Spell Seeker',
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.white,
        ),
        home: MainScreen(),
      ),
    );
  }
}
