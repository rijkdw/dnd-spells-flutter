import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class CreateListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Create new spell list'),
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
  String selectedClass, selectedSubclass;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    selectedClass = '';
    selectedSubclass = '';
    super.initState();
  }

  bool verifyInputs() {
    if (nameController.text.trim().length == 0) return false;
    if (selectedClass == '') return false;
    if (selectedSubclass == '') return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double gridviewRatio = 5.5;
    int gridviewRowCount = 2;

    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    SpellRepository spellRepository = Provider.of<SpellRepository>(context);

    Widget _buildRadioRow({String text, String groupValue, Function(String) onChanged}) {
      return Theme(
        data: ThemeData(
          unselectedWidgetColor: colorPalette.mainTextColor.withOpacity(0.6),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            onChanged(text);
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 25,
                height: 25,
                child: Center(
                  child: Radio(
                    value: text,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                ),
              ),
              SizedBox(width: 7),
              Text(text),
            ],
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClearableTextField(
                      controller: nameController,
                      hintText: 'List name',
                      onCleared: () {},
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Class',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: gridviewRowCount,
                      childAspectRatio: gridviewRatio,
                      children: spellRepository.classToSubclassMap.keys
                          .map((className) => _buildRadioRow(
                              text: className,
                              groupValue: selectedClass,
                              onChanged: (newClassName) {
                                setState(() {
                                  selectedClass = newClassName;
                                  selectedSubclass = '';
                                });
                              }))
                          .toList(),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Subclass',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: gridviewRowCount,
                      childAspectRatio: gridviewRatio,
                      children: (spellRepository.classToSubclassMap[selectedClass] ?? [])
                          .map((subclassName) => _buildRadioRow(
                              text: subclassName,
                              groupValue: selectedSubclass,
                              onChanged: (newSubclassName) {
                                setState(() {
                                  selectedSubclass = newSubclassName;
                                });
                              }))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            if (verifyInputs()) {
              SpellListCreateActionResult result = Provider.of<SpellListManager>(context, listen: false)
                  .createSpellList(SpellList(name: nameController.text.trim(), className: selectedClass, subclassName: selectedSubclass));
              if (result == SpellListCreateActionResult.nameError) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Duplicate spell list name'),
                ));
              } else {
                Navigator.of(context).pop();
              }
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Incomplete'),
              ));
            }
          },
          color: colorPalette.buttonColor,
          child: Text(
            'CREATE',
            style: TextStyle(color: colorPalette.buttonTextColor),
          ),
        ),
      ],
    );
  }
}
