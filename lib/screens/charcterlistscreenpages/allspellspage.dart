import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/spell_tile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllSpellsPage extends StatelessWidget {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //
    return Consumer2<CharacterSpellList, SpellRepository>(
      builder: (context, characterSpellList, spellRepository, child) {
        //
        Widget learnableSpellTileBuilder(Spell spell) {
          bool spellIsKnown = characterSpellList.knownSpellNames.contains(spell.name);
          if (spell.level == 0 && characterSpellList.preparedSpellNames.contains(spell.name)) spellIsKnown = true;
          return CustomSpellTile(
            spell: spell,
            children: <Widget>[
              SpellTileLeading(spell: spell),
              SizedBox(
                width: 12,
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
          );
        }

        List<String> learnableSpellNames = characterSpellList.learnableSpellNames;
        List<Spell> learnableSpells = learnableSpellNames.map((spellName) => spellRepository.getSpellFromName(spellName)).toList();
        return HeaderedSpellList(
          scrollController: scrollController,
          key: PageStorageKey<String>('all'),
//          orderBy: orderByContainer.orderBy,
//          onOrderChange: (orderBy) {
//            print('All spells sorted by $orderBy');
//            orderByContainer.orderBy = orderBy;
//          },
          spells: learnableSpells,
          spellTileBuilder: learnableSpellTileBuilder,
        );
      },
    );
  }
}
