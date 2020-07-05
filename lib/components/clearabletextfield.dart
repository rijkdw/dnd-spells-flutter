import 'package:flutter/material.dart';

class ClearableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  ClearableTextField({this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
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