import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuOption {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final double iconSize;

  MenuOption({this.iconData: Icons.face, this.text: 'Menu Option', this.iconSize:24, this.onTap});
}

class DialogMenu extends StatelessWidget {
  final Widget heading;
  final List<MenuOption> menuOptions;
  final BuildContext dialogContext;
  DialogMenu({@required this.menuOptions, this.heading, this.dialogContext});

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context, listen: false).colorPalette;

    Widget _buildMenuOptionRow(MenuOption menuOption) {
      return InkWell(
        onTap: () {
          Navigator.pop(dialogContext ?? context);
          menuOption.onTap();
        },
        child: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              Icon(
                menuOption.iconData,
                color: colorPalette.clickableTextLinkColor,
                size: menuOption.iconSize,
              ),
              SizedBox(width: 10),
              Text(
                menuOption.text,
                style: Theme.of(dialogContext ?? context).textTheme.bodyText2.copyWith(fontSize: 16),
              )
            ],
          ),
        ),
      );
    }

    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: colorPalette.dialogBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            heading,
            Divider(),
            ...this.menuOptions.map((menuOption) => _buildMenuOptionRow(menuOption)).toList(),
          ],
        ),
      ),
    );
  }
}
