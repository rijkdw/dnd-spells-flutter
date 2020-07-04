import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/components/spell_gridtile.dart';
import 'package:dnd_spells_flutter/components/spell_listtile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/appstatemanager.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dnd_spells_flutter/services/singletons.dart' as singletons;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Widget _buildList() {
      return Consumer2<SpellRepository, AppStateManager>(
        builder: (context, spellRepository, appStateManager, child) {
          if (spellRepository.allSpells.isEmpty) {
            return Center(
              child: Text('Loading...'),
            );
          }
          switch (appStateManager.globalDisplayMode) {
            case DisplayMode.list:
              return ListView(
                children: spellRepository.allSpells.map((spell) => SpellListTile(spell: spell)).toList(),
              );
            case DisplayMode.grid:
              return Container(
                padding: EdgeInsets.all(2),
                child: GridView.count(
                  crossAxisCount: 2,
                  children: spellRepository.allSpells.map((spell) => SpellGridTile(spell: spell)).toList(),
                ),
              );
          }
          return Container();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.keyboard_arrow_right),
        ),
        actions: <Widget>[
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.filter,
              size: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Provider.of<AppStateManager>(context).globalDisplayMode == DisplayMode.list ? Icons.view_module : Icons.view_list,
              size: 30,
            ),
            onPressed: () {
              Provider.of<AppStateManager>(context, listen: false).switchDisplayMode();
//              Scaffold.of(context).removeCurrentSnackBar();
//              Scaffold.of(context).showSnackBar(
//                SnackBar(
//                  content:
//                      Text('Switched to ${Provider.of<AppStateManager>(context, listen: false).globalDisplayMode.toString().split('.')[1]} mode'),
//                  duration: Duration(seconds: 2),
//                ),
//              );
            },
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
