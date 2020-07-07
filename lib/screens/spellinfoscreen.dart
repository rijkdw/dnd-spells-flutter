import 'dart:math';

import 'package:dnd_spells_flutter/components/conditionpopup.dart';
import 'package:dnd_spells_flutter/components/dicerollerpopup.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SpellInfoScreen extends StatelessWidget {
  final Spell spell;
  SpellInfoScreen({@required this.spell});

  bool _isDiceString(String input) {
    return RegExp(r'\b\d*d\d+\b').allMatches(input).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    /// Split a String into sometimes tappable textspans
    List<InlineSpan> buildTextSpanChildren(String text) {
      List<TextSpan> textSpanList = [];

      String conditionsRegex = '';
      spell.inflictsConditions.forEach((condition) => conditionsRegex += '|$condition');
      RegExp pattern = new RegExp(r'\b(\d*d\d+' + conditionsRegex + r')\b');
      List<String> splits = text.split(pattern).map((e) => e.toString()).toList();
      List<String> hits = pattern.allMatches(text).map((e) => e.group(0)).toList();

      for (int i = 0; i < hits.length; i++) {
        textSpanList.add(TextSpan(
          text: splits[i],
        ));
        textSpanList.add(
          TextSpan(
            text: hits[i],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Provider.of<ThemeManager>(context).colorPalette.clickableTextLinkColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showDialog(
                  context: context,
                  builder: (context) {
                    // if dice string, show a dice roller
                    if (_isDiceString(hits[i]))
                      return DiceRollerDialog(
                        dice: hits[i][0] == 'd' ? '1${hits[i]}' : hits[i],
                      );
                    // if condition string, show condition popup
                    else {
                      return ConditionPopup(
                        conditionName: hits[i],
                      );
                    }
                  },
                );
              },
          ),
        );
      }
      textSpanList.add(TextSpan(
        text: splits.last,
      ));
      return textSpanList;
    }

    /// Build a richtext from a String
    Widget buildRichText(List<InlineSpan> children, {double fontsize: 18}) {
      return RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: fontsize,
                fontWeight: FontWeight.normal,
              ),
          children: children,
        ),
      );
    }

    Widget mapToEntries(Map<String, dynamic> map) {
      // get the list of entries
      String name = map['name'];
      List<dynamic> entries = map['entries'];
      List<String> entriesAsStrings = entries.map((e) => e.toString()).toList();
      // format the text
      List<InlineSpan> entryTextSpans = buildTextSpanChildren(entriesAsStrings.join('\n'));
      // make the text spans and return it as a richtext
      List<InlineSpan> allTextSpans = [
        TextSpan(text: '$name: ', style: TextStyle(fontWeight: FontWeight.bold)),
        ...entryTextSpans,
      ];
      return buildRichText(allTextSpans);
    }

    Widget mapToList(Map<String, dynamic> map) {
      // get the list of items
      List<dynamic> items = map['items'];
      List<String> itemsAsStrings = items.map((e) => e.toString()).toList();
      // add a linebreak to each one except the last, for formatting
      for (int i = 0; i < itemsAsStrings.length - 1; i++) itemsAsStrings[i] = itemsAsStrings[i] + '\n';
      // for each item in the list of items
      List<InlineSpan> allTextSpans = [];
      itemsAsStrings.forEach((item) {
        // add the bullet
        allTextSpans.add(
//          WidgetSpan(child: Icon(Icons.keyboard_arrow_right, size: 20)),
            TextSpan(text: '\u2022  ', style: TextStyle(fontWeight: FontWeight.bold)));
        // add the item's text
        buildTextSpanChildren(item).forEach((textspan) => allTextSpans.add(textspan));
      });
      return buildRichText(allTextSpans);
    }

    Widget mapToTable(Map<String, dynamic> map) {
      Widget buildContainer(Widget child) => Container(
            padding: EdgeInsets.all(4),
            child: child,
          );

      List<String> columnNames = List<String>.from(map['colLabels']);
      List<TableRow> rows = [];
      map['rows'].forEach((row) {
        rows.add(TableRow(
          children: List<Widget>.from(row.map((e) => buildContainer(Text('${e.toString()}'))).toList()),
        ));
      });

      Map<int, TableColumnWidth> columnWidths = {};
      for (int i = 0; i < columnNames.length; i++) {
        columnWidths[i] = IntrinsicColumnWidth();
      }

      Widget table = Table(
        border: TableBorder.all(),
        columnWidths: columnWidths,
        children: [
          TableRow(
            children: columnNames.map((e) => buildContainer(Text(e, style: TextStyle(fontWeight: FontWeight.bold)))).toList(),
          ),
          ...rows,
        ],
      );

      Widget caption = Text(
        '${map['caption']}',
        style: TextStyle(
//          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            caption,
            SizedBox(height: 2),
            table,
          ],
        ),
      );
    }

    /// Take one entry item and convert it to a widget (a paragraph)
    Widget buildEntryLine(dynamic entry) {
      Widget child = Container();
      if (entry is String) {
        child = buildRichText(buildTextSpanChildren(entry));
      } else {
        switch (entry['type']) {
          case 'entries':
            child = mapToEntries(entry);
            break;
          case 'list':
            child = mapToList(entry);
            break;
          case 'table':
            child = mapToTable(entry);
            break;
        }
      }
      return Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: child,
      );
    }

    Widget buildSpellDetail(BuildContext context, Widget icon, String key, String value) {
      return Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
            children: [
              WidgetSpan(
                child: SizedBox(
                  width: 20,
                  child: Align(
                    alignment: Alignment.center,
                    child: icon,
                  ),
                ),
              ),
              WidgetSpan(
                child: SizedBox(
                  width: 7,
                ),
              ),
              TextSpan(
                text: '$key: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Provider.of<ThemeManager>(context).colorPalette.appBarBackgroundColor,
//        title: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text(spell.name),
//            Text(
//              spell.subtitle,
//              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
//            ),
//          ],
//        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 13,
            right: 13,
            top: 15,
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
                SizedBox(height: 14),
                buildSpellDetail(context, FaIcon(FontAwesomeIcons.book, size: 18), 'Source', '${spell.shortSource} p${spell.pageNum}'),
                buildSpellDetail(context, FaIcon(FontAwesomeIcons.stopwatch, size: 18), 'Casting Time', spell.castingTime),
                buildSpellDetail(context, FaIcon(FontAwesomeIcons.draftingCompass, size: 18), 'Range', spell.range),
                buildSpellDetail(context, FaIcon(FontAwesomeIcons.mortarPestle, size: 18), 'Components', spell.components),
                buildSpellDetail(context, FaIcon(FontAwesomeIcons.hourglassEnd, size: 18), 'Duration', spell.durationAndConcentration),
                buildSpellDetail(context, FaIcon(FontAwesomeIcons.hatWizard, size: 18), 'Classes', spell.classesList.join(', ')),
                spell.belongsToRaces
                    ? buildSpellDetail(context, FaIcon(FontAwesomeIcons.child, size: 18), 'Races', spell.racesList.join(', '))
                    : Container(),
                SizedBox(height: 12),
              ],
              ...spell.description.map((entry) => buildEntryLine(entry)).toList(),
              spell.hasHigherLevels
                  ? RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                        children: [
                          TextSpan(
                            text: 'At Higher Levels. ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ...buildTextSpanChildren(spell.atHigherLevels),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
