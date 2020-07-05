import 'package:flutter/material.dart';

class ClearableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  ClearableTextField({@required this.hintText, @required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            onChanged: (newValue) => onChanged(newValue),
            controller: this.controller,
            decoration: InputDecoration(
              hintText: this.hintText,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            this.controller.clear();
          },
          splashColor: Colors.transparent,
          child: Container(
            width: 30,
            height: 50,
            child: Center(
              child: Icon(Icons.close, size: 15),
            ),
          ),
        )
      ],
    );
  }
}