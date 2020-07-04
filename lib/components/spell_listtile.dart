import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SpellListTile extends StatelessWidget {
  final Spell spell;
  SpellListTile({@required this.spell});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<HistoryManager>(context, listen: false).addToHistory(spell);
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
          horizontal: 10,
          vertical: 8,
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
//            Expanded(
//              flex: 1,
//              child: Center(
//                child: FaIcon(FontAwesomeIcons.scroll, color: Color.fromRGBO(200, 0, 0, 1)),
//              ),
//            ),
            SizedBox(width: 2),
            Expanded(
              flex: 10,
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
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () => print('tapped trailing'),
                child: Container(
                  height: 30,
                  child: Icon(Icons.add),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
