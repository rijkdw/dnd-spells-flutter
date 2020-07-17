import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SpellList {

  String name;
  List<String> _spellNames = [];

  SpellList({@required this.name, @required spellNames}) {
    this._spellNames = List<String>.from(spellNames);
  }

  List<String> get spellNames {
    return this._spellNames.toList().map((name) => name).toList();
  }

  void addSpellToList(BuildContext context, Spell spell) {
    this._spellNames.add(spell.name);
    this._spellNames = this._spellNames.toSet().toList();
    Provider.of<SpellListManager>(context, listen: false).externalChangeMade();
  }

  void removeSpellFromList(BuildContext context, Spell spell) {
    this._spellNames.remove(spell.name);
    Provider.of<SpellListManager>(context, listen: false).externalChangeMade();
  }

  // JSON

  Map<String, dynamic> toJson() => {
    'name': name,
    'spellNames': spellNames,
  };

  factory SpellList.fromJson(Map<String, dynamic> json) {
    return SpellList(
      name: json['name'],
      spellNames: List<String>.from(json['spellNames'])
    );
  }

}