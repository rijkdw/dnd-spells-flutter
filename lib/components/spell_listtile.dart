import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpellListTile extends StatelessWidget {
  final Spell spell;
  SpellListTile({@required this.spell});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO:  Add this spell to the view history
        Scaffold.of(context).removeCurrentSnackBar();
        return Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SpellInfoScreen(
            spell: spell,
          ),
        ));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(Icons.favorite_border),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    spell.name,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    spell.subtitle,
                    style: TextStyle(
//                    fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () => print('tapped trailing'),
                child: Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
    );
  }
}
