import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/spell_gridtile.dart';
import 'package:dnd_spells_flutter/components/spell_listtile.dart';
import 'package:dnd_spells_flutter/screens/filterscreen.dart';
import 'package:dnd_spells_flutter/services/appstatemanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  OrderBy orderBy = OrderBy.level;

  void _updateSearchParameters() {

  }

  void _pressCarrotButton() {
    setState(() {
      switch (orderBy) {
        case OrderBy.level:
          orderBy = OrderBy.name;
          break;
        case OrderBy.name:
          orderBy = OrderBy.school;
          break;
        case OrderBy.school:
          orderBy = OrderBy.level;
          break;
      }
    });
  }

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
              FontAwesomeIcons.carrot,
              size: 20,
            ),
            onPressed: () => _pressCarrotButton(),
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.search,
              size: 20,
            ),
            onPressed: () {}, // TODO quicksearch
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.filter,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FilterScreen(),
              ));
            }, // TODO open filter page
          ),
          IconButton(
            icon: Icon(
              Provider.of<AppStateManager>(context).globalDisplayMode == DisplayMode.list ? Icons.view_module : Icons.view_list,
              size: 30,
            ),
            onPressed: () => Provider.of<AppStateManager>(context, listen: false).switchDisplayMode(),
          )
        ],
      ),
      // body: _buildList(),
      body: HeaderedSpellList(
        spells: Provider.of<SpellRepository>(context).allSpells,
        orderBy: orderBy,
      ),
    );
  }
}
