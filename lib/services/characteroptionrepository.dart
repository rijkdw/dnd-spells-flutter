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
  Map<CharacterOption, List<CharacterOption>> racesToSubraceMap = Map<CharacterOption, List<CharacterOption>>();

  void poke() {
    print('CharacterOptionRepository poked');
  }

  List<String> get allClassNames {
    List<String> returnList = classesToSubclassesMap.keys.map((baseClass) => baseClass.name).toList();
    returnList.sort((a, b) => a.compareTo(b));
    return returnList;
  }

  List<CharacterOption> subclassesBelongingTo(String name) {
    for (CharacterOption characterOption in classesToSubclassesMap.keys.toList()) {
      if (characterOption.name == name) {
        return classesToSubclassesMap[characterOption];
      }
    }
    return null;
  }

  Map<String, List<String>> getNamesMap() {
    Map<String, List<String>> returnMap = {};
    for (CharacterOption class_ in classesToSubclassesMap.keys.toList()) {
      returnMap[class_.name] = [];
      for (CharacterOption subclass in classesToSubclassesMap[class_]) {
        returnMap[class_.name].add(subclass.name);
      }

    }
    return returnMap;
  }

  Map<String, String> getReverseNamesMap() {
    Map<String, List<String>> namesMap = getNamesMap();
    Map<String, String> reverseMap = Map<String, String>();
    for (String value in namesMap.keys.toList()) {
      for (String key in namesMap[value]) {
        reverseMap[key] = value;
      }
    }
    return reverseMap;
  }

  void _loadFromLocal() async {
    String classesJsonString = await rootBundle.loadString('assets/classes.json');
    List<dynamic> classesJsonList = json.decode(classesJsonString);
    for (dynamic baseClassMap in classesJsonList) {
      CharacterOption baseClass = CharacterOption.fromJson(baseClassMap);
      baseClass.characterOptionType = CharacterOptionType.class_;
      classesToSubclassesMap[baseClass] = [];
      for (dynamic subclassMap in baseClassMap['subclasses']) {
        CharacterOption subclass = CharacterOption.fromJson(subclassMap);
        classesToSubclassesMap[baseClass].add(subclass);
      }
    }
    notifyListeners();
  }

}