import 'package:dnd_spells_flutter/components/add_to_spell_list_dialog.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SpellListTile extends StatelessWidget {
  final Spell spell;
  SpellListTile({@required this.spell});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<HistoryManager>(context, listen: false).addToHistory(SpellView.now(spellName: spell.name));
        Scaffold.of(context).removeCurrentSnackBar();
        return Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SpellInfoScreen(
            spell: spell,
          ),
        ));
      },
//      onLongPress: () {
//        showDialog(
//          context: context,
//          builder: (context) => _LongPressMenuDialog(text: 'buttsauce'),
//        );
//      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 3),
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
              flex: 15,
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
                    spell.subtitleWithMetaTags,
                    style: TextStyle(
//                    fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Provider<Spell>.value(
                      value: spell,
                      child: AddToListDialog(),
                    ),
                  );
                },
                child: Container(
//                  color: Colors.blue,
                  height: 54,
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

class _LongPressMenuDialog extends StatelessWidget {
  final String text;
  _LongPressMenuDialog({@required this.text});

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
              '$text',
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
