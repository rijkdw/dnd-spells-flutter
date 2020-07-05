import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/screens/pages/historypage.dart';
import 'package:dnd_spells_flutter/screens/pages/listspage.dart';
import 'package:dnd_spells_flutter/screens/pages/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  void _onPageChanged(int page) {
    setState(() {
      this._selectedIndex = page;
    });
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
      body: IndexedStack(
        index: _selectedIndex,
        children: children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.black.withOpacity(0.7),
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
