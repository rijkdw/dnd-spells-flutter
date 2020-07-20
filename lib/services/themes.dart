import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color _darkGrey = Color.fromRGBO(40, 40, 40, 1);
Color _mediumGrey = Color.fromRGBO(75, 75, 75, 1);
Color _lightGrey = Color.fromRGBO(175, 175, 175, 1);
Color _almostWhite = Color.fromRGBO(230, 230, 230, 1);

Map<String, ColorPalette> appColorPalettes = {
  "Druid": ColorPalette(
    brightness: Brightness.light,
    drawerPrimary: Colors.green[600],
    drawerSecondary: Colors.white,
    clickableTextLinkColor: Colors.green[600],
    appBarBackgroundColor: Colors.green[600],
    navBarBackgroundColor: Colors.green[600],
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: _darkGrey,
    stickyHeaderBackgroundColor: Colors.green[900],
    buttonColor: Colors.green[900],
    mainTextColor: Colors.black,
    subTextColor: _darkGrey,
    emphasisTextColor: Colors.black,
    chipSelectedTextColor: Colors.white,
    chipUnselectedTextColor: Colors.black,
    chipSelectedColor: Colors.green[900],
    chipUnselectedColor: Colors.green[50],
    buttonTextColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    tableLineColor: Colors.black.withOpacity(0.7),
  ),
  "Druid (Dark)": ColorPalette(
    brightness: Brightness.dark,
    drawerPrimary: Colors.green,
    drawerSecondary: _darkGrey,
    clickableTextLinkColor: Colors.green,
    appBarBackgroundColor: _mediumGrey,
    navBarBackgroundColor: _mediumGrey,
    navBarSelectedColor: Colors.green,
    navBarUnselectedColor: _lightGrey,
    stickyHeaderBackgroundColor: _darkGrey,
    buttonColor: Colors.green,
    mainTextColor: Colors.white,
    subTextColor: Colors.grey,
    chipSelectedColor: Colors.green,
    chipUnselectedColor: _darkGrey,
    chipSelectedTextColor: Colors.white,
    chipUnselectedTextColor: Colors.white,
    dialogBackgroundColor: _mediumGrey,
    emphasisTextColor: Colors.green,
    buttonTextColor: Colors.white,
    tableLineColor: Colors.white.withOpacity(0.7),
  ),
};
