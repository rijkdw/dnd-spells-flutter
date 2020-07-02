import 'dart:math';

int randInclusive(int min, int max) {
  return Random().nextInt(max-min+1) + min;
}

List<int> roll(String diceString) {
  int num = int.parse(diceString.split(RegExp(r'd'))[0]);
  int size = int.parse(diceString.split(RegExp(r'd'))[1]);
  return List.generate(num, (index) => randInclusive(1, size));
}