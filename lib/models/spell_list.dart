import 'package:dnd_spells_flutter/main.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/characteroptionrepository.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

abstract class AbstractSpellList extends ChangeNotifier {
  // the list's name
  String _name;

  void addSpellToList(String spellName);
  void removeSpellFromList(String spellName);
  List<String> get spellNames;
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

//

class GenericSpellList extends AbstractSpellList {
  List<String> _spellNames;

  GenericSpellList({String name, List<String> spellNames}) : super(name: name ?? 'SPELL LIST') {
    this._spellNames = spellNames ?? [];
  }

  @override
  void addSpellToList(String spellName) {
    _spellNames.add(spellName);
  }

  @override
  void removeSpellFromList(String spellName) {
    _spellNames.remove(spellName);
  }

  @override
  List<String> get spellNames => _spellNames;

  // JSON

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': 'generic',
        'spellNames': this._spellNames,
      };

  factory GenericSpellList.fromJson(Map<String, dynamic> json) {
    return GenericSpellList(
      name: json['name'],
      spellNames: safeStrListMaker(json['spellNames']),
    );
  }
}

//

class CharacterSpellList extends AbstractSpellList {
  // character options
  List<String> classNames;
  List<String> subclassNames;
  String raceName;
  String subraceName;

  // spell info
  int _saveDC;
  int _spellAttackBonus;
  int _numSpellsPrepared;
  
  set saveDC(int newValue) {
    _saveDC = newValue;
    print('Save DC set as $newValue');
    notifyListeners();
  }
  
  set spellAttackBonus(int newValue) {
    _spellAttackBonus = newValue;
    print('Spell bonus set as $newValue');
    notifyListeners();
  }
  
  set numSpellsPrepared(int newValue) {
    _numSpellsPrepared = newValue;
    print('Num spells set as $newValue');
    notifyListeners();
  }

  int get saveDC => _saveDC;
  int get spellAttackBonus => _spellAttackBonus;
  int get numSpellsPrepared => _numSpellsPrepared;

  // spell list
  List<String> _spellNames;

  // spell slots
  Map<int, int> _maxSpellSlots;
  Map<int, int> _currentSpellSlots;

  Map<int, int> get maxSpellSlots => _maxSpellSlots;
  Map<int, int> get currentSpellSlots => _currentSpellSlots;

  CharacterSpellList(
      {String name,
      this.classNames,
      this.subclassNames,
      this.raceName,
      this.subraceName,
      saveDC: 8,
      spellAttackBonus: 0,
      numSpellsPrepared: 0,
      List<String> spellNames,
      Map<int, int> maxSpellSlots,
      Map<int, int> currentSpellSlots})
      : super(name: name) {
    this._spellNames = spellNames ?? [];
    this._maxSpellSlots = maxSpellSlots ?? getEmptySpellSlotMap();
    this._currentSpellSlots = currentSpellSlots ?? getEmptySpellSlotMap();
    this._saveDC = saveDC;
    this._numSpellsPrepared = numSpellsPrepared;
    this._spellAttackBonus = spellAttackBonus;
  }

  void setName(BuildContext context, String newName) {
    name = newName;
    notifyListeners();
  }

  // Spell slot methods

  bool spendSpellSlotOfLevel(int level) {
    if (_currentSpellSlots[level] < 1) {
      notifyListeners();
      return false;
    }
    _currentSpellSlots[level]--;
    notifyListeners();
    return true;
  }

  void setMaxSlotsAtLevel({int level, int max}) {
    _maxSpellSlots[level] = max;
    _currentSpellSlots[level] = max-2; // TODO take this out
    notifyListeners();
  }

  void resetSpellSlots() {
    for (int level in List.generate(9, (index) => index)) {
      _currentSpellSlots[level] = _maxSpellSlots[level];
    }
  }

  List<String> get spellNames => _spellNames;

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
        'spellNames': this._spellNames,
        'className': this.classNames,
        'subclassName': this.subclassNames,
        'raceName': this.raceName,
        'subraceName': this.subraceName,
        'maxSpellSlots': _maxSpellSlots.keys.toList().map((key) => _maxSpellSlots[key]).toList(),
        'currentSpellSlots': _currentSpellSlots.keys.toList().map((key) => _currentSpellSlots[key]).toList(),
        'saveDC': _saveDC.toString(),
        'attackBonus': _spellAttackBonus.toString(),
        'numSpellsPrepared': _numSpellsPrepared.toString()
      };

  factory CharacterSpellList.fromJson(Map<String, dynamic> json) {
    return CharacterSpellList(
      name: json['name'],
      spellNames: safeStrListMaker(json['spellNames']),
      classNames: safeStrListMaker(json['className']),
      subclassNames: safeStrListMaker(json['subclassName']),
      raceName: json['raceName'],
      subraceName: json['subraceName'],
      currentSpellSlots: listToSpellSlotMap(safeIntListMaker(json['currentSpellSlots'])),
      maxSpellSlots: listToSpellSlotMap(safeIntListMaker(json['maxSpellSlots'])),
      numSpellsPrepared: int.parse(json['numSpellsPrepared'] ?? '0'),
      saveDC: int.parse(json['saveDC'] ?? '0'),
      spellAttackBonus: int.parse(json['attackBonus'] ?? 0),
    );
  }
}

List<String> safeStrListMaker(dynamic value) {
  if (value != null) return List<String>.from(value);
  return [];
}

List<int> safeIntListMaker(dynamic value) {
  if (value != null) return List<int>.from(value);
  return [];
}
