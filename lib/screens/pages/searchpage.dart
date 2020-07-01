import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Scaffold(
      drawer: SettingsDrawer(),
      appBar: AppBar(
        elevation: 0,
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
      body: Center(
        child: Text('Search Page'),
      ),
    );
  }
}
