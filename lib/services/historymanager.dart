import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:flutter/foundation.dart';

class HistoryManager extends ChangeNotifier {

  int maxSpellsInHistory = 15;

  List<Spell> _recentlyViewedSpells = [];
  List<Spell> get recentlyViewedSpells => _recentlyViewedSpells.reversed.toList();

  void addToHistory(Spell spell) {
    bool wasRemoved = _recentlyViewedSpells.remove(spell);
    _recentlyViewedSpells.add(spell);
    if (_recentlyViewedSpells.length > maxSpellsInHistory) {
      _recentlyViewedSpells.removeAt(0);
    }
    notifyListeners();
  }

  void removeFromHistory(Spell spell) {
    _recentlyViewedSpells.remove(spell);
    notifyListeners();
  }

}