import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  Map<String, List<String>> selectedOptions;
  
  void _clearAll() {
    print('Clear ALL filters');
    _nameController.clear();
    _descController.clear();
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
            icon: Icon(Icons.clear),
          )
        ],
      ),
      body: ScrollConfiguration(
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
                        label: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(option),
                            ),
                          ],
                        ),
                        onSelected: (newValue) => print(option),
                      ),
                    );
                  }).toList();
                  return Theme(
                    data: Theme.of(context).copyWith(unselectedWidgetColor: colorPalette.mainTextColor),
                    child: ExpansionTile(
                      title: Text(
                        titlecase(key),
                        style: TextStyle(
                          fontSize: 20,
                          color: colorPalette.mainTextColor,
                        ),
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
    );
  }
}
