import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/spell_tile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KnownSpellsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<CharacterSpellList, SpellRepository>(
      builder: (context, characterSpellList, spellRepository, child) {
        //
        Widget knownSpellTileBuilder(Spell spell) {
          bool spellIsPrepared = characterSpellList.preparedSpellNames.contains(spell.name);
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
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.star,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: NameSubtitleColumn(spell),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    if (spellIsPrepared)
                      characterSpellList.unprepareSpell(spell.name);
                    else
                      characterSpellList.prepareSpell(spell.name);
                  },
                  child: Container(
                    width: 75,
                    height: 35,
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Visibility(
                            visible: !spellIsPrepared,
                            child: Text('PREPARE'),
                          ),
                          Visibility(
                            visible: spellIsPrepared,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        List<String> knownSpellNames = characterSpellList.knownSpellNames;
        List<Spell> knownSpells = knownSpellNames.map((spellName) => spellRepository.getSpellFromName(spellName)).toList();
        return HeaderedSpellList(
          spells: knownSpells,
          spellTileBuilder: knownSpellTileBuilder,
        );
      },
    );
  }
}
