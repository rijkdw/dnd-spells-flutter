import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:flutter/foundation.dart';

class HistoryManager extends ChangeNotifier {

  int maxSpellsInHistory = 15;

  List<SpellView> _recentlyViewedSpells = [];
  List<SpellView> get recentlyViewedSpells => _recentlyViewedSpells.reversed.toList();

  void addToHistory(SpellView spellView) {
    bool wasRemoved = _recentlyViewedSpells.remove(spellView);
    _recentlyViewedSpells.add(spellView);
    if (_recentlyViewedSpells.length > maxSpellsInHistory) {
      _recentlyViewedSpells.removeAt(0);
    }
    // finally
    notifyListeners();
  }

  void removeFromHistory(SpellView spellView) {
    _recentlyViewedSpells.remove(spellView);
    notifyListeners();
  }

  void clearHistory() {
    _recentlyViewedSpells.clear();
    notifyListeners();
  }

}