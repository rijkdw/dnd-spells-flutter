import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/components/spell_historytile.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsDrawer(),
      drawerEdgeDragWidth: double.infinity,
      appBar: AppBar(
        elevation: 0,
//        title: Text(
//          '${Provider.of<HistoryManager>(context).recentlyViewedSpells.length} recently viewed'
//        ),
        backgroundColor: Provider.of<ThemeManager>(context).colorPalette.appBarBackgroundColor,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (Provider.of<HistoryManager>(context, listen: false).recentlyViewedSpells.isNotEmpty) {
                Provider.of<HistoryManager>(context, listen: false).clearHistory();
//                Scaffold.of(context).showSnackBar(SnackBar(
//                  content: Text('History cleared'),
//                  duration: Duration(seconds: 2),
//                ));
              }
            },
            icon: Icon(FontAwesomeIcons.trash, size: 20),
          )
        ],
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
