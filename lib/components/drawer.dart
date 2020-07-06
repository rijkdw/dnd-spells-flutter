import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/services/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme(
        data: ThemeData(
          accentColor: Provider.of<ThemeManager>(context).colorPalette.clickableTextLinkColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                width: double.infinity,
                child: Text('Hello'),
              ),
              decoration: BoxDecoration(
                color: Provider.of<ThemeManager>(context).colorPalette.drawerPrimary,
              ),
            ),
            ListView(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              children: <Widget>[
                ExpansionTile(
                  title: Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text('Change Theme'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => _ThemeChangeDialog(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChangeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 3 / 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 18),
            Text(
              'Change Theme',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              shrinkWrap: true,
              children: appColorPalettes.keys.map((key) => _ColorPaletteGridTile(key, appColorPalettes[key])).toList(),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ColorPaletteGridTile extends StatelessWidget {
  final String name;
  final ColorPalette colorPalette;

  _ColorPaletteGridTile(this.name, this.colorPalette);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ThemeManager>(context, listen: false).setColorPalette(name);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colorPalette.appBarBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Provider.of<ThemeManager>(context).paletteName == name
                ? Center(
                    child: Icon(
                      Icons.check,
                      size: 50,
                      color: colorPalette.navBarSelectedColor.withOpacity(0.4),
                    ),
                  )
                : Container(),
            Center(
              child: Text(
                name.toUpperCase(),
                style: TextStyle(
                  letterSpacing: 0.75,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorPalette.navBarSelectedColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
