import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClearableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback onCleared;
  final bool autofocus;
  ClearableTextField({@required this.hintText, @required this.controller, this.onChanged, this.onCleared, this.autofocus: false});

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            autofocus: this.autofocus,
            onChanged: (newValue) => onChanged(newValue),
            controller: this.controller,
            cursorColor: colorPalette.emphasisTextColor,
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20),
            decoration: InputDecoration(
              hintText: this.hintText,
              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: colorPalette.subTextColor.withOpacity(0.6),
                    fontSize: 20,
                  ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorPalette.stickyHeaderBackgroundColor),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorPalette.stickyHeaderBackgroundColor),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            this.controller.clear();
            onCleared();
          },
          splashColor: Colors.transparent,
          child: Container(
            width: 30,
            height: 50,
            child: Center(
              child: Icon(
                Icons.close,
                size: 20,
                color: colorPalette.emphasisTextColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
