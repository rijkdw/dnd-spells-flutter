import 'dart:convert';

import 'package:dnd_spells_flutter/models/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConditionRepository extends ChangeNotifier {

  Map<String, Condition> _conditionsMap = {};

  Condition getConditionFromName(String name) => _conditionsMap[name];

  ConditionRepository() {
    print('Constructing conditionrepo');
    _loadConditionsFromLocal();
  }

  void _loadConditionsFromLocal() async {
    print('fetching conditions from local');
    String jsonString = await rootBundle.loadString('assets/conditions.json');
    List<Map<String, dynamic>> jsonDecoded = List<Map<String, dynamic>>.from(json.decode(jsonString));
    jsonDecoded.forEach((map) {
      print(map['name']);
      _conditionsMap[map['name']] = Condition(map);
    });
    notifyListeners();
  }

}