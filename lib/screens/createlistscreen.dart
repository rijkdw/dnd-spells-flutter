import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Create Spell List'),
      ),
      body: CreateListForm(),
    );
  }
}

class CreateListForm extends StatefulWidget {
  @override
  _CreateListFormState createState() => _CreateListFormState();
}

class _CreateListFormState extends State<CreateListForm> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClearableTextField(
                  controller: nameController,
                  hintText: 'List name',
                  onCleared: () {},
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              SpellListCreateActionResult result = Provider.of<SpellListManager>(context, listen: false).createSpellList(nameController.text.trim());
              if (result == SpellListCreateActionResult.nameError) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Duplicate spell list name'),
                ));
              } else {
                Navigator.of(context).pop();
              }
            },
            color: colorPalette.buttonColor,
            child: Text(
              'CREATE',
              style: TextStyle(color: colorPalette.buttonTextColor),
            ),
          )
        ],
      ),
    );
  }
}
