class Spell {

  String get name => '';
  String get subtitle => '';
  String get range => '';
  String get castingTime => '';
  String get duration => '';
  String get components => '';
  List<String> get classes => [];
  List<String> get description => [];

}

class FakeSpell extends Spell {

  @override
  String get name => 'Fireball';

  @override
  String get subtitle => '3rd level evocation';

  @override
  String get range => '60 feet';

  @override
  String get castingTime => '1 action';

  @override
  String get duration => 'Instantaneous';

  @override
  String get components => 'VSM (guano)';

  @override
  List<String> get classes => ['Wizard', 'Sorcerer'];

  @override
  List<String> get description => ['Do 8d6 fire damage.', 'Can be upcast.'];

}