import 'package:dnd_spells_flutter/components/spell_historytile.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Provider.of<ThemeManager>(context).colorPalette.appBarBackgroundColor,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.keyboard_arrow_right),
        ),
        actions: <Widget>[],
      ),
      body: Consumer2<HistoryManager, SpellRepository>(
        builder: (context, historyManager, spellRepository, child) {
          if (historyManager.recentlyViewedSpells.isEmpty) {
            return Center(
              child: Text('Empty history'),
            );
          }
          return ListView(
            children: historyManager.recentlyViewedSpells.map((spellView) => SpellHistoryTile(spellView: spellView)).toList(),
          );
        },
      ),
    );
  }
}
