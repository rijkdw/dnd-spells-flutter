import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class QuickSearchBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      splashColor: Colors.transparent,
      child: Container(
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
    selection = QuickSearchSelection.name;
  }

  void _handleSelection(QuickSearchSelection newSelection) {
    setState(() => selection = newSelection);
    // TODO tell search manager it's changed
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
              onChanged: (newValue) => print(newValue),
              controller: queryController,
              hintText: _getHintText(),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Search for'),
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
