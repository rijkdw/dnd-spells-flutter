import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/foundation.dart';

class SpellView {
  Spell spell;
  DateTime dateViewed;

  SpellView({@required this.spell, @required this.dateViewed});

  factory SpellView.now({@required Spell spell}) {
    return SpellView(
      dateViewed: DateTime.now(),
      spell: spell,
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
    return spellView.spell == this.spell;
  }

  @override
  int get hashCode => super.hashCode;
}
