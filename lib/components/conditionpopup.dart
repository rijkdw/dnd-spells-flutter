import 'package:dnd_spells_flutter/models/condition.dart';
import 'package:dnd_spells_flutter/services/conditionrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class ConditionPopup extends StatelessWidget {
  final String conditionName;
  ConditionPopup({@required this.conditionName});

  @override
  Widget build(BuildContext context) {
    Widget _buildConditionDescription(Condition condition) {
      switch (condition.type) {
        case ConditionDescriptionType.bulletedList:
          return Text(
            condition.items.map((e) => '\u2022 ${e.toString()}').toList().join('\n'),
            style: TextStyle(fontSize: 18),
          );
        case ConditionDescriptionType.mixed:
          return Text(
            'mixed',
            style: TextStyle(fontSize: 30),
          );
      }
      return Container();
    }

    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        color: Provider.of<ThemeManager>(context).colorPalette.dialogBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 2 / 3,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25),
                Text(
                  'CONDITION',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.5,
                    color: Provider.of<ThemeManager>(context).colorPalette.emphasisTextColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '${capitaliseFirst(conditionName)}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _buildConditionDescription(Provider.of<ConditionRepository>(context).getConditionFromName(conditionName)),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConditionDescription extends StatelessWidget {
  final Condition condition;
  _ConditionDescription(this.condition);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
