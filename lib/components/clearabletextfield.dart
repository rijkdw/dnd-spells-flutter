import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClearableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback onCleared;
  ClearableTextField({@required this.hintText, @required this.controller, this.onChanged, this.onCleared});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 6),
        Expanded(
          child: TextField(
            onChanged: (newValue) => onChanged(newValue),
            controller: this.controller,
            cursorColor: Provider.of<ThemeManager>(context).colorPalette.emphasisTextColor,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              hintText: this.hintText,
              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Provider.of<ThemeManager>(context).colorPalette.subTextColor,
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
                size: 15,
                color: Provider.of<ThemeManager>(context).colorPalette.emphasisTextColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
