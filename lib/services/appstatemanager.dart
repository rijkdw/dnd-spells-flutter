import 'package:flutter/foundation.dart';

enum DisplayMode { list, grid }

class AppStateManager extends ChangeNotifier {

  DisplayMode globalDisplayMode = DisplayMode.list;

  void switchDisplayMode() {
    if (globalDisplayMode == DisplayMode.list)
      globalDisplayMode = DisplayMode.grid;
    else
      globalDisplayMode = DisplayMode.list;
    notifyListeners();
  }

}