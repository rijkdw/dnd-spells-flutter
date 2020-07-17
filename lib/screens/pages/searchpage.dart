import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/components/quicksearchbottomsheet.dart';
import 'package:dnd_spells_flutter/components/sortwidget.dart';
import 'package:dnd_spells_flutter/components/spell_tile.dart';
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Provider.of<ThemeManager>(context).colorPalette.appBarBackgroundColor,
        title: Text(
          'Spells',
        ),
        actions: <Widget>[
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.search,
              size: 20,
            ),
            onPressed: () => showModalBottomSheet(
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
            },
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

          return Column(
            children: <Widget>[
              SortWidget(
                onTap: (newOrderBy) => Provider.of<SearchManager>(context, listen: false).orderBy = newOrderBy,
                toCheck: Provider.of<SearchManager>(context).orderBy,
              ),
              Expanded(
                child: HeaderedSpellList(
                  spells: filteredSpells,
                  orderBy: searchManager.orderBy,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
