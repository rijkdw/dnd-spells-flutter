import 'dart:convert';

import 'package:dnd_spells_flutter/utilities/utils.dart';

class Spell {
  final Map<dynamic, dynamic> map;
  Spell(this.map);

  String get name => map['name'];

  int get level => map['level'];

  String get levelAsString {
    if (level == 0)
      return 'cantrip';
    else return '$level${ordinal(level)}';
  }

  String get school => map['school'];

  String get subtitle {
    // eg. Evocation cantrip
    String levelAndSchool = '';
    if (level == 0)
      levelAndSchool = '${capitaliseFirst('$school cantrip')}';
    // eg. 1st-level evocation
    else
      levelAndSchool = '${ordinal(level)}-level ${school.toString().toLowerCase()}';

    return '$levelAndSchool${isRitual ? ' (ritual)' : ''}';
  }

  String get subtitleWithMetaTags {
    List<String> tags = [];
    if (level == 0)
      tags.add('${capitaliseFirst('$school cantrip')}');
    else
      tags.add('${ordinal(level)}-level ${school.toString().toLowerCase()}');
    if (isConcentration) tags.add('C');
    if (isRitual) tags.add('R');
    return tags.join('  •  ');
  }

  String get range {
    String type = map['range']['type'];
    switch (type) {
      // if it's a point spell
      case 'point':
        String pointType = map['range']['distance']['type'];
        switch (pointType) {
          case 'self':
            return 'Self';
          case 'touch':
            return 'Touch';
          case 'feet':
            return '${map['range']['distance']['amount']} feet';
          case 'miles':
            return '${map['range']['distance']['amount']} miles';
          case 'sight':
            return 'Sight';
          case 'unlimited':
            return 'Unlimited';
        }
        return 'point_undefined';
      case 'radius':
      case 'hemisphere':
        // it's either feet or miles
        String radiusUnit = map['range']['distance']['type'];
        dynamic radiusNumber = map['range']['distance']['amount'];
        return 'Self ($radiusNumber-$radiusUnit radius)';
      case 'sphere':
        // it's either feet or miles
        String radiusUnit = map['range']['distance']['type'];
        dynamic radiusNumber = map['range']['distance']['amount'];
        return 'Self ($radiusNumber-$radiusUnit sphere)';
      case 'cone':
        // it's either feet or miles
        String radiusUnit = map['range']['distance']['type'];
        dynamic radiusNumber = map['range']['distance']['amount'];
        return 'Self ($radiusNumber-$radiusUnit cone)';
      case 'special':
        return 'Special';
      case 'line':
        // it's either feet or miles
        String radiusUnit = map['range']['distance']['type'];
        dynamic radiusNumber = map['range']['distance']['amount'];
        return 'Self ($radiusNumber-$radiusUnit line)';
      case 'cube':
        // it's either feet or miles
        String radiusUnit = map['range']['distance']['type'];
        dynamic radiusNumber = map['range']['distance']['amount'];
        return 'Self ($radiusNumber-$radiusUnit cube)';
      default:
        return '??';
    }
  }

  String get castingTime {
    bool flagSeeBelow = false;
    List<String> castingTimes = [];
    map['time'].forEach((time) {
      String timeUnit = time['unit'];
      dynamic timeNumber = time['number'];
      castingTimes.add('$timeNumber ${plural(timeUnit, timeNumber)}');
    });
    if (castingTimes.length > 1) flagSeeBelow = true;
    String clause = flagSeeBelow ? ' (see below)' : '';
    return capitaliseFirst('${castingTimes.join(' or ')}$clause');
  }

  String get duration {
    bool flagSeeBelow = false;
    List<String> durations = [];
    map['duration'].forEach((dur) {
      switch (dur['type']) {
        case 'instant':
          durations.add('instantaneous');
          break;
        case 'permanent':
          durations.add('permanent');
          break;
        case 'timed':
          String durUnits = dur['duration']['type'];
          dynamic durNumber = dur['duration']['amount'];
          durations.add('$durNumber ${plural(durUnits, durNumber)}');
          break;
        case 'special':
          flagSeeBelow = true;
          durations.add('other');
          break;
        default:
          durations.add('??');
          break;
      }
    });
    if (durations.length > 1) flagSeeBelow = true;
    String clause = flagSeeBelow ? ' (see below)' : '';
    return capitaliseFirst('${durations.join(' or ')}$clause');
  }

  bool get isConcentration {
    if (map['duration'][0].keys.contains('concentration')) return map['duration'][0]['concentration'] == true;
    return false;
  }

  bool get isRitual {
    if (!map.keys.contains('meta')) return false;
    if (map['meta'].keys.contains('ritual')) return map['meta']['ritual'] == true;
    return false;
  }

  String get durationAndConcentration {
    if (isConcentration) return duration + ' (concentration)';
    return duration;
  }

  String get vsm {
    return map['components'].keys.toList().join(', ').toUpperCase();
  }

  String get materialComponents {
    if (map['components']['m'].runtimeType == String) return map['components']['m'] ?? 'no material components';
    return map['components']['m']['text'];
  }

  String get components {
    if (map['components']['m'] != null) return '$vsm ($materialComponents)';
    return vsm;
  }

  // TODO: fix classes
  List<String> get classes => ['Wizard', 'Sorcerer', 'Warlock'];

  List<dynamic> get description {
    List<dynamic> entries = map['entries'];
    List<dynamic> entriesAsString = entries.map((e) {
      if (e is String)
        return e;
      else
        return Map<String, dynamic>.from(e);
    }).toList();
    return entriesAsString;
  }

  bool get hasHigherLevels {
    return map.keys.contains('entriesHigherLevel');
  }

  String get atHigherLevels {
    if (hasHigherLevels) {
      return map['entriesHigherLevel'][0]['entries'][0];
    }
    return 'ERROR NO HIGHER LEVELS';
  }

  List<String> get inflictsConditions {
    List<String> conditions = List<String>.from(map['conditionInflict'] ?? []);
    return conditions;
  }
}
