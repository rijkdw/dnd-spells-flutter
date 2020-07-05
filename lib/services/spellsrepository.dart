import 'dart:convert';

import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SpellRepository extends ChangeNotifier {

  List<Spell> _allSpells = [];
  Map<String, Spell> _nameToSpellMap = {};

  List<Spell> get allSpells => _allSpells.map((e) => e).toList();

  Spell getSpellFromName(String spellName) => _nameToSpellMap[spellName];

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