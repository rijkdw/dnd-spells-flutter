import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/quicksearchbottomsheet.dart';
import 'package:dnd_spells_flutter/components/sortwidget.dart';
import 'package:dnd_spells_flutter/components/spell_gridtile.dart';
import 'package:dnd_spells_flutter/components/spell_listtile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/screens/filterscreen.dart';
import 'package:dnd_spells_flutter/services/appstatemanager.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    // for building the grid or list view (CURRENTLY OUT OF USE BECAUSE GRID VIEW IS BROKEN)
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
        backgroundColor: Provider.of<ThemeManager>(context).colorPalette.appBarBackgroundColor,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.keyboard_arrow_right),
        ),
        actions: <Widget>[
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.search,
              size: 20,
            ),
            onPressed: () => showModalBottomSheet(
              // TODO quicksearch
              context: context,
//              isScrollControlled: true,
              builder: (context) => QuickSearchBottomSheet(),
            ),
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
      body: Consumer2<SpellRepository, SearchManager>(
        builder: (context, spellRepository, searchManager, child) {
          List<Spell> filteredSpells = searchManager.filterSpells(spellRepository.allSpells);
          if (filteredSpells.isEmpty)
            return Column(
              children: <Widget>[
                SortWidget(
                  onTap: (newOrderBy) {},
                ),
                Expanded(
                  child: Center(
                    child: Text('No Spells'),
                  ),
                ),
              ],
            );

          ScrollController headeredSpellListController = ScrollController();

          return Column(
            children: <Widget>[
              SortWidget(
                onTap: (newOrderBy) => Provider.of<SearchManager>(context, listen: false).orderBy = newOrderBy,
                toCheck: Provider.of<SearchManager>(context).orderBy,
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    HeaderedSpellList(
                      scrollController: headeredSpellListController,
                      spells: filteredSpells,
                      orderBy: searchManager.orderBy,
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
//                          FloatingActionButton(
//                            mini: true,
//                            child: Icon(Icons.compare_arrows),
//                            onPressed: () {},
//                          ),
//                          SizedBox(width: 4),
                          FloatingActionButton(
                            mini: true,
                            onPressed: () {
                              headeredSpellListController.animateTo(
                                0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            backgroundColor: Provider.of<ThemeManager>(context).colorPalette.buttonColor,
                            child: Icon(
                              Icons.arrow_upward,
                              color: Provider.of<ThemeManager>(context).colorPalette.buttonTextColor,
                            ),
                          ),
//                          SizedBox(width: 4),
//                          FloatingActionButton(
//                            mini: true,
//                            onPressed: () {},
//                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
