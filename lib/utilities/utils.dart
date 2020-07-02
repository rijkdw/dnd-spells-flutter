import 'dart:math';

int randInclusive(int min, int max) {
  return Random().nextInt(max-min+1) + min;
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
    default:
      return '${number}th';
  }
}

String capitaliseFirst(String input) {
  return input[0].toUpperCase() + input.substring(1);
}
