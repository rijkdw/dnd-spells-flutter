import 'dart:math';

// Maps

Map<int, int> getEmptySpellSlotMap() {
  Map<int, int> emptySpellSlotsMap = {};
  for (int level in List.generate(9, (index) => index + 1)) {
    emptySpellSlotsMap[level] = 0;
  }
  return emptySpellSlotsMap;
}

Map<int, int> listToSpellSlotMap(List<int> list) {
  if (list.isEmpty) return getEmptySpellSlotMap();
  Map<int, int> spellSlotMap = {};
  for (int level in List.generate(9, (index) => index + 1)) {
    spellSlotMap[level] = list[level - 1];
  }
  return spellSlotMap;
}

// Lists

bool isSubset(List<dynamic> superlist, List<dynamic> sublist) {
  print('superlist: $superlist');
  print('sublist: $sublist');
  Set<dynamic> superset = superlist.toSet();
  Set<dynamic> subset = sublist.toSet();
  for (dynamic item in subset) {
    if (!superset.contains(item)) {
      print('superset does not contain ${item.toString()}');
      return false;
    }
  }
  print('all items are in superset');
  return true;
}

bool doesListContainDuplicates(List<dynamic> list) {
  for (int i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {
      if (list[i] == list[j]) return true;
    }
  }
  return false;
}

bool listsContainSameElements(List<dynamic> a, List<dynamic> b) {
  if (a.length != b.length) return false;
  a.sort();
  b.sort();
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool isPositiveIntList(List<dynamic> list) {
  for (dynamic d in list) {
    int i;
    try {
      i = int.parse(d);
    } catch (e) {
      return false;
    }
    if (i < 0) {
      return false;
    }
  }
  return true;
}

List<dynamic> sortList(List<dynamic> inputList) {
  inputList.sort((a, b) => a.compareTo(b));
  return inputList;
}

List<dynamic> intersection(List<List<dynamic>> lists) {
  List<dynamic> returnList = lists[0].map((e) => e).toList();
  for (int i = 1; i < lists.length; i++) {
    returnList.removeWhere((e) => !lists[i].contains(e));
  }
  return returnList;
}

// Dice

int randInclusive(int min, int max) {
  return Random().nextInt(max - min + 1) + min;
}

List<int> roll(String diceString) {
  int num = int.parse(diceString.split(RegExp(r'd'))[0]);
  int size = int.parse(diceString.split(RegExp(r'd'))[1]);
  return List.generate(num, (index) => randInclusive(1, size));
}

String incrementDice(String inputDice) {
  int num = int.parse(inputDice.split(RegExp(r'd'))[0]);
  int size = int.parse(inputDice.split(RegExp(r'd'))[1]);
  return '${num + 1}d$size';
}

String decrementDice(String inputDice) {
  int num = int.parse(inputDice.split(RegExp(r'd'))[0]);
  int size = int.parse(inputDice.split(RegExp(r'd'))[1]);
  if (num == 1) return '1d$size';
  return '${num - 1}d$size';
}

// Strings

String getRandomStringOfLength(int length) {
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

String sign(int value) {
  if (value > -1)
    return '+$value';
  else
    return '$value';
}

String ordinal(int number) {
  switch (number) {
    case 1:
      return '${number}st';
    case 2:
      return '${number}nd';
    case 3:
      return '${number}rd';
    default:
      return '${number}th';
  }
}

String capitaliseFirst(String input) {
  return input[0].toUpperCase() + input.substring(1);
}

String titlecase(String input) {
  List<String> list = input.split(' ');
  for (int i = 0; i < list.length; i++) {
    list[i] = capitaliseFirst(list[i]);
  }
  return list.join(' ');
}

String plural(String item, int count, {String suffix: 's'}) {
  if (count == 1) return item;
  return item + suffix;
}

Map<String, String> extractClassAndSubclass(String classSubclass) {
  RegExp pattern = RegExp(r'(.*)\((.*?)\)');
  if (classSubclass.contains('(') && classSubclass.contains(')')) {
    String className = (pattern.firstMatch(classSubclass)[1] ?? '').trim();
    String subclassName = (pattern.firstMatch(classSubclass)[2] ?? '').trim();
    return {
      'class': className,
      'subclass': subclassName,
    };
  }
  return {
    'class': classSubclass,
    'subclass': '',
  };
}

// Time

bool isThisYear(DateTime dateTime) => dateTime.year == DateTime.now().year;
bool isThisMonth(DateTime dateTime) => isThisYear(dateTime) && dateTime.month == DateTime.now().month;
bool isToday(DateTime dateTime) => isThisMonth(dateTime) && dateTime.day == DateTime.now().day;

bool isYesterday(DateTime dateTime) => isToday(dateTime.add(Duration(days: 1)));
bool isInPastWeek(DateTime dateTime) => dateTime.add(Duration(days: 7)).isAfter(DateTime.now());
bool isInPastMonth(DateTime dateTime) => dateTime.add(Duration(days: 31)).isAfter(DateTime.now());

String getShortDay(DateTime dateTime) {
  if (isToday(dateTime)) return 'today';
  if (isYesterday(dateTime)) return 'yesterday';
  if (isInPastWeek(dateTime)) return 'this week';
  if (isInPastMonth(dateTime)) return 'this month';
  return 'earlier';
}

String getHHMM(DateTime dateTime) => '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
