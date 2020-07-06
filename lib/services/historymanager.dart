import 'dart:convert';

import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryManager extends ChangeNotifier {

  int maxSpellsInHistory = 15;

  List<SpellView> _recentlyViewedSpells = [];
  List<SpellView> get recentlyViewedSpells => _recentlyViewedSpells.reversed.toList();

  HistoryManager() {
    _loadFromLocal();
  }

  bool isInHistory(SpellView spellView) {
    return _recentlyViewedSpells.contains(spellView);
  }

  void addToHistory(SpellView spellView) {
    bool wasRemoved = _recentlyViewedSpells.remove(spellView);
    _recentlyViewedSpells.add(spellView);
    if (_recentlyViewedSpells.length > maxSpellsInHistory) {
      _recentlyViewedSpells.removeAt(0);
    }
    notifyListeners();
    _storeInLocal();
  }

  void removeFromHistory(SpellView spellView) {
    _recentlyViewedSpells.remove(spellView);
    notifyListeners();
    _storeInLocal();
  }

  void clearHistory() {
    _recentlyViewedSpells.clear();
    notifyListeners();
    _storeInLocal();
  }

  // Storage

  final String _keyHistoryStorage = 'spell_history';

  void _loadFromLocal() async {
    print('Loading view history from local');
    SharedPreferences.getInstance().then((prefs) {
      String historyJsonString = prefs.getString(_keyHistoryStorage) ?? '[]';
      List<dynamic> historyList = json.decode(historyJsonString);
      historyList.forEach((map) => _recentlyViewedSpells.add(SpellView.fromJson(map)));
      notifyListeners();
    });
  }

  void _storeInLocal() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyHistoryStorage, json.encode(_recentlyViewedSpells.map((e) => e.toJson()).toList()));
    print(prefs.getString(_keyHistoryStorage));
  }

}