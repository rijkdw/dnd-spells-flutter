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

  String get range => '';

  String get castingTime => '';

  String get duration => '';

  String get components => '';

  List<String> get classes => [];

  List<String> get description {
    List<dynamic> entries = map['entries'];
    List<String> entriesAsString = entries.map((e) => e.toString()).toList();
    return entriesAsString;
  }
}
