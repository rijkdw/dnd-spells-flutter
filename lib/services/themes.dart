import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color _darkGrey = Color.fromRGBO(40, 40, 40, 1);
Color _mediumGrey = Color.fromRGBO(75, 75, 75, 1);
Color _lightGrey = Color.fromRGBO(175, 175, 175, 1);
Color _almostWhite = Color.fromRGBO(230, 230, 230, 1);

Color _triadicToGreen = Color.fromRGBO(9, 160, 194, 1);
Color _analogToRed = Color.fromRGBO(231, 121, 30, 1);

Map<String, ColorPalette> appColorPalettes = {
  "Druid": ColorPalette(
    brightness: Brightness.light,
    // drawer
    drawerPrimary: Colors.green[600],
    drawerSecondary: Colors.white,
    // text
    clickableTextLinkColor: Colors.green[600],
    mainTextColor: Colors.black,
    subTextColor: _mediumGrey,
    emphasisTextColor: Colors.black,
    // buttons
    buttonColor: _triadicToGreen,
    buttonTextColor: Colors.white,
    // chip on a dark background
    chipSelectedTextColor1: Colors.white,
    chipUnselectedTextColor1: Colors.black,
    chipSelectedColor1: _triadicToGreen,
    chipUnselectedColor1: Colors.green[50],
    // chip on a light background
    chipSelectedTextColor2: Colors.white,
    chipUnselectedTextColor2: Colors.black,
    chipSelectedColor2: Colors.green[900],
    chipUnselectedColor2: Colors.green[50],
    // appbar
    appBarBackgroundColor: Colors.green[600],
    // navbar
    navBarBackgroundColor: Colors.green[600],
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: _darkGrey,
    // sticky header
    stickyHeaderBackgroundColor: _triadicToGreen,
    // dialog
    dialogBackgroundColor: Colors.white,
    // table
    tableLineColor: Colors.black.withOpacity(0.7),
    // radio button
    radioSelectedColor: Colors.green[600],
    radioUnselectedColor: Colors.black.withOpacity(0.7),
    // spell slots
    spellSlotActive: Colors.green[600],
    spellSlotInactive: _lightGrey,
  ),
  "Dark Druid": ColorPalette(
    brightness: Brightness.dark,
    // drawer
    drawerPrimary: Colors.green,
    drawerSecondary: _darkGrey,
    // text
    clickableTextLinkColor: Colors.green,
    mainTextColor: Colors.white,
    subTextColor: Colors.grey,
    emphasisTextColor: Colors.green,
    // buttons
    buttonColor: Colors.green,
    buttonTextColor: Colors.white,
    // chip on a dark background
    chipSelectedColor1: Colors.green,
    chipUnselectedColor1: _darkGrey,
    chipSelectedTextColor1: Colors.white,
    chipUnselectedTextColor1: Colors.white,
    // chip on a light background
    chipSelectedTextColor2: Colors.white,
    chipUnselectedTextColor2: Colors.black,
    chipSelectedColor2: Colors.green[900],
    chipUnselectedColor2: Colors.green[50],
    // appbar
    appBarBackgroundColor: _mediumGrey,
    // navbar
    navBarBackgroundColor: _mediumGrey,
    navBarSelectedColor: Colors.green,
    navBarUnselectedColor: _lightGrey,
    // sticky header
    stickyHeaderBackgroundColor: _darkGrey,
    // dialog
    dialogBackgroundColor: _mediumGrey,
    // table
    tableLineColor: Colors.white.withOpacity(0.7),
    // radio button
    radioSelectedColor: Colors.green,
    radioUnselectedColor: Colors.white.withOpacity(0.7),
    // spell slot
    spellSlotActive: Colors.green,
    spellSlotInactive: _darkGrey,
  ),
  "Sorcerer": ColorPalette(
    brightness: Brightness.light,
    // drawer
    drawerPrimary: Colors.red[600],
    drawerSecondary: Colors.white,
    // text
    clickableTextLinkColor: _analogToRed,
    mainTextColor: Colors.black,
    subTextColor: _mediumGrey,
    emphasisTextColor: Colors.black,
    // buttons
    buttonColor: _analogToRed,
    buttonTextColor: Colors.white,
    // chip on a dark background
    chipSelectedTextColor1: Colors.white,
    chipUnselectedTextColor1: Colors.black,
    chipSelectedColor1: _analogToRed,
    chipUnselectedColor1: Colors.red[50],
    // chip on a light background
    chipSelectedTextColor2: Colors.white,
    chipUnselectedTextColor2: Colors.black,
    chipSelectedColor2: Colors.red[900],
    chipUnselectedColor2: Colors.red[50],
    // appbar
    appBarBackgroundColor: Colors.red[600],
    // navbar
    navBarBackgroundColor: Colors.red[600],
    navBarSelectedColor: Colors.white,
    navBarUnselectedColor: _darkGrey,
    // sticky header
    stickyHeaderBackgroundColor: _analogToRed,
    // dialog
    dialogBackgroundColor: Colors.white,
    // table
    tableLineColor: Colors.black.withOpacity(0.7),
    // radio button
    radioSelectedColor: Colors.red[600],
    radioUnselectedColor: Colors.black.withOpacity(0.7),
    // spell slots
    spellSlotActive: _analogToRed,
    spellSlotInactive: _lightGrey,
  ),
};
