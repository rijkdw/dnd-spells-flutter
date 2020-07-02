import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.keyboard_arrow_right),
        ),
      ),
      body: Center(
        child: Text('History Page'),
      ),
    );
  }
}
