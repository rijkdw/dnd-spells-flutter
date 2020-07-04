import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/components/spell_historytile.dart';
import 'package:dnd_spells_flutter/components/spell_listtile.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ),
        body: Consumer2<HistoryManager, SpellRepository>(
          builder: (context, historyManager, spellRepository, child) {
            if (historyManager.recentlyViewedSpells.isEmpty) {
              return Center(
                child: Text('Empty history'),
              );
            }
            return ListView(
              children: historyManager.recentlyViewedSpells.map((spell) => SpellHistoryTile(spell: spell)).toList(),
            );
          },
        ));
  }
}
