import 'package:dnd_spells_flutter/models/spell.dart';
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
}
