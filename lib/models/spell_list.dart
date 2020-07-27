import 'package:dnd_spells_flutter/main.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/characteroptionrepository.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

abstract class AbstractSpellList extends ChangeNotifier {
  // the list's name
  String _name;

  void addSpellToList(String spellName);
  void removeSpellFromList(String spellName);
  Map<String, dynamic> toJson();

  @override
  void notifyListeners() {
    Provider.of<SpellListManager>(appKey.currentContext, listen: false).externalChangeMade();
    super.notifyListeners();
  }

  AbstractSpellList({String name}) {
    this._name = name;
  }

  set name(String newName) {
    name = newName;
    notifyListeners();
  }

  String get name => _name;
}

class GenericSpellList extends AbstractSpellList {
  List<String> spellNames;

  GenericSpellList({String name, List<String> spellNames}) : super(name: name ?? 'SPELL LIST') {
    this.spellNames = spellNames ?? [];
  }

  @override
  void addSpellToList(String spellName) {
    spellNames.add(spellName);
  }

  @override
  void removeSpellFromList(String spellName) {
    spellNames.remove(spellName);
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO
    return {};
  }

  factory GenericSpellList.fromJson(Map<String, dynamic> json) {
    return GenericSpellList(
      spellNames: safeListMaker(json['spellNames']),
    );
  }
}

class CharacterSpellList extends AbstractSpellList {
  // character options
  List<String> classNames;
  List<String> subclassNames;
  String raceName;
  String subraceName;

  // spell info
  int saveDC;
  int spellAttackBonus;
  int numberOfSpellsToPrep;

  // spell list
  List<String> spellNames;

  CharacterSpellList({String name, List<String> spellNames, this.classNames, this.subclassNames, this.raceName, this.subraceName})
      : super(name: name) {
    this.spellNames = spellNames ?? [];
  }

  void setName(BuildContext context, String newName) {
    name = newName;
    notifyListeners();
  }

  String get subtitle {
    String returnText = '';
    List<String> classTokens = [];
    CharacterOptionRepository characterOptionRepository = Provider.of<CharacterOptionRepository>(appKey.currentContext, listen: false);
    Map<String, List<String>> namesMap = characterOptionRepository.getClassNamesMap();
    for (String baseClass in classNames) {
      bool added = false;
      for (String subclass in subclassNames) {
        if ((namesMap[baseClass] ?? []).contains(subclass)) {
          classTokens.add('$baseClass ($subclass)');
          added = true;
        }
      }
      if (!added) classTokens.add(baseClass);
    }
//    return classTokens.join('  •  ');
    if (subraceName != '' && subraceName != null)
      classTokens.add('$raceName ($subraceName)');
    else
      classTokens.add('$raceName');
    return classTokens.join(' • ');
  }

  @override
  void addSpellToList(String spellName) {
    notifyListeners();
  }

  void removeSpellFromList(String spellName) {
    notifyListeners();
  }

  // JSON

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': 'character',
        'spellNames': this.spellNames,
        'className': this.classNames,
        'subclassName': this.subclassNames,
        'raceName': this.raceName,
        'subraceName': this.subraceName,
      };

  factory CharacterSpellList.fromJson(Map<String, dynamic> json) {
    return CharacterSpellList(
      name: json['name'],
      spellNames: safeListMaker(json['spellNames']),
      classNames: safeListMaker(json['className']),
      subclassNames: safeListMaker(json['subclassName']),
      raceName: json['raceName'],
      subraceName: json['subraceName'],
    );
  }
}

List<String> safeListMaker(dynamic value) {
  if (value != null) return List<String>.from(value);
  return [];
}
