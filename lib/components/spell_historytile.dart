import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpellHistoryTile extends StatelessWidget {
  final SpellView spellView;
  SpellHistoryTile({@required this.spellView});

  @override
  Widget build(BuildContext context) {
    Spell spell = Provider.of<SpellRepository>(context).getSpellFromName(spellView.spellName);

    try {
      return InkWell(
        onTap: () {
          return Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SpellInfoScreen(
                  spell: spell,
                ),
          ));
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 6, 6, 6),
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
                flex: 10,
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
                    Text(
                      'Viewed ${spellView.historyTileTimestamp}',
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
                    Provider.of<HistoryManager>(context, listen: false).removeFromHistory(spellView);
                  },
                  splashColor: Colors.transparent,
                  child: Container(
                    height: 50,
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
    } catch (e) {
      return Container();
    }
  }
}
