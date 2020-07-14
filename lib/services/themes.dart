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
    drawerPrimary: Colors.green,
    clickableTextLinkColor: Color.fromRGBO(0, 150, 0, 1),
    appBarBackgroundColor: Colors.green,
    navBarBackgroundColor: Colors.green,
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: _darkGrey,
    stickyHeaderBackgroundColor: Color.fromRGBO(0, 100, 0, 1),
    buttonColor: Colors.green,
    mainTextColor: Colors.black,
    subTextColor: _darkGrey,
    emphasisTextColor: Colors.black,
    chipSelectedTextColor: Colors.green,
    chipUnselectedTextColor: Colors.black,
    chipSelectedColor: Color.fromRGBO(180, 255, 180, 1),
    chipUnselectedColor: _almostWhite,
    buttonTextColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    tableLineColor: Colors.black.withOpacity(0.7),
  ),
  "Druid (Dark)": ColorPalette(
    brightness: Brightness.dark,
    drawerPrimary: Colors.green,
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
