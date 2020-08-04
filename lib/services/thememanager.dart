import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  ColorPalette _colorPalette = appColorPalettes[appColorPalettes.keys.toList()[0]];
  String _paletteName = appColorPalettes.keys.toList()[0];

  ColorPalette get colorPalette => _colorPalette ?? ColorPalette();
  String get paletteName => _paletteName;

  ThemeManager() {
    _loadFromLocal();
  }

  void setColorPalette(String newPaletteName) {
    _colorPalette = appColorPalettes[newPaletteName];
    _paletteName = newPaletteName;
    notifyListeners();
    _storeInLocal();
  }

  // Storage

  final String _keyThemeNameStorage = 'theme_name';

  void _loadFromLocal() async {
    print('Loading theme name from local');
    SharedPreferences.getInstance().then((prefs) {
      String themeName = prefs.getString(_keyThemeNameStorage) ?? appColorPalettes.keys.toList()[0];
      setColorPalette(themeName);
      notifyListeners();
    });
  }

  void _storeInLocal() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyThemeNameStorage, paletteName);
  }
}
