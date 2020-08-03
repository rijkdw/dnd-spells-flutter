import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorPalette {
  // brightness
  Brightness brightness;

  // drawer colors
  Color drawerPrimary;
  Color drawerSecondary;

  // navbar colors
  Color navBarBackgroundColor;
  Color navBarSelectedColor;
  Color navBarUnselectedColor;

  // appbar colors
  Color appBarBackgroundColor;

  // chip colors
  Color chipUnselectedColor1;
  Color chipUnselectedTextColor1;
  Color chipSelectedColor1;
  Color chipSelectedTextColor1;

  Color chipUnselectedColor2;
  Color chipUnselectedTextColor2;
  Color chipSelectedColor2;
  Color chipSelectedTextColor2;

  // list colors
  Color stickyHeaderBackgroundColor;

  // text colors
  Color mainTextColor;
  Color emphasisTextColor;
  Color subTextColor;
  Color clickableTextLinkColor;
  Color tableLineColor;

  // dialog colors
  Color dialogBackgroundColor;

  // button colors
  Color buttonColor;
  Color buttonTextColor;
  Color radioSelectedColor;
  Color radioUnselectedColor;

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
    this.drawerSecondary: Colors.green,
    this.buttonColor: Colors.purple,
    this.subTextColor: Colors.green,
    this.chipSelectedColor1: Colors.purple,
    this.chipSelectedTextColor1: Colors.green,
    this.chipUnselectedColor1: Colors.black,
    this.dialogBackgroundColor: Colors.purple,
    this.emphasisTextColor: Colors.purple,
    this.buttonTextColor: Colors.green,
    this.chipUnselectedTextColor1: Colors.purple,
    this.tableLineColor = Colors.green,
    this.radioSelectedColor = Colors.red,
    this.radioUnselectedColor = Colors.blue,
  });
}
