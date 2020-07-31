import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/spell_tile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:dnd_spells_flutter/screens/characterlistscreen.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllSpellsPage extends StatelessWidget {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //
    return Consumer3<CharacterSpellList, SpellRepository, OrderByContainer>(
      builder: (context, characterSpellList, spellRepository, orderByContainer, child) {
        //
        Widget learnableSpellTileBuilder(Spell spell) {
          bool spellIsKnown = characterSpellList.knownSpellNames.contains(spell.name);
          if (spell.level == 0 && characterSpellList.preparedSpellNames.contains(spell.name)) {
            spellIsKnown = true;
          }
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
                    if (spellIsKnown) {
                      // if it's known
                      if (spell.level == 0) // if it's a cantrip
                        characterSpellList.unprepareSpell(spell.name);
                      else // if it's a spell of level 1+
                        characterSpellList.unlearnSpell(spell.name);
                    } else {
                      // if it's not known
                      if (spell.level == 0) // if it's a cantrip
                        characterSpellList.prepareSpell(spell.name);
                      else // if it's a spell of level 1+
                        characterSpellList.learnSpell(spell.name);
                    }
                  },
                  child: Container(
                    width: 75,
                    height: 35,
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Visibility(
                            visible: !spellIsKnown,
                            child: Text('LEARN'),
                          ),
                          Visibility(
                            visible: spellIsKnown,
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

        List<String> learnableSpellNames = characterSpellList.learnableSpellNames;
        List<Spell> learnableSpells = learnableSpellNames.map((spellName) => spellRepository.getSpellFromName(spellName)).toList();
        return HeaderedSpellList(
          scrollController: scrollController,
          key: PageStorageKey<String>('all'),
          orderBy: orderByContainer.orderBy,
          onOrderChange: (orderBy) {
            print('All spells sorted by $orderBy');
            orderByContainer.orderBy = orderBy;
          },
          spells: learnableSpells,
          spellTileBuilder: learnableSpellTileBuilder,
        );
      },
    );
  }
}
