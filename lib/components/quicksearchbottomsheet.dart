import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class QuickSearchBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: QuickSearchForm(),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'QUICK SEARCH',
          style: TextStyle(letterSpacing: 0.6, fontSize: 20),
        ),
        SizedBox(height: 10),
        ClearableTextField(
          controller: queryController,
          hintText: _getHintText(),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Search for'
            ),
            ChoiceChip(
              label: Text('NAME'),
              selected: selection == QuickSearchSelection.name,
              onSelected: (_) => _handleSelection(QuickSearchSelection.name),
            ),
            ChoiceChip(
              label: Text('DESCRIPTION'),
              selected: selection == QuickSearchSelection.description,
              onSelected: (_) => _handleSelection(QuickSearchSelection.description),
            ),
          ],
        )
      ],
    );
  }
}
