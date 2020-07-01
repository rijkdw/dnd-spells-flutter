import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:flutter/material.dart';

class ListsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsDrawer(),
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Text('Lists Page'),
      ),
    );
  }
}
