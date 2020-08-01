import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/spell_tile.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreparedSpellsPage extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    return Consumer2<CharacterSpellList, SpellRepository>(
      builder: (context, characterSpellList, spellRepository, child) {
        //
        Widget preparedSpellTileBuilder(Spell spell) {
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
              spell.level > 0
                  ? InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        if (characterSpellList.currentSpellSlots[spell.level] > 0)
                          characterSpellList.spendSpellSlotOfLevel(spell.level);
                        else {
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text('No spell slots available'),
                          ));
                        }
                      },
                      child: Container(
                        width: 75,
                        height: 35,
                        child: Center(
                          child: Visibility(
                            visible: spell.level > 0,
                            child: Text(
                              'CAST',
                              style: TextStyle(
                                color: characterSpellList.currentSpellSlots[spell.level] > 0
                                    ? colorPalette.clickableTextLinkColor
                                    : colorPalette.navBarBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        }

        List<String> preparedSpellNames = characterSpellList.preparedSpellNames;
        List<Spell> preparedSpells = preparedSpellNames.map((spellName) => spellRepository.getSpellFromName(spellName)).toList();
        return HeaderedSpellList(
          scrollController: scrollController,
          key: PageStorageKey<String>('prep'),
//          orderBy: orderByContainer.orderBy,
//          onOrderChange: (orderBy) {
//            print('Prepared spells sorted by $orderBy');
//            orderByContainer.orderBy = orderBy;
//          },
          spells: preparedSpells,
          spellTileBuilder: preparedSpellTileBuilder,
        );
      },
    );
  }
}
