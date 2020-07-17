import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/condition.dart';
import 'package:dnd_spells_flutter/services/conditionrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ConditionPopup extends StatelessWidget {
  final String conditionName;
  ConditionPopup({@required this.conditionName});

  @override
  Widget build(BuildContext context) {

    ConditionRepository conditionRepository = Provider.of<ConditionRepository>(context, listen: false);
    print(conditionRepository);

    Condition mainCondition = conditionRepository.getConditionFromName(conditionName);
    // TODO at the start, mainCondition is null.  WHY?
    List<Condition> conditionsDependedOn = mainCondition.dependsOn.map((dependedConditionName) {
      return conditionRepository.getConditionFromName(dependedConditionName.toString());
    }).toList();

    ScrollController scrollController = ScrollController();

    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        child: Container(
          color: Provider.of<ThemeManager>(context).colorPalette.dialogBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 3 / 4,
            ),
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                controller: scrollController,
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
                        color: Provider.of<ThemeManager>(context).colorPalette.clickableTextLinkColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    _ConditionDescription(mainCondition),
                    _DependedOnDescriptionList(conditionsDependedOn),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DependedOnDescriptionList extends StatelessWidget {

  final List<Condition> conditionsDependedOn;
  _DependedOnDescriptionList(this.conditionsDependedOn);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: conditionsDependedOn.map((condition) {
        return Container(
          padding: EdgeInsets.only(top: 12),
          child: _ConditionDescription(condition),
        );
      }).toList(),
    );
  }
}

class _ConditionDescription extends StatelessWidget {
  final Condition condition;
  _ConditionDescription(this.condition);

  Widget _buildConditionDescription(Condition condition) {
    switch (condition.type) {
      case ConditionDescriptionType.bulletedList:
        if (condition.items.length == 1)
          return Text(
            condition.items[0],
            style: TextStyle(fontSize: 18),
          );
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '${capitaliseFirst(condition.name)}',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _buildConditionDescription(Provider.of<ConditionRepository>(context).getConditionFromName(condition.name))
      ],
    );
  }
}
