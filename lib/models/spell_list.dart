import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SpellList {

  String name;
  String className;
  String subclassName;
  String raceName;
  String subraceName;
  List<String> _spellNames = [];

  SpellList({@required this.name, spellNames, this.className:'', this.subclassName:'', this.raceName:'', this.subraceName:''}) {
    this._spellNames = List<String>.from(spellNames ?? []);
  }

  List<String> get spellNames {
    return this._spellNames.toList().map((name) => name).toList();
  }

  void setName(BuildContext context, String newName) {
    name = newName;
    Provider.of<SpellListManager>(context, listen: false).externalChangeMade();
  }

  String get subtitle {
    return '${this.className} (${this.subclassName})';
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
    'className': this.className,
    'subclassName': this.subclassName,
    'raceName': this.raceName,
    'subraceName': this.subraceName,
  };

  factory SpellList.fromJson(Map<String, dynamic> json) {
    return SpellList(
      name: json['name'],
      spellNames: List<String>.from(json['spellNames']),
      className: json['className'],
      subclassName: json['subclassName'],
      raceName: json['raceName'],
      subraceName: json['subraceName'],
    );
  }

}