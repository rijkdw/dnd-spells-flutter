import 'dart:convert';

import 'package:dnd_spells_flutter/utilities/utils.dart';

class Spell {
  final dynamic map;
  Spell(this.map);

  String get name => map['name'];

  String get subtitle {
    // eg. Evocation cantrip
    if (map['level'] == 0) return '${capitaliseFirst('${map['school']} cantrip')}';
    // eg. 1st-level evocation
    return '${ordinal(map['level'])}-level ${map['school'].toString().toLowerCase()}';
  }

  // TODO: fix range
  String get range => '30 feet';

  // TODO: fix casting time
  String get castingTime => '1 action';

  // TODO: fix duration
  String get duration => '1 hour';

  // TODO: fix components
  String get components => 'VSM (a cup of bat guano and a cup of sulphur)';

  // TODO: fix classes
  List<String> get classes => ['Wizard', 'Sorcerer', 'Warlock'];

  List<dynamic> get description {
    List<dynamic> entries = map['entries'];
    List<dynamic> entriesAsString = entries.map((e) {
      if (e is String)
        return e;
      else
        return Map<String, dynamic>.from(e);
    }).toList();
    return entriesAsString;
  }

  List<String> get inflictsConditions {
    List<String> conditions = List<String>.from(map['conditionInflict'] ?? []);
    return conditions;
  }
}
