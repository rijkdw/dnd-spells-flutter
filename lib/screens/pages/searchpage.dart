import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/components/spell_gridtile.dart';
import 'package:dnd_spells_flutter/components/spell_listtile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
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

enum DisplayMode { list, grid }

class _SearchPageState extends State<SearchPage> {
  DisplayMode _displayMode = DisplayMode.list;

  void _switchDisplayMode() {
    setState(() {
      if (_displayMode == DisplayMode.list)
        _displayMode = DisplayMode.grid;
      else
        _displayMode = DisplayMode.list;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget _buildList() {
      return Consumer<SpellRepository>(
        builder: (context, spellRepo, child) {
          if (spellRepo.allSpells.isEmpty) {
            return Center(
              child: Text('Loading...'),
            );
          }
          switch (_displayMode) {
            case DisplayMode.list:
              return ListView(
                children: spellRepo.allSpells.map((spell) => SpellListTile(spell: spell)).toList(),
              );
            case DisplayMode.grid:
              return Container(
                padding: EdgeInsets.all(2),
                child: GridView.count(
                  crossAxisCount: 2,
                  children: spellRepo.allSpells.map((spell) => SpellGridTile(spell: spell)).toList(),
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
              _displayMode == DisplayMode.list ? Icons.view_module : Icons.view_list,
              size: 30,
            ),
            onPressed: () {
              _switchDisplayMode();
              Scaffold.of(context).removeCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switched to ${_displayMode.toString().split('.')[1]} mode'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
