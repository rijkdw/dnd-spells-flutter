import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';

class DiceRollerDialog extends StatefulWidget {
  final String dice;
  DiceRollerDialog({@required this.dice});

  @override
  _DiceRollerDialogState createState() => _DiceRollerDialogState();
}

class _DiceRollerDialogState extends State<DiceRollerDialog> {
  List<int> _diceRolls;
  bool _initialState;
  TextEditingController _diceStringController = TextEditingController();

  @override
  void initState() {
    _diceRolls = [];
    _initialState = true;
    _diceStringController.text = widget.dice;
    super.initState();
  }

  void _rollButtonPush() {

    setState(() {
      _initialState = false;
      _diceRolls = roll(_diceStringController.text);
    });
  }

  int _diceRollsTotal() {
    int total = 0;
    _diceRolls.forEach((e) => total += e);
    return total;
  }

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
            TextFormField(
              controller: _diceStringController,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
              cursorColor: Colors.red,
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(4),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              _initialState ? '' : '${_diceRollsTotal()}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 70),
            ),
            SizedBox(height: 10),
            Text(
              _diceRolls.join(', '),
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: _rollButtonPush,
              child: Text(
                'ROLL',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
