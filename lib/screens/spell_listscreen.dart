import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/sortwidget.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpellListScreen extends StatefulWidget {
  final SpellList spellList;
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.spellList.name,
        ),
      ),
      body: Consumer<SpellRepository>(
        builder: (context, spellRepository, child) {
          Set<Spell> spellsOnList = Set<Spell>();
          widget.spellList.spellNames.forEach((spellName) {
            spellsOnList.add(spellRepository.getSpellFromName(spellName));
          });
          spellRepository.allSpells.forEach((spell) {
            if (spell.classesList.contains(widget.spellList.className))
              spellsOnList.add(spell);
            if (spell.subclassesList.contains('${widget.spellList.className} (${widget.spellList.subclassName})'))
              spellsOnList.add(spell);
          });
          if (spellsOnList.isEmpty)
            return Column(
              children: <Widget>[
                SortWidget(
                  onTap: (newOrderBy) {},
                ),
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
                  spells: spellsOnList.toList(),
                  orderBy: orderBy,
                ),
              ),
              SortWidget(
                onTap: (newOrderBy) {
                  setState(() {
                    orderBy = newOrderBy;
                  });
                },
                toCheck: orderBy,
              ),
            ],
          );
        },
      ),
    );
  }
}
