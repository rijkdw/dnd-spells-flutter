enum CharacterOptionType { race, subrace, class_, subclass }

class CharacterOption {
  String name;
  CharacterOptionType characterOptionType;
  List<String> learnableSpellNames;
  List<String> alwaysPreparedSpellNames;

  CharacterOption({this.name, this.characterOptionType, this.learnableSpellNames, this.alwaysPreparedSpellNames});

  factory CharacterOption.fromJson(Map<String, dynamic> json) {
    return CharacterOption(
      name: json['name'] ?? 'UNNAMED',
      characterOptionType: json['type'] ?? null,
      learnableSpellNames: json['learnableSpells'] != null ? List<String>.from(json['learnableSpells']) : [],
      alwaysPreparedSpellNames: json['alwaysPreparedSpells'] != null ? List<String>.from(json['alwaysPreparedSpells']) : []
    );
  }
}
