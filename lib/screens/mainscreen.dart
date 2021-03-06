import 'package:dnd_spells_flutter/components/confirmclosedialog.dart';
import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/screens/mainscreenpages/historypage.dart';
import 'package:dnd_spells_flutter/screens/mainscreenpages/listspage.dart';
import 'package:dnd_spells_flutter/screens/mainscreenpages/searchpage.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DateTime currentBackPressTime;

  void _onPageChanged(int page) {
    setState(() {
      this._selectedIndex = page;
    });
  }

  Future<bool> _onWillPop() async {
    // clear the search first
    if (Provider.of<SearchManager>(context, listen: false).isFiltered) {
      Provider.of<SearchManager>(context, listen: false).clearFilters();
      return Future.value(false);
    }
    final result = await showDialog(
      context: context,
      builder: (context) => ConfirmCloseDialog(),
    );
    return result;
  }

  List<Widget> children = [
    SearchPage(),
    ListsPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: SettingsDrawer(),
      drawerEdgeDragWidth: double.infinity,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: IndexedStack(
          index: _selectedIndex,
          children: children,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Provider.of<ThemeManager>(context).colorPalette.navBarBackgroundColor,
        selectedItemColor: Provider.of<ThemeManager>(context).colorPalette.navBarSelectedColor,
        unselectedItemColor: Provider.of<ThemeManager>(context).colorPalette.navBarUnselectedColor,
        currentIndex: _selectedIndex,
        onTap: _onPageChanged,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.search,
              size: 20,
            ),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.book,
              size: 20,
            ),
            title: Text('Lists'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.history,
              size: 20,
            ),
            title: Text('Recent'),
          ),
        ],
      ),
    );
  }
}
