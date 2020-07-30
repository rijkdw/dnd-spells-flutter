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

class PreparedSpellsPage extends StatelessWidget {

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<CharacterSpellList, SpellRepository>(
      builder: (context, characterSpellList, spellRepository, child) {
        //
        Widget preparedSpellTileBuilder(Spell spell) {
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
                spell.level > 0
                    ? InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          characterSpellList.spendSpellSlotOfLevel(spell.level);
                        },
                        child: Container(
                          width: 75,
                          height: 35,
                          child: Center(
                            child: Visibility(
                              visible: spell.level > 0,
                              child: Text('CAST'),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        }

        List<String> preparedSpellNames = characterSpellList.preparedSpellNames;
        List<Spell> preparedSpells = preparedSpellNames.map((spellName) => spellRepository.getSpellFromName(spellName)).toList();
        return HeaderedSpellList(
          scrollController: scrollController,
          key: PageStorageKey<String>('prep'),
          spells: preparedSpells,
          spellTileBuilder: preparedSpellTileBuilder,
        );
      },
    );
  }
}
