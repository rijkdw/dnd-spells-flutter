import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiceRollerDialog extends StatefulWidget {
  final String dice;
  DiceRollerDialog({@required this.dice});

  @override
  _DiceRollerDialogState createState() => _DiceRollerDialogState();
}

class _DiceRollerDialogState extends State<DiceRollerDialog> {
  List<int> _diceRolls;
  bool _initialState;
  String _dice;

  @override
  void initState() {
    _diceRolls = [];
    _initialState = true;
    _dice = widget.dice;
    super.initState();
  }

  void _rollButtonPush() {
    setState(() {
      _initialState = false;
      _diceRolls = roll(_dice);
    });
  }

  int _diceRollsTotal() {
    int total = 0;
    _diceRolls.forEach((e) => total += e);
    return total;
  }

  void _onIncrementDice() {
    setState(() {
      _dice = incrementDice(_dice);
    });
  }

  void _onDecrementDice() {
    setState(() {
      _dice = decrementDice(_dice);
    });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // increment the dice number
                Container(
                  width: 40,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Theme.of(context).primaryColor,
                    onPressed: _onIncrementDice,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.plus,
                        size: 15,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),

                // display the dice number
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    '$_dice',
                    style: TextStyle(fontSize: 30),
                  ),
                ),

                // decrement the dice number
                Container(
                  width: 40,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Theme.of(context).primaryColor,
                    onPressed: _onDecrementDice,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.minus,
                        size: 15,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              ],
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
