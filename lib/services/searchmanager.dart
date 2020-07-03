import 'dart:convert';

import 'package:dnd_spells_flutter/main.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/singletons.dart' as singletons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchManager extends ChangeNotifier {

  List<Spell> _allSpells = [];

  List<Spell> get searchResults => singletons.spellRepository.allSpells;

}