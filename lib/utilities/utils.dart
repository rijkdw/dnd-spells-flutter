import 'dart:math';

import 'package:flutter/cupertino.dart';

// Maps

Map<int, int> getEmptySpellSlotMap() {
  Map<int, int> emptySpellSlotsMap = {};
  for (int level in List.generate(9, (index) => index+1)) {
    emptySpellSlotsMap[level] = 0;
  }
  return emptySpellSlotsMap;
}

Map<int, int> listToSpellSlotMap(List<int> list) {
  if (list.isEmpty) return getEmptySpellSlotMap();
  Map<int, int> spellSlotMap = {};
  for (int level in List.generate(9, (index) => index+1)) {
    spellSlotMap[level] = list[level-1];
  }
  return spellSlotMap;
}

// Lists

bool doesListContainDuplicates(List<dynamic> list) {
  for (int i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {
      if (list[i] == list[j]) return true;
    }
  }
  return false;
}

List<dynamic> sortList(List<dynamic> inputList) {
  inputList.sort((a, b) => a.compareTo(b));
  return inputList;
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
