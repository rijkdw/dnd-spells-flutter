import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Map<String, ColorPalette> appColorPalettes = {
  "Sorcerer": ColorPalette(
    appBarBackgroundColor: Colors.red,
    navBarBackgroundColor: Colors.red,
    navBarUnselectedColor: Color.fromRGBO(41, 41, 41, 1),
    navBarSelectedColor: Colors.white,
    stickyHeaderBackgroundColor: Color.fromRGBO(150, 0, 0, 1),
    clickableTextLinkColor: Color.fromRGBO(200, 0, 0, 1),
    drawerPrimary: Colors.red,
    buttonColor: Colors.red,
  ),
  "Wizard": ColorPalette(
    drawerPrimary: Colors.blue,
    clickableTextLinkColor: Color.fromRGBO(0, 77, 153, 1),
    appBarBackgroundColor: Colors.blue,
    navBarBackgroundColor: Colors.blue,
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: Color.fromRGBO(41, 41, 41, 1),
    stickyHeaderBackgroundColor: Color.fromRGBO(0, 77, 153, 1),
    buttonColor: Colors.blue,
  ),
  "Druid": ColorPalette(
    drawerPrimary: Colors.green,
    clickableTextLinkColor: Color.fromRGBO(0, 150, 0, 1),
    appBarBackgroundColor: Colors.green,
    navBarBackgroundColor: Colors.green,
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: Color.fromRGBO(41, 41, 41, 1),
    stickyHeaderBackgroundColor: Color.fromRGBO(0, 100, 0, 1),
    buttonColor: Colors.green,
  ),
  "Druid (Dark)": ColorPalette(
    brightness: Brightness.dark,
    drawerPrimary: Colors.green,
    clickableTextLinkColor: Color.fromRGBO(0, 150, 0, 1),
    appBarBackgroundColor: Colors.green,
    navBarBackgroundColor: Colors.green,
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: Color.fromRGBO(41, 41, 41, 1),
    stickyHeaderBackgroundColor: Color.fromRGBO(0, 100, 0, 1),
    buttonColor: Colors.green,
  )
};
