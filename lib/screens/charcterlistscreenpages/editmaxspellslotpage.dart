import 'dart:math';

import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditMaxSpellSlotsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Max Spell Slots'),
      ),
      body: EditMaxSpellSlotsForm(),
    );
  }
}

class EditMaxSpellSlotsForm extends StatefulWidget {
  @override
  _EditMaxSpellSlotsFormState createState() => _EditMaxSpellSlotsFormState();
}

class _EditMaxSpellSlotsFormState extends State<EditMaxSpellSlotsForm> {
  List<TextEditingController> textEditingControllers;

  @override
  Widget build(BuildContext context) {
    //
    CharacterSpellList characterSpellList = Provider.of<CharacterSpellList>(context);
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    textEditingControllers = [];

    Widget buildEditRow(int level) {
      //
      Widget buildButton({IconData iconData, VoidCallback onTap, double size: 20}) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              iconData,
              color: colorPalette.clickableTextLinkColor,
              size: size,
            ),
          ),
          onTap: onTap,
        );
      }

      TextEditingController textEditingController = TextEditingController();
      textEditingController.text = characterSpellList.maxSpellSlots[level].toString();
      textEditingControllers.add(textEditingController);
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: <Widget>[
            Text(
              '$level',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              width: 25,
            ),
            buildButton(
              iconData: FontAwesomeIcons.minus,
              onTap: () {
                int newValue = int.parse(textEditingControllers[level - 1].text) - 1;
                textEditingControllers[level - 1].text = '${max(newValue, 0)}';
              },
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 24,
                  color: colorPalette.mainTextColor,
                ),
                textAlign: TextAlign.center,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorPalette.tableLineColor,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorPalette.clickableTextLinkColor,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            buildButton(
              iconData: FontAwesomeIcons.plus,
              onTap: () {
                int newValue = int.parse(textEditingControllers[level - 1].text) + 1;
                textEditingControllers[level - 1].text = '${min(newValue, 5)}';
              },
            ),
          ],
        ),
      );
    }

    Widget acceptButton = FlatButton(
      color: colorPalette.buttonColor,
      child: Text(
        'EDIT',
        style: TextStyle(
          color: colorPalette.buttonTextColor,
          fontSize: 16,
        ),
      ),
      onPressed: () {
        List<dynamic> texts = [];
        for (int i = 0; i < 9; i++) {
          texts.add(textEditingControllers[i].text.toString());
        }
        bool canBeParsed = isPositiveIntList(texts);
        if (canBeParsed) {
          for (int i = 0; i < 9; i++) {
            int level = i + 1;
            int value = int.parse(texts[i]);
            characterSpellList.setMaxSlotsOfLevel(
              level: level,
              max: value,
            );
          }
          Navigator.of(context).pop();
        }
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
              child: Column(
                children: List.generate(9, (index) {
                  int level = index + 1;
                  return buildEditRow(level);
                }),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 3),
          color: colorPalette.navBarBackgroundColor,
          child: Center(
            child: acceptButton,
          ),
        ),
      ],
    );
  }
}
