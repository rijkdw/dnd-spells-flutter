import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  Map<String, List<String>> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedOptions = {};
    SearchManager searchManager = Provider.of<SearchManager>(context, listen: false);
    searchManager.allSearchOptions.keys.forEach((key) {
      selectedOptions[key] = (searchManager.currentSearchParameters[key] ?? []);
    });
  }

  void _clearAll() {
    print('Clear ALL filters');
    setState(() {
      _nameController.clear();
      _descController.clear();
      selectedOptions = {};
      SearchManager searchManager = Provider.of<SearchManager>(context, listen: false);
      searchManager.allSearchOptions.keys.forEach((key) {
        selectedOptions[key] = [];
      });
      _search();
    });
  }

  void _search() {
    SpellRepository spellRepository = Provider.of(context, listen: false);
    spellRepository.searchResults = Provider.of<SearchManager>(context, listen: false).filterSpells(spellRepository.allSpells, selectedOptions);
  }

  void selectUnselectOption({String key, String option, bool addBool}) {
    setState(() {
      if (addBool) {
        selectedOptions[key].add(option);
        selectedOptions[key] = selectedOptions[key].toSet().toList();
      } else
        selectedOptions[key].remove(option);
    });
  }

  @override
  Widget build(BuildContext context) {
    SearchManager searchManager = Provider.of<SearchManager>(context);
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    Map<String, List<dynamic>> allSearchOptions = searchManager.allSearchOptions;

    double gridviewRatio = 4;
    int gridviewRowCount = 2;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Search & Filter',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _clearAll,
            icon: Icon(
              FontAwesomeIcons.trash,
              size: 20,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClearableTextField(
                        hintText: 'Name',
                        controller: _nameController,
                        onCleared: () {},
                      ),
                      ClearableTextField(
                        hintText: 'Description',
                        controller: _descController,
                        onCleared: () {},
                      ),
                      ...allSearchOptions.keys.map((key) {
                        List<Widget> childrenOfThisKey = allSearchOptions[key].map((option) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            child: FilterChip(
                              checkmarkColor: colorPalette.chipSelectedTextColor1,
                              label: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        color: (selectedOptions[key] ?? []).contains(option)
                                            ? colorPalette.chipSelectedTextColor1
                                            : colorPalette.chipUnselectedTextColor1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onSelected: (newValue) {
                                FocusScope.of(context).unfocus();
                                selectUnselectOption(addBool: newValue, key: key, option: option);
                              },
                              selected: (selectedOptions[key] ?? []).contains(option),
                            ),
                          );
                        }).toList();
                        return Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: colorPalette.mainTextColor,
                            accentColor: colorPalette.clickableTextLinkColor,
                          ),
                          child: ExpansionTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${titlecase(key)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: colorPalette.mainTextColor,
                                    ),
                                  ),
                                ),
                                selectedOptions[key].length > 0
                                    ? Text('${selectedOptions[key].length}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: colorPalette.mainTextColor,
                                        ))
                                    : Container(),
                              ],
                            ),
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 8),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: gridviewRowCount,
                                  childAspectRatio: gridviewRatio,
                                  children: childrenOfThisKey,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
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
                onPressed: () {
                  _search();
                  Navigator.of(context).pop();
                },
                color: colorPalette.buttonColor,
                child: Text(
                  'SEARCH',
                  style: TextStyle(color: colorPalette.buttonTextColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
