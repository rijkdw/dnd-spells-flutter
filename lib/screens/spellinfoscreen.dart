import 'dart:math';

import 'package:dnd_spells_flutter/components/add_to_spell_list_dialog.dart';
import 'package:dnd_spells_flutter/components/conditionpopup.dart';
import 'package:dnd_spells_flutter/components/dicerollerpopup.dart';
import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
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

    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

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
              color: colorPalette.clickableTextLinkColor,
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
          style: Theme.of(context).textTheme.bodyText2.copyWith(
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
      Widget buildContainer(Widget child) {
        return TableCell(
          child: Container(
            padding: EdgeInsets.all(4),
            child: child,
          ),
        );
      }

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
        border: TableBorder.all(
          color: colorPalette.tableLineColor,
        ),
        columnWidths: columnWidths,
        children: [
          TableRow(
//            decoration: BoxDecoration(
//              border: Border.all(
//                color: Provider.of<ThemeManager>(context).colorPalette.tableLineColor,
//              ),
//            ),
            children: columnNames.map((e) => buildContainer(Text(e, style: TextStyle(fontWeight: FontWeight.bold)))).toList(),
          ),
          ...rows,
        ],
      );

      Widget caption = map['caption'] != null
          ? Text(
              '${map['caption']}',
              style: TextStyle(
//          fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          : Container();

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

    Widget buildSpellDetail({IconData icon, String title, String value, double size: 16}) {
      return Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
            children: [
              WidgetSpan(
                child: SizedBox(
                  height: 19,
                  width: 18,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: FaIcon(
                      icon,
                      size: size,
                      color: colorPalette.emphasisTextColor,
                    ),
                  ),
                ),
              ),
              WidgetSpan(
                child: SizedBox(width: 7),
              ),
              TextSpan(
                text: '$title: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorPalette.mainTextColor,
                ),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      );
    }

    ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorPalette.appBarBackgroundColor,
        actions: <Widget>[
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddToListDialog(spell: spell)
            ),
            icon: Icon(
              FontAwesomeIcons.plus,
              size: 20,
            ),
          ),
        ],
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: EdgeInsets.only(
              left: 13,
              right: 17,
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
                      color: Provider.of<ThemeManager>(context).colorPalette.subTextColor,
                    ),
                  ),
                  SizedBox(height: 14),
                  // spell details (casting time, range, etc)
                  buildSpellDetail(
                    icon: FontAwesomeIcons.book,
                    title: 'Source',
                    value: '${spell.shortSource} p${spell.pageNum}',
                  ),
                  buildSpellDetail(
                    icon: FontAwesomeIcons.stopwatch,
                    title: 'Casting Time',
                    value: spell.castingTime,
                  ),
                  buildSpellDetail(
                    icon: FontAwesomeIcons.draftingCompass,
                    title: 'Range',
                    value: spell.range,
                  ),
                  buildSpellDetail(
                    icon: FontAwesomeIcons.mortarPestle,
                    title: 'Components',
                    value: spell.components,
                  ),
                  buildSpellDetail(
                    icon: FontAwesomeIcons.hourglassHalf,
                    title: 'Duration',
                    value: spell.durationAndConcentration,
                  ),
                  buildSpellDetail(
                    icon: FontAwesomeIcons.hatWizard,
                    title: 'Classes',
                    value: spell.classesAndSubclassesList.join(', '),
                  ),
                  spell.belongsToRaces
                      ? buildSpellDetail(
                          icon: FontAwesomeIcons.child,
                          title: 'Races',
                          value: spell.racesList.join(', '),
                        )
                      : Container(),
                  SizedBox(height: 12),
                ],
                // the main spell description
                ...spell.description.map((entry) => buildEntryLine(entry)).toList(),
                // upcasting description
                spell.hasHigherLevels
                    ? RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
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
      ),
    );
  }
}
