import 'package:dnd_spells_flutter/components/quicksearchbottomsheet.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:flutter/material.dart';

class SearchManager extends ChangeNotifier {
  String _nameToken = '';
  set nameToken(String newToken) {
    _nameToken = newToken;
    notifyListeners();
  }
  String get nameToken => _nameToken;

  String _descriptionToken = '';
  set descriptionToken(String newToken) {
    _descriptionToken = newToken;
    notifyListeners();
  }
  String get descriptionToken => _descriptionToken;

  QuickSearchSelection _lastSelection = QuickSearchSelection.name;
  QuickSearchSelection get lastSelection => _lastSelection;

  void quickSearch(String token, QuickSearchSelection selection) {
    print('SearchManager quicksearching for $token as ${selection.toString()}');
    // determine which changed:  token or selection (can only be one)
    if (_lastSelection != selection) {  // selection changed
      // reset both values without notifying listeners
      _nameToken = '';
      _descriptionToken = '';
      _lastSelection = selection;
    }

    switch (selection) {
      case QuickSearchSelection.name:
        nameToken = token;
        break;
      case QuickSearchSelection.description:
        descriptionToken = token;
        break;
    }

  }

  List<Spell> filterSpells(List<Spell> spellsToFilter) {
    List<Spell> filteredSpells = List.from(spellsToFilter);
    spellsToFilter.forEach((spell) {
      if (!spell.name.toLowerCase().contains(_nameToken.toLowerCase())) filteredSpells.remove(spell);
      // only if there's a description token
      if (_descriptionToken.isNotEmpty) {
        if (!spell.doesDescriptionContain(_descriptionToken)) {
          filteredSpells.remove(spell);
        }
      }
    });
    return filteredSpells;
  }
}
