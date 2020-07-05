enum ConditionDescriptionType { bulletedList, mixed }

class Condition {
  final dynamic map;
  Condition(this.map);

  String get name => map['name'];

  ConditionDescriptionType get type {
    switch(map['type']) {
      case 'bulletedlist':
        return ConditionDescriptionType.bulletedList;
      case 'mixed':
        return ConditionDescriptionType.mixed;
    }
    return null;
  }

  List<dynamic> get items => map['items'];

  List<dynamic> get dependsOn => map['dependsOn'];

}