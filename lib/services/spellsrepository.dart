import 'dart:convert';

import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SpellRepository extends ChangeNotifier {

  List<Spell> _allSpells = [];
  Map<String, Spell> _nameToSpellMap = {};

  List<Spell> get allSpells => _allSpells.map((e) => e).toList();

  Spell getSpellFromName(String spellName) => _nameToSpellMap[spellName];

  List<String> get allClassNames {
    Set<String> allClassNamesSet = Set<String>();
    _allSpells.forEach((spell) {
      allClassNamesSet.addAll(spell.classesList);
    });
    classToSubclassMap.keys.forEach((className) {
      allClassNamesSet.add(className);
    });
    List<String> allClassNamesList = allClassNamesSet.toList();
    allClassNamesList.sort((a,b) => a.compareTo(b));
    return allClassNamesList;
  }

  List<String> get allSubclassNames {
    Set<String> allSubclassNamesSet = Set<String>();
    _allSpells.forEach((spell) {
      allSubclassNamesSet.addAll(spell.subclassesList);
    });
    List<String> allSubclassNamesList = allSubclassNamesSet.toList();
    allSubclassNamesList.sort((a,b) => a.compareTo(b));
    return allSubclassNamesList;
  }

  Map<String, List<String>> get classToSubclassMap {
    Map<String, List<String>> returnMap = {};
    allSubclassNames.forEach((classSubclass) {
      String className = extractClassAndSubclass(classSubclass)['class'];
      String subclassName = extractClassAndSubclass(classSubclass)['subclass'];
      if (!returnMap.containsKey(className))
        returnMap[className] = [];
      returnMap[className].add(subclassName);
    });
    return returnMap;
  }

  SpellRepository() {
    print('Constructing spellrepo');
    _loadSpellsFromLocal();
  }

  void _loadSpellsFromLocal() async {
    String jsonString = await rootBundle.loadString('assets/spells.json');
    List<dynamic> jsonList = json.decode(jsonString);
    _allSpells = jsonList.map((map) => Spell(map)).toList();
    _allSpells.forEach((spell) => _nameToSpellMap[spell.name] = spell);
    notifyListeners();
  }

}