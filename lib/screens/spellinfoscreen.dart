import 'dart:math';

import 'package:dnd_spells_flutter/components/dicerollerpopup.dart';
import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SpellInfoScreen extends StatelessWidget {
  final Spell spell;
  SpellInfoScreen({@required this.spell});

  Widget _buildEntryLine(BuildContext context, String entry) {
    List<TextSpan> textSpanList = [];

    RegExp pattern = new RegExp(r'\b\d+d\d+\b');
    List<String> splits = entry.split(pattern).map((e) => e.toString()).toList();
    List<String> hits = pattern.allMatches(entry).map((e) => e.group(0)).toList();

    for (int i = 0; i < hits.length; i++) {
      textSpanList.add(TextSpan(
        text: splits[i],
      ));
      textSpanList.add(
        TextSpan(
          text: hits[i],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print('Tapped on ${hits[i]}');
              showDialog(
                context: context,
                builder: (context) => DiceRollerDialog(
                  dice: hits[i],
                ),
              );
            },
        ),
      );
    }
    textSpanList.add(TextSpan(
      text: splits.last,
    ));

    return RichText(
//      textAlign: TextAlign.justify,
      text: TextSpan(
        text: '',
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
        children: textSpanList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      drawer: SettingsDrawer(),
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 13,
            right: 13,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...[
                Text(
                  spell.name,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  spell.subtitle,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
              ],
              ...spell.description.map((entry) => _buildEntryLine(context, entry)).toList()
            ],
          ),
        ),
      ),
    );
  }
}

class SpellAttributeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
