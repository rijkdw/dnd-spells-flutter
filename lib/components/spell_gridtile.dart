import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpellGridTile extends StatelessWidget {
  final Spell spell;
  SpellGridTile({@required this.spell});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            color: Colors.grey[300],
            blurRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            spell.name,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            spell.subtitle,
            style: TextStyle(
//              fontStyle: FontStyle.italic,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8),

          // casting time
          Expanded(
            child: CompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.hourglassHalf, size: 14),
              content: spell.castingTime,
            ),
          ),

          // components
          Expanded(
            child: CompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.mortarPestle, size: 14),
              content: spell.vsm,
            ),
          ),

          // range
          Expanded(
            child: CompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.draftingCompass, size: 14),
              content: spell.range,
            ),
          ),

          // duration
          Expanded(
            child: CompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.hourglassEnd, size: 14),
              content: spell.duration,
            ),
          ),

          // classes
          Expanded(
            child: CompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.hatWizard, size: 14),
              content: spell.classes.join(', '),
            ),
          ),
        ],
      ),
    );
  }
}

class CompactSpellAttributeLine extends StatelessWidget {
  final Widget leading;
  final String content;

  CompactSpellAttributeLine({@required this.leading, @required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 22,
            child: leading,
          ),
          Text(
            content,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
