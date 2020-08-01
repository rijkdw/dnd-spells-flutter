import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/spell_tile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KnownSpellsPage extends StatelessWidget {

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<CharacterSpellList, SpellRepository>(
      builder: (context, characterSpellList, spellRepository, child) {
        //
        Widget knownSpellTileBuilder(Spell spell) {
          bool spellIsPrepared = characterSpellList.preparedSpellNames.contains(spell.name);
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
          );
        }

        List<String> knownSpellNames = characterSpellList.knownSpellNames;
        List<Spell> knownSpells = knownSpellNames.map((spellName) => spellRepository.getSpellFromName(spellName)).toList();
        return HeaderedSpellList(
          scrollController: scrollController,
          key: PageStorageKey<String>('known'),
//          orderBy: orderByContainer.orderBy,
//          onOrderChange: (orderBy) {
//            print('Known spells sorted by $orderBy');
//            orderByContainer.orderBy = orderBy;
//          },
          spells: knownSpells,
          spellTileBuilder: knownSpellTileBuilder,
        );
      },
    );
  }
}
