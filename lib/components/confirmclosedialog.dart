import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmCloseDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    return AlertDialog(
      backgroundColor: colorPalette.dialogBackgroundColor,
      title: Text(
        'Do you really want to close Spellbook?',
        style: TextStyle(
          color: colorPalette.mainTextColor,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Yes',
            style: TextStyle(
              fontSize: 18,
              color: colorPalette.clickableTextLinkColor,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(Future.value(true)),
        ),
        FlatButton(
          child: Text(
            'No',
            style: TextStyle(
              fontSize: 18,
              color: colorPalette.clickableTextLinkColor,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(Future.value(false)),
        ),
      ],
    );
  }
}
