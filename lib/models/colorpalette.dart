import 'package:flutter/material.dart';

class ColorPalette {

  // drawer colors
  Color drawerPrimary;

  // navbar colors
  Color navBarBackgroundColor;
  Color navBarSelectedColor;
  Color navBarUnselectedColor;

  // appbar colors
  Color appBarBackgroundColor;

  // list colors
  Color stickyHeaderBackgroundColor;

  // text colors
  Color clickableTextLinkColor;

  // button colors
  Color buttonColor;

  ColorPalette({
    this.stickyHeaderBackgroundColor: Colors.purple,
    this.navBarBackgroundColor: Colors.purple,
    this.navBarSelectedColor: Colors.green,
    this.navBarUnselectedColor: Colors.pink,
    this.appBarBackgroundColor: Colors.purple,
    this.clickableTextLinkColor: Colors.purple,
    this.drawerPrimary: Colors.purple,
    this.buttonColor: Colors.purple,
  });
}
