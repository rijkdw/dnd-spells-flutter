import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/screens/pages/historypage.dart';
import 'package:dnd_spells_flutter/screens/pages/listspage.dart';
import 'package:dnd_spells_flutter/screens/pages/searchpage.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
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

  Future<bool> _onWillPop() {
    // clear the search first
    if (Provider.of<SearchManager>(context, listen: false).isFiltered) {
      Provider.of<SearchManager>(context, listen: false).clearFilters();
      return Future.value(false);
    }
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(milliseconds: 300)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
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
            icon: FaIcon(FontAwesomeIcons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.book),
            title: Text('Lists'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.history),
            title: Text('Recent'),
          ),
        ],
      ),
    );
  }
}
