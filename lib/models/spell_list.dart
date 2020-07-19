import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SpellList {

  String _name;
  String _className;
  String _subclassName;
  String _raceName;
  String _subraceName;
  List<String> _spellNames = [];

  SpellList({@required name, spellNames, className:'', subclassName:'', raceName:'', subraceName:''}) {
    this._name = name;
    this._spellNames = List<String>.from(spellNames ?? []);
    this._className = className;
    this._subclassName = subclassName;
    this._raceName = raceName;
    this._subraceName = subraceName;
  }

  List<String> get spellNames {
    return this._spellNames.toList().map((name) => name).toList();
  }

  String get name => _name;
  void setName(BuildContext context, String newName) {
    _name = newName;
    Provider.of<SpellListManager>(context, listen: false).externalChangeMade();
  }

  String get subtitle {
    return '${this._className} (${this._subclassName})';
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