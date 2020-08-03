import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/characteroptionrepository.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  TextEditingController raceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // initialise classOptions
    classOptions = Provider.of<CharacterOptionRepository>(context, listen: false).allClassNames.toSet();
  }

  void loadSubclassOptions() {
    subclassOptions.clear();
    Map<String, List<String>> namesMap = Provider.of<CharacterOptionRepository>(context, listen: false).getClassNamesMap();
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

  bool willBeGenericList() {
    return (selectedClasses.isEmpty && selectedSubclasses.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    double gridviewRatio = 4;
    int gridviewRowCount = 2;

    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    void onConfirmPress() {
      {
        if (verifyInputs()) {
          AbstractSpellList spellList;
          if (willBeGenericList())
            spellList = GenericSpellList(
              name: nameController.text,
            );
          else
            spellList = CharacterSpellList(
              name: nameController.text,
              raceName: extractClassAndSubclass(raceController.text)['class'],
              subraceName: extractClassAndSubclass(raceController.text)['subclass'] ?? '',
              classNames: selectedClasses.toList(),
              subclassNames: selectedSubclasses.toList(),
            );
          SpellListCreateActionResult result = Provider.of<SpellListManager>(context, listen: false).createSpellList(spellList);
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
                String baseclassName = Provider.of<CharacterOptionRepository>(context, listen: false).getReverseClassNamesMap()[selectedSubclass];
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

    final inputDecoration = InputDecoration(
      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
            color: colorPalette.subTextColor.withOpacity(0.6),
            fontSize: 20,
          ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: colorPalette.stickyHeaderBackgroundColor),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: colorPalette.stickyHeaderBackgroundColor),
      ),
    );

    CharacterOptionRepository characterOptionRepository = Provider.of<CharacterOptionRepository>(context, listen: false);

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
                    TextField(
                      controller: nameController,
                      decoration: inputDecoration.copyWith(hintText: 'Name'),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20),
                      textCapitalization: TextCapitalization.words,
                    ),
                    TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          textCapitalization: TextCapitalization.words,
                          decoration: inputDecoration.copyWith(hintText: 'Race'),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20),
                          textInputAction: TextInputAction.done,
                          controller: raceController,
                          onSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          }),
                      suggestionsCallback: (pattern) async {
                        List<String> suggestions = characterOptionRepository.getRaceNameSuggestions(pattern);
                        if (raceController.text.isNotEmpty) {
                          suggestions = [raceController.text, ...suggestions];
                        }
                        return suggestions.toSet().toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion,
                            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        raceController.text = suggestion;
                      },
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Class',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
                    ),
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
                    ...selectedClasses.toList().map((selectedClass) {
                      if (subclassOptions.isEmpty || characterOptionRepository.subclassesBelongingTo(selectedClass).isEmpty) {
                        return Container();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 14),
                          Text(
                            '$selectedClass',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: 3),
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: gridviewRowCount,
                            childAspectRatio: gridviewRatio,
                            children: sortList(characterOptionRepository.getClassNamesMap()[selectedClass].toList()).map((subclassName) {
                              return _buildFilterChip(
                                label: subclassName,
                                set: selectedSubclasses,
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
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
