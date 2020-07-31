import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/components/yesnodialog.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/editmaxspellslotpage.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/allspellspage.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/knownspellspage.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/preparedspellspage.dart';
import 'package:dnd_spells_flutter/screens/charcterlistscreenpages/spellslotpage.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderByContainer extends ChangeNotifier {
  OrderBy _orderBy;
  OrderByContainer({@required OrderBy orderBy}) {
    this._orderBy = orderBy;
  }

  OrderBy get orderBy => _orderBy;
  set orderBy(OrderBy newOrderBy) {
    this._orderBy = newOrderBy;
    print('Notifying orderByContainer\'s listeners');
    notifyListeners();
  }
}

class CharacterSpellListScreen extends StatefulWidget {
  final CharacterSpellList spellList;
  CharacterSpellListScreen({this.spellList});

  @override
  _CharacterSpellListScreenState createState() => _CharacterSpellListScreenState();
}

class _CharacterSpellListScreenState extends State<CharacterSpellListScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onPageChanged(int page) {
    setState(() {
      this._selectedIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    Route createEditSpellSlotRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ChangeNotifierProvider.value(
            value: widget.spellList,
            child: EditMaxSpellSlotsPage(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    Map<int, List<Widget>> actions = {
      3: [
        IconButton(
          icon: Icon(
            FontAwesomeIcons.bed,
            size: 20,
          ),
          onPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (context) => YesNoDialog(
                text: 'Regain all expended spell slots?',
              ),
            );
            if (result) widget.spellList.resetSpellSlots();
          },
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.edit,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(createEditSpellSlotRoute());
          },
        ),
      ],
    };

    return Scaffold(
      drawer: SettingsDrawer(),
      drawerEdgeDragWidth: double.infinity,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        title: Text(
          widget.spellList.name,
        ),
        actions: actions[_selectedIndex],
      ),
      body: ChangeNotifierProvider(
        create: (_) => OrderByContainer(
          orderBy: OrderBy.name,
        ),
        child: IndexedStack(
          children: [
            AllSpellsPage(),
            KnownSpellsPage(),
            PreparedSpellsPage(),
            SpellSlotPage(),
          ],
          index: _selectedIndex,
        ),
      ),
      bottomNavigationBar: Theme(
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
