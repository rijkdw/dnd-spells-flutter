import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/allspellspage.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/knownspellspage.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/preparedspellspage.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/spellslotpage.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CharacterSpellListScreen extends StatefulWidget {
  final CharacterSpellList spellList;
  CharacterSpellListScreen({this.spellList});

  @override
  _CharacterSpellListScreenState createState() => _CharacterSpellListScreenState();
}

class _CharacterSpellListScreenState extends State<CharacterSpellListScreen> {
  OrderBy orderBy;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    orderBy = Provider.of<SearchManager>(context, listen: false).orderBy;
  }

  void _onPageChanged(int page) {
    setState(() {
      this._selectedIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    List<Widget> pages = [
      AllSpellsPage(),
      KnownSpellsPage(),
      PreparedSpellsPage(),
      SpellSlotPage(),
    ];

    Map<int, List<Widget>> actions = {
      3: [
        IconButton(
          icon: Icon(
            FontAwesomeIcons.bed,
            size: 20,
          ),
          onPressed: () {
            print('reset spell slots');
            for (int level in List.generate(9, (index) => index+1)) {
              widget.spellList.setMaxSlotsAtLevel(level: level, max: 4);
            }
          },
        ),
      ],
    };

    return Scaffold(
      drawer: SettingsDrawer(),
      drawerEdgeDragWidth: double.infinity,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.spellList.name,
        ),
        actions: actions[_selectedIndex],
      ),
      body: IndexedStack(
        children: pages,
        index: _selectedIndex,
      ),
      bottomNavigationBar: Material(
        color: colorPalette.navBarBackgroundColor,
        child: Theme(
          data: ThemeData(
            canvasColor: colorPalette.navBarBackgroundColor,
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: colorPalette.navBarBackgroundColor,
            selectedItemColor: colorPalette.navBarSelectedColor,
            unselectedItemColor: colorPalette.navBarUnselectedColor,
            currentIndex: _selectedIndex,
            onTap: _onPageChanged,
            items: [
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.infinity,
                  size: 20,
                ),
                title: Text('All'),
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.brain,
                  size: 20,
                ),
                title: Text('Known'),
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.readme,
                  size: 20,
                ),
                title: Text('Prepared'),
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.lock,
                  size: 20,
                ),
                title: Text('Slots'),
              ),
            ],
          ),
        ),
      ),
//      body: Consumer<SpellRepository>(
//        builder: (context, spellRepository, child) {
//          Widget searchPageSpellTileBuilder(Spell spell) {
//            return InkWell(
//              onTap: () {
//                Provider.of<HistoryManager>(context, listen: false).addToHistory(SpellView.now(spellName: spell.name));
//                Scaffold.of(context).removeCurrentSnackBar();
//                return Navigator.of(context).push(MaterialPageRoute(
//                  builder: (context) => SpellInfoScreen(
//                    spell: spell,
//                  ),
//                ));
//              },
//              onLongPress: () {
//                showDialog(
//                  context: context,
//                  child: DialogMenu(
//                    heading: Text(
//                      '${spell.name}',
//                      style: TextStyle(fontSize: 24),
//                    ),
//                    menuOptions: [
//                      MenuOption(
//                        text: 'Remove',
//                        iconData: FontAwesomeIcons.trash,
//                        iconSize: 20,
//                        onTap: () {
//                          setState(() {
//                            widget.spellList.removeSpellFromList(spell.name);
//                          });
//                        },
//                      ),
//                    ],
//                  ),
//                );
//              },
//              child: Container(
//                width: double.infinity,
//                padding: EdgeInsets.fromLTRB(10, 6, 18, 6),
//                decoration: spellTileDecoration,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    NameSubtitleColumn(spell),
//                    InkWell(
//                      splashColor: Colors.transparent,
//                      child: Text(
//                        'LEARN',
//                        style: TextStyle(color: colorPalette.buttonTextColor),
//                      ),
//                      onTap: () {
//                        print(spell.name);
//                      },
//                    )
//                  ],
//                ),
//              ),
//            );
//          }
//
////          CharacterOptionRepository characterOptionRepository = Provider.of<CharacterOptionRepository>(context);
////          List<CharacterOption> listClasses = characterOptionRepository.listifyClasses();
////
////          List<Spell> firstPageList = [];
////
////          List<String> classNames = [...widget.spellList.classNames, ...widget.spellList.subclassNames];
////          for (String name in classNames) {
////            for (CharacterOption class_ in listClasses) {
////              if (class_.name == name) {
////                class_.learnableSpellNames.forEach((spellName) {
////                  firstPageList.add(spellRepository.getSpellFromName(spellName));
////                });
////              }
////            }
////          }
//
//
//
//          return Scaffold(
//
//          );
////
////          if (firstPageList.isEmpty)
////            return Column(
////              children: <Widget>[
////                Expanded(
////                  child: Center(
////                    child: Text('No spells in this list'),
////                  ),
////                ),
////              ],
////            );
////          return Column(
////            children: <Widget>[
////              Expanded(
////                child: HeaderedSpellList(
////                  spellTileBuilder: searchPageSpellTileBuilder,
////                  spells: firstPageList,
////                ),
////              ),
////            ],
////          );
//        },
//      ),
    );
  }
}
