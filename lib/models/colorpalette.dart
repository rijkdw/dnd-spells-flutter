import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorPalette {

  // brightness
  Brightness brightness;

  // drawer colors
  Color drawerPrimary;

  // navbar colors
  Color navBarBackgroundColor;
  Color navBarSelectedColor;
  Color navBarUnselectedColor;

  // appbar colors
  Color appBarBackgroundColor;

  // chip colors
  Color chipUnselectedColor;
  Color chipUnselectedTextColor;
  Color chipSelectedColor;
  Color chipSelectedTextColor;

  // list colors
  Color stickyHeaderBackgroundColor;

  // text colors
  Color mainTextColor;
  Color emphasisTextColor;
  Color subTextColor;
  Color clickableTextLinkColor;

  // dialog colors
  Color dialogBackgroundColor;

  // button colors
  Color buttonColor;
  Color buttonTextColor;

  ColorPalette({
    this.brightness: Brightness.light,
    this.mainTextColor: Colors.green,
    this.stickyHeaderBackgroundColor: Colors.purple,
    this.navBarBackgroundColor: Colors.purple,
    this.navBarSelectedColor: Colors.green,
    this.navBarUnselectedColor: Colors.pink,
    this.appBarBackgroundColor: Colors.purple,
    this.clickableTextLinkColor: Colors.purple,
    this.drawerPrimary: Colors.purple,
    this.buttonColor: Colors.purple,
    this.subTextColor: Colors.green,
    this.chipSelectedColor: Colors.purple,
    this.chipSelectedTextColor: Colors.green,
    this.chipUnselectedColor: Colors.black,
    this.dialogBackgroundColor: Colors.purple,
    this.emphasisTextColor: Colors.purple,
    this.buttonTextColor: Colors.green,
    this.chipUnselectedTextColor: Colors.purple,
  });
}
