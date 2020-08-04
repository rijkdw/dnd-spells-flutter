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
    try {
      _nameController.text = searchManager.currentSearchParameters['name'][0];
    } catch (e) {
      _nameController.text = '';
    }
    try {
      _descController.text = searchManager.currentSearchParameters['description'][0];
    } catch (e) {
      _descController.text = '';
    }

  }

  void _clearAll() {
    print('Clear ALL filters');
    FocusScope.of(context).unfocus();
    setState(() {
      _nameController.clear();
      _descController.clear();
      selectedOptions = {};
      SearchManager searchManager = Provider.of<SearchManager>(context, listen: false);
      searchManager.allSearchOptions.keys.forEach((key) {
        selectedOptions[key] = [];
      });
      SpellRepository spellRepository = Provider.of(context, listen: false);
      spellRepository.searchResults = spellRepository.allSpells;
    });
  }

  void _search() {
    // add name and description
    selectedOptions['name'] = [_nameController.text];
    selectedOptions['description'] = [_descController.text];
    SpellRepository spellRepository = Provider.of(context, listen: false);
    spellRepository.searchResults = Provider.of<SearchManager>(context, listen: false).filterSpells(spellRepository.allSpells, selectedOptions);
  }

  void selectUnselectOption({String key, String option, bool select}) {
    setState(() {
      if (select) {
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
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 4),
                        child: ClearableTextField(
                          hintText: 'Name',
                          controller: _nameController,
                          onCleared: () {
                            setState(() {
                              _nameController.text = '';
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 4),
                        child: ClearableTextField(
                          hintText: 'Description',
                          controller: _descController,
                          onCleared: () {
                            setState(() {
                              _descController.text = '';
                            });
                          },
                        ),
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
                                      capitaliseFirst(option),
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
                                selectUnselectOption(select: newValue, key: key, option: option);
                              },
                              selected: (selectedOptions[key] ?? []).contains(option),
                            ),
                          );
                        }).toList();
                        return Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: colorPalette.mainTextColor,
                            accentColor: colorPalette.clickableTextLinkColor,
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${key.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 1.2,
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
                                padding: EdgeInsets.only(bottom: 8, left: 12, right: 12),
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
