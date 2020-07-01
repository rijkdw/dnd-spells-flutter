class Spell {

  String get name => '';
  String get subtitle => '';

}

class FakeSpell extends Spell {

  @override
  String get name => 'Fireball';

  @override
  String get subtitle => '3rd level evocation';

}