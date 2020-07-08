import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
        color: Provider.of<ThemeManager>(context).colorPalette.dialogBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$_dice',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 14),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                // increment the dice number
                Container(
                  width: 45,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Provider.of<ThemeManager>(context).colorPalette.buttonColor,
                    onPressed: _onIncrementDice,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.plus,
                        size: 15,
                        color: Provider.of<ThemeManager>(context).colorPalette.buttonTextColor,
                      ),
                    ),
                  ),
                ),

                FlatButton(
                  color: Provider.of<ThemeManager>(context).colorPalette.buttonColor,
                  onPressed: _rollButtonPush,
                  child: Text(
                    'ROLL',
                    style: TextStyle(
                      color: Provider.of<ThemeManager>(context).colorPalette.buttonTextColor,
                      fontSize: 18,
                    ),
                  ),
                ),

                // decrement the dice number
                Container(
                  width: 45,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Provider.of<ThemeManager>(context).colorPalette.buttonColor,
                    onPressed: _onDecrementDice,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.minus,
                        size: 15,
                        color: Provider.of<ThemeManager>(context).colorPalette.buttonTextColor,
                      ),
                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
