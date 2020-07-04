import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpellHistoryTile extends StatelessWidget {
  final Spell spell;
  SpellHistoryTile({@required this.spell});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
          vertical: 6,
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
              flex: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${spell.name}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${spell.subtitle}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Provider.of<HistoryManager>(context, listen: false).removeFromHistory(spell);
                },
                splashColor: Colors.transparent,
                child: SizedBox(
                  height: 37,
                  width: 37,
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
