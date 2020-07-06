import 'dart:math';

import 'package:flutter/cupertino.dart';

int randInclusive(int min, int max) {
  return Random().nextInt(max - min + 1) + min;
}

List<int> roll(String diceString) {
  int num = int.parse(diceString.split(RegExp(r'd'))[0]);
  int size = int.parse(diceString.split(RegExp(r'd'))[1]);
  return List.generate(num, (index) => randInclusive(1, size));
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

String plural(String item, int count, {String suffix: 's'}) {
  if (count == 1) return item;
  return item + suffix;
}

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
