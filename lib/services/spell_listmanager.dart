import 'dart:convert';

import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SpellListCreateActionResult{ success, nameError }

class SpellListManager extends ChangeNotifier {
  List<SpellList> spellLists = [];

  SpellListManager() {
    _loadFromLocal();
  }

  SpellListCreateActionResult createSpellList(String name) {
    for (SpellList spellList in spellLists) {
      if (spellList.name.toLowerCase() == name.toLowerCase())
        return
          SpellListCreateActionResult.nameError;
    }
    spellLists.add(SpellList(
      name: name,
      spellNames: [],
    ));
    _storeInLocal();
    notifyListeners();
    return SpellListCreateActionResult.success;
  }

  // Storage

  final String _keyListStorage = 'spell_lists';

  void externalChangeMade() {
    _storeInLocal();
    notifyListeners();
  }

  void _loadFromLocal() async {
    print('Loading spell lists from local');
    SharedPreferences.getInstance().then((prefs) {
      String listJsonString = prefs.getString(_keyListStorage) ?? '[]';
      List<dynamic> listList = json.decode(listJsonString);
      listList.forEach((map) => spellLists.add(SpellList.fromJson(map)));
      notifyListeners();
    });
  }

  void _storeInLocal() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyListStorage, json.encode(spellLists.map((e) => e.toJson()).toList()));
  }
}
