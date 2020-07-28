import 'package:dnd_spells_flutter/components/dialogmenu.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/sortwidget.dart';
import 'package:dnd_spells_flutter/components/spell_tile.dart';
import 'package:dnd_spells_flutter/models/characteroption.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/characteroptionrepository.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GenericSpellListScreen extends StatefulWidget {
  final GenericSpellList spellList;
  GenericSpellListScreen({this.spellList});

  @override
  _GenericSpellListScreenState createState() => _GenericSpellListScreenState();
}

class _GenericSpellListScreenState extends State<GenericSpellListScreen> {
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
//                    InkWell(
//                      splashColor: Colors.transparent,
//                      child: Text(
//                        'LEARN',
//                        style: TextStyle(color: colorPalette.buttonTextColor),
//                      ),
//                      onTap: () {
//                        print(spell.name);
//                      },
//                    )
                  ],
                ),
              ),
            );
          }

          CharacterOptionRepository characterOptionRepository = Provider.of<CharacterOptionRepository>(context);
          SpellRepository spellRepository = Provider.of<SpellRepository>(context);

          List<Spell> spells = [];
          widget.spellList.spellNames.forEach((spellName) {
            spells.add(spellRepository.getSpellFromName(spellName));
          });

          if (spells.isEmpty)
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
                  spells: spells,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
