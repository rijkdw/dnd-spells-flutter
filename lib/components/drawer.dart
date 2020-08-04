import 'package:auto_size_text/auto_size_text.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/services/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    return Drawer(
      child: Theme(
        data: ThemeData(
          accentColor: colorPalette.clickableTextLinkColor,
        ),
        child: Container(
          color: colorPalette.drawerSecondary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerHeader(
                child: Container(
                  width: double.infinity,
                  child: Text('Hello'),
                ),
                decoration: BoxDecoration(
                  color: colorPalette.drawerPrimary,
                ),
              ),
              ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                children: <Widget>[
                  _MenuListTile(
                    text: 'Change theme',
                    iconData: FontAwesomeIcons.palette,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => _ThemeChangeDialog(),
                    ),
                  ),
                  _MenuListTile(
                    text: 'Report bug',
                    iconData: FontAwesomeIcons.bug,
                    onTap: () {},
                  ),
                  _MenuListTile(
                    text: 'Support the app',
                    iconData: FontAwesomeIcons.moneyBill,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuListTile extends StatelessWidget {
  final String text;
  final IconData iconData;
  final VoidCallback onTap;

  _MenuListTile({this.text: 'uwu', this.iconData: Icons.face, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              child: Icon(
                iconData,
                size: 24,
                color: colorPalette.drawerPrimary,
              ),
            ),
            SizedBox(width: 14),
            AutoSizeText(
              text,
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: colorPalette.mainTextColor,
              ),
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
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    return Dialog(
      child: Container(
        color: colorPalette.dialogBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 4),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 3 / 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 18),
            Text(
              'CHANGE THEME',
              style: TextStyle(
                fontSize: 22,
                color: colorPalette.mainTextColor,
                letterSpacing: 1,
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
          color: colorPalette.brightness == Brightness.light ? colorPalette.appBarBackgroundColor : colorPalette.stickyHeaderBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Provider.of<ThemeManager>(context).paletteName == name
                ? Center(
                    child: Icon(
                      Icons.check,
                      size: 50,
                      color: colorPalette.mainTextColor.withOpacity(0.4),
                    ),
                  )
                : Container(),
            Center(
              child: Text(
                name.toUpperCase(),
                softWrap: true,
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
