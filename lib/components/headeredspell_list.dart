import 'package:dnd_spells_flutter/components/spell_listtile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/appstatemanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

enum OrderBy { name, level, school }

class HeaderedSpellList extends StatelessWidget {
  final List<Spell> spells;
  final OrderBy orderBy;

  final ScrollController _scrollController = ScrollController();

  HeaderedSpellList({@required this.spells, @required this.orderBy});

  SliverStickyHeader _buildSpellSubList(String header, List<Spell> spellsInThisSublist) {
    spellsInThisSublist.sort((a, b) => a.name.compareTo(b.name));
    return SliverStickyHeader(
      header: InkWell(
        onTap: () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(150, 0, 0, 1),
            ),
            color: Color.fromRGBO(150, 0, 0, 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            header,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          spellsInThisSublist.map((spell) => SpellListTile(spell: spell)).toList(),
        ),
      ),
    );
  }

  List<SliverStickyHeader> _getAllSplits() {
    spells.sort((a, b) => a.level.compareTo(b.level));
    List<dynamic> values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    List<SliverStickyHeader> returnList = [];

    int valueIndex = 0;
    List<Spell> spellsWithCurrentValue = [];
    for (Spell spell in spells) {
      if (spell.level != values[valueIndex]) {
        // end of this list
        returnList.add(_buildSpellSubList('Level ${values[valueIndex]}', spellsWithCurrentValue));
        // reset step
        valueIndex++;
        spellsWithCurrentValue = [];
      }
      spellsWithCurrentValue.add(spell);
    }
    returnList.add(_buildSpellSubList('Level ${values.last}', spellsWithCurrentValue));

    return returnList;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: _scrollController,
      slivers: _getAllSplits(),
    );
  }
}
