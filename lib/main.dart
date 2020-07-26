import 'package:dnd_spells_flutter/screens/mainscreen.dart';
import 'package:dnd_spells_flutter/screens/pages/searchpage.dart';
import 'package:dnd_spells_flutter/services/appstatemanager.dart';
import 'package:dnd_spells_flutter/services/characteroptionrepository.dart';
import 'package:dnd_spells_flutter/services/conditionrepository.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
//  singletons.initialiseSingletons();
  runApp(DnD5eSpellsApp());
}

GlobalKey appKey = GlobalKey();

class DnD5eSpellsApp extends StatelessWidget {
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
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => CharacterOptionRepository())
      ],
      child: Consumer<ThemeManager>(
        child: MainScreen(),
        builder: (context, themeManager, child) {
          Provider.of<CharacterOptionRepository>(context, listen: false).poke();
          return MaterialApp(
            key: appKey,
            title: 'D&D 5e Spell Seeker',
            theme: ThemeData(
              textTheme: TextTheme(
                bodyText2: TextStyle(
                  color: themeManager.colorPalette.mainTextColor,
                ),
              ),
              dividerColor: themeManager.colorPalette.tableLineColor,
              chipTheme: ChipTheme.of(context).copyWith(
                backgroundColor: themeManager.colorPalette.chipUnselectedColor,
                selectedColor: themeManager.colorPalette.chipSelectedColor,
                labelStyle: TextStyle(color: themeManager.colorPalette.chipUnselectedTextColor),
                secondaryLabelStyle: TextStyle(color: themeManager.colorPalette.chipSelectedTextColor),
                secondarySelectedColor: themeManager.colorPalette.chipSelectedColor,
                checkmarkColor: themeManager.colorPalette.mainTextColor,
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: themeManager.colorPalette.buttonColor,
//                colorScheme: ColorScheme.fromSwatch(
//                  backgroundColor: themeManager.colorPalette.buttonColor,
//                ),
                focusColor: themeManager.colorPalette.buttonColor,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: themeManager.colorPalette.buttonColor,
                foregroundColor: themeManager.colorPalette.buttonTextColor,
              ),
              primaryColor: themeManager.colorPalette.appBarBackgroundColor,
              accentColor: themeManager.colorPalette.navBarSelectedColor,
              canvasColor: themeManager.colorPalette.brightness == Brightness.light ? Colors.white : Color.fromRGBO(20, 20, 20, 1),
            ),
            home: child,
          );
        },
      ),
    );
  }
}
