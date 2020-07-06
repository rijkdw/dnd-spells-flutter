import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/foundation.dart';

class SpellView {
  String spellName;
  DateTime dateViewed;

  SpellView({@required this.spellName, @required this.dateViewed});

  factory SpellView.now({@required String spellName}) {
    return SpellView(
      dateViewed: DateTime.now(),
      spellName: spellName,
    );
  }

  // JSON

  Map<String, dynamic> toJson() => {
        'dateViewedEpochMilliseconds': dateViewed.millisecondsSinceEpoch,
        'spellName': spellName,
      };

  factory SpellView.fromJson(Map<String, dynamic> json) {
    return SpellView(
      spellName: json['spellName'],
      dateViewed: DateTime.fromMillisecondsSinceEpoch(json['dateViewedEpochMilliseconds']),
    );
  }

  String get historyTileTimestamp {
    if (isToday(dateViewed)) return '${getHHMM(dateViewed)} today';
    if (isYesterday(dateViewed)) return '${getHHMM(dateViewed)} yesterday';
    return getShortDay(dateViewed);
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! SpellView) return false;
    SpellView spellView = other;
    return spellView.spellName == this.spellName;
  }

  @override
  int get hashCode => super.hashCode;
}
