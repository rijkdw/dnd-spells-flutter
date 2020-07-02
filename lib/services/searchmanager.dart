import 'dart:convert';

import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchManager extends ChangeNotifier {

  List<Spell> _allSpells = [];

  List<Spell> get searchResults => _allSpells;
  List<Spell> get allSpells => _allSpells;

  SearchManager() {
    _loadSpellsFromLocal();
  }

  void _loadSpellsFromLocal() async {
    String jsonString = await rootBundle.loadString('assets/spells.json');
    List<dynamic> jsonList = json.decode(jsonString);
    _allSpells = jsonList.map((map) => Spell(map)).toList();
    notifyListeners();
  }


}