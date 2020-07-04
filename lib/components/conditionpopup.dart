import 'package:flutter/material.dart';

class ConditionPopup extends StatelessWidget {
  final String conditionName;
  ConditionPopup({@required this.conditionName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$conditionName',
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
