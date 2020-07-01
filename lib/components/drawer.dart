import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              width: double.infinity,
              child: Text('Hello'),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
