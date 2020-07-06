import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:flutter/material.dart';

Map<String, ColorPalette> appColorPalettes = {
  "Sorcerer": ColorPalette(
    appBarBackgroundColor: Colors.red,
    navBarBackgroundColor: Colors.red,
    navBarUnselectedColor: Colors.black87,
    navBarSelectedColor: Colors.white,
    stickyHeaderBackgroundColor: Color.fromRGBO(150, 0, 0, 1),
    clickableTextLinkColor: Color.fromRGBO(200, 0, 0, 1),
    drawerPrimary: Colors.red,
  ),
  "Wizard": ColorPalette(
    drawerPrimary: Colors.blue,
    clickableTextLinkColor: Color.fromRGBO(0, 0, 200, 1),
    appBarBackgroundColor: Colors.blue,
    navBarBackgroundColor: Colors.blue,
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: Colors.black87,
    stickyHeaderBackgroundColor: Color.fromRGBO(0, 0, 200, 1),
  ),
  "Druid": ColorPalette(
    drawerPrimary: Colors.green,
    clickableTextLinkColor: Color.fromRGBO(0, 150, 0, 1),
    appBarBackgroundColor: Colors.green,
    navBarBackgroundColor: Colors.green,
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: Colors.black87,
    stickyHeaderBackgroundColor: Color.fromRGBO(0, 100, 0, 1),
  ),
};
