import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/quicksearchbottomsheet.dart';
import 'package:dnd_spells_flutter/main.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchManager extends ChangeNotifier {
  Map<String, List<String>> _currentSearchParameters = {};
  Map<String, List<String>> get currentSearchParameters => _currentSearchParameters;
  set currentSearchParameters(newCurrentSearchParameters) {
    _currentSearchParameters = newCurrentSearchParameters;
    notifyListeners();
  }

  // sorting

  OrderBy _orderBy = OrderBy.name;
  OrderBy get orderBy => _orderBy;
  set orderBy(OrderBy newOrderBy) {
    _orderBy = newOrderBy;
    notifyListeners();
  }

  // filtering

  List<Spell> filterSpells(List<Spell> spells, Map<String, List<String>> searchParametersMap) {
    _currentSearchParameters = searchParametersMap;

    dynamic searchParameterKeyToSpellField(Spell spell, String key) {
      switch (key) {
        case 'classes':
          return spell.classesList;
        case 'subclasses':
          return spell.subclassesList;
        case 'school':
          return spell.school;
        case 'level':
          return spell.levelSearchable;
      }
    }

    List<String> toList(dynamic value) {
      if (value is List) return List<String>.from(value);
      if (value is String) return [value];
      return [];
    }

    List<Spell> results = spells.map((e) => e).toList();
    results.retainWhere((spell) {
      print(spell.name);
      List<bool> results = [];
      List<String> keys = searchParametersMap.keys.where((key) => searchParametersMap[key].length > 0).toList();
      print(keys);
      for (String key in keys) {
        List<String> searchParameters = searchParametersMap[key];
        print(searchParameters);
        List<String> spellValues = toList(searchParameterKeyToSpellField(spell, key));
        print(spellValues);
        List<String> intersect = List<String>.from(intersection([searchParameters, spellValues]));
        print('Intersection: $intersect');
        results.add(intersect.length > 0);
      }
      return !results.contains(false);
    });
    return results;
  }

  Map<String, List<String>> get allSearchOptions {
    // initialise the options map
    Map<String, Set<dynamic>> optionsAsSet = {};
    List<String> keys = ['classes', 'subclasses', 'level', 'components', 'casting time', 'range', 'duration', 'school', 'source'];
    keys.forEach((key) {
      optionsAsSet[key] = Set<String>();
    });

    SpellRepository spellRepository = Provider.of<SpellRepository>(appKey.currentContext, listen: false);
    spellRepository.allSpells.forEach((spell) {
      optionsAsSet['source'].add(spell.shortSource);
      optionsAsSet['casting time'].addAll(spell.castingTimesSearchables);
      optionsAsSet['range'].add(spell.rangeSearchable);
      optionsAsSet['duration'].addAll(spell.durationSearchables);
      optionsAsSet['classes'].addAll(spell.classesList);
      optionsAsSet['subclasses'].addAll(spell.subclassesList);
      optionsAsSet['school'].add(spell.school);
    });

    optionsAsSet['components'] = ['V', 'S', 'M'].toSet();
    optionsAsSet['ritual'] = ['yes', 'no'].toSet();
    optionsAsSet['concentration'] = ['yes', 'no'].toSet();
    optionsAsSet['level'] = ['Cantrip', ...List.generate(9, (index) => (index + 1).toString())].toSet();

    Map<String, List<String>> optionsAsList = {};
    optionsAsSet.keys.toList().forEach((key) {
      optionsAsList[key] = optionsAsSet[key].toList();
      optionsAsList[key].sort();
      optionsAsList[key].removeWhere((option) => option.contains('(Revised)'));
    });
    optionsAsList['level'] = ['Cantrip', ...List.generate(9, (index) => (index + 1).toString())];
    optionsAsList['ritual'] = ['yes', 'no'];
    optionsAsList['concentration'] = ['yes', 'no'];
    return optionsAsList;
  }

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

  bool get isFiltered => _nameToken.isNotEmpty || _descriptionToken.isNotEmpty;

  void clearFilters() {
    _nameToken = '';
    _descriptionToken = '';
    notifyListeners();
  }

  void quickSearch(String token, QuickSearchSelection selection) {
    token = token.trim();
    print('SearchManager quicksearching for \"$token\" as ${selection.toString()}');
    // determine which changed:  token or selection (can only be one)
    if (_lastSelection != selection) {
      // selection changed
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

  List<Spell> quickSearchSpells(List<Spell> spellsToFilter) {
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
