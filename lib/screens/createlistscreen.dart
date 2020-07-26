import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/characteroptionrepository.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Set<String> selectedClasses = Set<String>();
  Set<String> selectedSubclasses = Set<String>();
  Set<String> classOptions = Set<String>();
  Set<String> subclassOptions = Set<String>();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // initialise classOptions
    classOptions = Provider.of<CharacterOptionRepository>(context, listen: false).allClassNames.toSet();
  }

  void loadSubclassOptions() {
    subclassOptions.clear();
    Map<String, List<String>> namesMap = Provider.of<CharacterOptionRepository>(context, listen: false).getNamesMap();
    for (String selectedClassName in selectedClasses) {
      namesMap[selectedClassName].forEach((subclassName) {
        subclassOptions.add(subclassName);
      });
    }
    List<String> selectedSubclassesList = selectedSubclasses.toList();
    for (int i = 0; i < selectedSubclassesList.length; i++) {
      String selectedSubclass = selectedSubclassesList[i];
      if (!subclassOptions.contains(selectedSubclass)) {
        selectedSubclasses.remove(selectedSubclass);
        selectedSubclassesList.remove(selectedSubclass);
        i--;
      }
    }
  }

  bool verifyInputs() {
    if (nameController.text.trim().length == 0) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double gridviewRatio = 4;
    int gridviewRowCount = 2;

    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    void onConfirmPress() {
      {
        if (verifyInputs()) {
          SpellListCreateActionResult result = Provider.of<SpellListManager>(context, listen: false).createSpellList(
            SpellList(
              name: nameController.text.trim(),
              className: 'A',
              subclassName: 'A',
            ),
          );
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
      }
    }

    Widget _buildRadioRow({String text, String groupValue, Function(String) onChanged}) {
      return Theme(
        data: ThemeData(
          unselectedWidgetColor: colorPalette.radioUnselectedColor,
          accentColor: colorPalette.radioSelectedColor,
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
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
                    onChanged: (text) {
                      FocusScope.of(context).unfocus();
                      onChanged(text);
                    },
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

    Widget _buildFilterChip({String label, Set<String> set, Function(String) onChanged}) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        child: FilterChip(
          selected: set.contains(label),
          label: Row(
            children: <Widget>[
              Expanded(
                child: Text(label),
              ),
            ],
          ),
          onSelected: (newValue) {
            FocusScope.of(context).unfocus();
            List<String> selectedBaseValues = [];
            if (set == selectedSubclasses) {
              for (String selectedSubclass in [...selectedSubclasses, label].toSet().toList()) {
                String baseclassName = Provider.of<CharacterOptionRepository>(context, listen: false).getReverseNamesMap()[selectedSubclass];
                selectedBaseValues.add(baseclassName);
              }
            }
            if (!doesListContainDuplicates(selectedBaseValues)) {
              setState(() {
                if (newValue) {
                  set.add(label);
                } else {
                  set.remove(label);
                }
              });
              loadSubclassOptions();
            }
          },
        ),
      );
    }

    Widget _buildHeading({String text: 'HEADING', VoidCallback onButtonPress, bool visible: true}) {
      if (!visible) return Container();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          IconButton(
            onPressed: onButtonPress,
            icon: Icon(
              FontAwesomeIcons.trash,
              color: colorPalette.emphasisTextColor,
              size: 20,
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
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
                    Text('Class'),
                    SizedBox(height: 3),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: gridviewRowCount,
                      childAspectRatio: gridviewRatio,
                      children: classOptions.toList().map((className) {
                        return _buildFilterChip(
                          label: className,
                          set: selectedClasses,
                        );
                      }).toList(),
                    ),
                    ...selectedClasses
                        .toList()
                        .map((selectedClass) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 14),
                                subclassOptions.isEmpty ? Container() : Text('$selectedClass'),
                                SizedBox(height: 3),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: gridviewRowCount,
                                  childAspectRatio: gridviewRatio,
                                  children: Provider.of<CharacterOptionRepository>(context, listen: false)
                                      .getNamesMap()[selectedClass]
                                      .toList()
                                      .map((subclassName) {
                                    return _buildFilterChip(
                                      label: subclassName,
                                      set: selectedSubclasses,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 3),
          color: colorPalette.navBarBackgroundColor,
          child: Center(
            child: FlatButton(
              onPressed: onConfirmPress,
              color: colorPalette.buttonColor,
              child: Text(
                'CREATE',
                style: TextStyle(color: colorPalette.buttonTextColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
