import 'dart:convert';

import 'package:dnd_spells_flutter/models/characteroption.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CharacterOptionRepository extends ChangeNotifier {

  CharacterOptionRepository() {
    print('Constructing CharacterOptionRepository');
    _loadFromLocal();
  }

  Map<CharacterOption, List<CharacterOption>> classesToSubclassesMap = Map<CharacterOption, List<CharacterOption>>();
  Map<CharacterOption, List<CharacterOption>> racesToSubracesMap = Map<CharacterOption, List<CharacterOption>>();

  void poke() {
    print('CharacterOptionRepository poked');
  }

  List<String> get allClassNames {
    List<String> returnList = classesToSubclassesMap.keys.map((baseClass) => baseClass.name).toList();
    returnList.sort((a, b) => a.compareTo(b));
    return returnList;
  }

  List<CharacterOption> subclassesBelongingTo(String baseClassName) {
    for (CharacterOption characterOption in classesToSubclassesMap.keys.toList()) {
      if (characterOption.name == baseClassName) {
        return classesToSubclassesMap[characterOption];
      }
    }
    return null;
  }

  Map<String, List<String>> getClassNamesMap() {
    Map<String, List<String>> returnMap = {};
    for (CharacterOption class_ in classesToSubclassesMap.keys.toList()) {
      returnMap[class_.name] = [];
      for (CharacterOption subclass in classesToSubclassesMap[class_]) {
        returnMap[class_.name].add(subclass.name);
      }

    }
    return returnMap;
  }

  Map<String, String> getReverseClassNamesMap() {
    Map<String, List<String>> namesMap = getClassNamesMap();
    Map<String, String> reverseMap = Map<String, String>();
    for (String value in namesMap.keys.toList()) {
      for (String key in namesMap[value]) {
        reverseMap[key] = value;
      }
    }
    return reverseMap;
  }

  List<CharacterOption> listifyRaces() {
    List<CharacterOption> list = [];
    for (CharacterOption key in racesToSubracesMap.keys.toList()) {
      list.add(key);
      for (CharacterOption value in racesToSubracesMap[key]) {
        list.add(value);
      }
    }
    return list;
  }

  Map<String, CharacterOption> mapifyRaces() {
    Map<String, CharacterOption> map = {};
    for (CharacterOption characterOption in listifyRaces()) {
      map[characterOption.name] = characterOption;
    }
    return map;
  }

  List<CharacterOption> listifyClasses() {
    List<CharacterOption> list = [];
    for (CharacterOption key in classesToSubclassesMap.keys.toList()) {
      list.add(key);
      for (CharacterOption value in classesToSubclassesMap[key]) {
        list.add(value);
      }
    }
    return list;
  }

  Map<String, CharacterOption> mapifyClasses() {
    Map<String, CharacterOption> map = {};
    for (CharacterOption characterOption in listifyClasses()) {
      map[characterOption.name] = characterOption;
    }
    return map;
  }

  List<String> getAllRaceSubraceNameCombinations() {
    List<String> returnList = [];
    for (CharacterOption baseRace in racesToSubracesMap.keys.toList()) {
      if (racesToSubracesMap[baseRace].isEmpty)
        returnList.add(baseRace.name);
      for (CharacterOption subrace in racesToSubracesMap[baseRace]) {
        returnList.add('${baseRace.name} (${subrace.name})');
      }
    }
    return returnList;
  }

  List<String> getRaceNameSuggestions(String pattern) {
    pattern = pattern.toLowerCase();
    List<String> allNames = getAllRaceSubraceNameCombinations();
    List<String> suggestions = [];
    for (String name in allNames) {
      if (name.toLowerCase().contains(pattern)) {
        suggestions.add(name);
      }
    }
    suggestions.sort();
    return suggestions;
  }

  void _loadFromLocal() async {
    // load classes
    String classesJsonString = await rootBundle.loadString('assets/classes.json');
    List<dynamic> classesJsonList = json.decode(classesJsonString);
    for (dynamic baseClassMap in classesJsonList) {
      CharacterOption baseClass = CharacterOption.fromJson(baseClassMap);
      baseClass.characterOptionType = CharacterOptionType.class_;
      classesToSubclassesMap[baseClass] = [];
      for (dynamic subclassMap in baseClassMap['subclasses'] ?? []) {
        CharacterOption subclass = CharacterOption.fromJson(subclassMap);
        subclass.characterOptionType = CharacterOptionType.subclass;
        classesToSubclassesMap[baseClass].add(subclass);
      }
    }
    // load races
    String racesJsonString = await rootBundle.loadString('assets/races.json');
    List<dynamic> racesJsonList = json.decode(racesJsonString);
    for (dynamic baseRaceMap in racesJsonList) {
      CharacterOption baseRace = CharacterOption.fromJson(baseRaceMap);
      baseRace.characterOptionType = CharacterOptionType.race;
      racesToSubracesMap[baseRace] = [];
      for (dynamic subraceMap in baseRaceMap['subraces'] ?? []) {
        CharacterOption subrace = CharacterOption.fromJson(subraceMap);
        subrace.characterOptionType = CharacterOptionType.subrace;
        racesToSubracesMap[baseRace].add(subrace);
      }
    }
    notifyListeners();
  }

}