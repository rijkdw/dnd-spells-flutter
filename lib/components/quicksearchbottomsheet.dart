import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class QuickSearchBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      splashColor: Colors.transparent,
      child: Container(
        color: Provider.of<ThemeManager>(context).colorPalette.dialogBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: QuickSearchForm(),
      ),
    );
  }
}

class QuickSearchForm extends StatefulWidget {
  @override
  _QuickSearchFormState createState() => _QuickSearchFormState();
}

enum QuickSearchSelection { name, description }

class _QuickSearchFormState extends State<QuickSearchForm> {
  QuickSearchSelection selection;
  TextEditingController queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selection = Provider.of<SearchManager>(context, listen: false).lastSelection;
    switch (selection) {
      case QuickSearchSelection.name:
        queryController.text = Provider.of<SearchManager>(context, listen: false).nameToken;
        break;
      case QuickSearchSelection.description:
        queryController.text = Provider.of<SearchManager>(context, listen: false).descriptionToken;
        break;
    }
  }

  void _handleSelection(QuickSearchSelection newSelection) {
    setState(() => selection = newSelection);
    print('The quick search selection changed!');
    Provider.of<SearchManager>(context, listen: false).quickSearch(queryController.text, selection);
  }

  String _getHintText() {
    switch (selection) {
      case QuickSearchSelection.name:
        return 'Search name';
      case QuickSearchSelection.description:
        return 'Search description';
    }
    return '??';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'QUICK SEARCH',
              style: TextStyle(letterSpacing: 0.6, fontSize: 20),
            ),
            SizedBox(height: 10),
            ClearableTextField(
              onChanged: (newValue) {
                print('The quick search token changed!');
                Provider.of<SearchManager>(context, listen: false).quickSearch(queryController.text, selection);
              },
              onCleared: () {
                Provider.of<SearchManager>(context, listen: false).quickSearch(queryController.text, selection);
              },
              controller: queryController,
              hintText: _getHintText(),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'SEARCH FOR',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                ChoiceChip(
                  label: Text('Name'),
                  selected: selection == QuickSearchSelection.name,
                  onSelected: (_) => _handleSelection(QuickSearchSelection.name),
                ),
                ChoiceChip(
                  label: Text('Description'),
                  selected: selection == QuickSearchSelection.description,
                  onSelected: (_) => _handleSelection(QuickSearchSelection.description),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
