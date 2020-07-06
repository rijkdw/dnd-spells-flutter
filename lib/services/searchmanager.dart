import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/singletons.dart' as singletons;
import 'package:flutter/material.dart';

class SearchManager extends ChangeNotifier {

  List<Spell> filterSpells(List<Spell> spellsToFilter) {
    return spellsToFilter;
  }

}