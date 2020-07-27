import 'package:dnd_spells_flutter/components/dialogmenu.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/sortwidget.dart';
import 'package:dnd_spells_flutter/components/spell_tile.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SpellListScreen extends StatefulWidget {
  final CharacterSpellList spellList;
  SpellListScreen({this.spellList});

  @override
  _SpellListScreenState createState() => _SpellListScreenState();
}

class _SpellListScreenState extends State<SpellListScreen> {
  OrderBy orderBy;

  @override
  void initState() {
    super.initState();
    orderBy = Provider.of<SearchManager>(context, listen: false).orderBy;
  }

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.spellList.name,
        ),
      ),
      body: Consumer<SpellRepository>(
        builder: (context, spellRepository, child) {
          Widget searchPageSpellTileBuilder(Spell spell) {
            return InkWell(
              onTap: () {
                Provider.of<HistoryManager>(context, listen: false).addToHistory(SpellView.now(spellName: spell.name));
                Scaffold.of(context).removeCurrentSnackBar();
                return Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SpellInfoScreen(
                    spell: spell,
                  ),
                ));
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  child: DialogMenu(
                    heading: Text(
                      '${spell.name}',
                      style: TextStyle(fontSize: 24),
                    ),
                    menuOptions: [
                      MenuOption(
                        text: 'Remove',
                        iconData: FontAwesomeIcons.trash,
                        iconSize: 20,
                        onTap: () {
                          setState(() {
                            widget.spellList.removeSpellFromList(spell.name);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 6, 18, 6),
                decoration: spellTileDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    NameSubtitleColumn(spell),
                    InkWell(
                      splashColor: Colors.transparent,
                      child: Text(
                        'LEARN',
                        style: TextStyle(color: colorPalette.buttonTextColor),
                      ),
                      onTap: () {
                        print(spell.name);
                      },
                    )
                  ],
                ),
              ),
            );
          }

          Set<Spell> spellsOnList = Set<Spell>();
          widget.spellList.spellNames.forEach((spellName) {
            spellsOnList.add(spellRepository.getSpellFromName(spellName));
          });
          // TODO add the spells from the classes and races
//          spellRepository.allSpells.forEach((spell) {
//            if (spell.classesList.contains(widget.spellList.className)) spellsOnList.add(spell);
//            if (spell.subclassesList.contains('${widget.spellList.className} (${widget.spellList.subclassName})')) spellsOnList.add(spell);
//          });
          if (spellsOnList.isEmpty)
            return Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text('No spells in this list'),
                  ),
                ),
              ],
            );
          return Column(
            children: <Widget>[
              Expanded(
                child: HeaderedSpellList(
                  spellTileBuilder: searchPageSpellTileBuilder,
                  spells: spellsOnList.toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
