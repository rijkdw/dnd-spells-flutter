import 'package:dnd_spells_flutter/components/add_to_spell_list_dialog.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spellview.dart';
import 'package:dnd_spells_flutter/screens/spellinfoscreen.dart';
import 'package:dnd_spells_flutter/services/historymanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SpellTile extends StatelessWidget {
  final Spell spell;
  SpellTile({@required this.spell});

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
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => _LongPressMenuDialog(spell: spell),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 3),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 0.5,
            ),
            top: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 0.5,
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
                      color: Provider.of<ThemeManager>(context).colorPalette.subTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                height: 54,
              ),
//              flex: 2,
//              child: InkWell(
//                splashColor: Colors.transparent,
//                onTap: () {
//                  showDialog(
//                    context: context,
//                    builder: (context) => Provider<Spell>.value(
//                      value: spell,
//                      child: AddToListDialog(),
//                    ),
//                  );
//                },
//                child: Container(
////                  color: Colors.blue,
//                  height: 54,
//                  child: Icon(
//                    Icons.add,
//                    color: Provider.of<ThemeManager>(context).colorPalette.clickableTextLinkColor,
//                  ),
//                ),
//              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpellGridTile extends StatelessWidget {
  final Spell spell;
  SpellGridTile({@required this.spell});

  Widget _buildCompactSpellAttributeLine({@required Widget leading, @required String text}) {
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 22,
            child: leading,
          ),
          Text(
            text,
            softWrap: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            color: Colors.grey[300],
            blurRadius: 2,
          )
        ],
      ),
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
//              fontStyle: FontStyle.italic,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8),

          // casting time
          Expanded(
            child: _buildCompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.hourglassHalf, size: 14),
              text: spell.castingTime,
            ),
          ),

          // components
          Expanded(
            child: _buildCompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.mortarPestle, size: 14),
              text: spell.vsm,
            ),
          ),

          // range
          Expanded(
            child: _buildCompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.draftingCompass, size: 14),
              text: spell.range,
            ),
          ),

          // duration
          Expanded(
            child: _buildCompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.hourglassEnd, size: 14),
              text: spell.duration,
            ),
          ),

          // classes
          Expanded(
            child: _buildCompactSpellAttributeLine(
              leading: FaIcon(FontAwesomeIcons.hatWizard, size: 14),
              text: spell.classesList.join(', '),
            ),
          ),
        ],
      ),
    );
  }
}

class _LongPressMenuDialog extends StatelessWidget {
  final Spell spell;
  _LongPressMenuDialog({@required this.spell});

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context, listen: false).colorPalette;

    Widget _buildMenuOptionRow({@required IconData iconData, @required String text, @required VoidCallback onTap}) {
      return InkWell(
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
                color: colorPalette.clickableTextLinkColor,
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
              )
            ],
          ),
        ),
      );
    }

    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: colorPalette.dialogBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${spell.name}',
              style: TextStyle(fontSize: 24),
            ),
            Divider(),
            _buildMenuOptionRow(
              text: 'Add to list',
              iconData: Icons.add,
              onTap: () => showDialog(
                context: context,
                builder: (context) => AddToListDialog(spell: this.spell),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
