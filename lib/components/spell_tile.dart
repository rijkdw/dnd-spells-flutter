import 'package:dnd_spells_flutter/components/add_to_spell_list_dialog.dart';
import 'package:dnd_spells_flutter/components/dialogmenu.dart';
import 'package:dnd_spells_flutter/models/characteroption.dart';
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

BoxDecoration spellTileDecoration = BoxDecoration(
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
);

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
//      onLongPress: () {},
//      onLongPress: () {
//        showDialog(
//          context: context,
//          builder: (context) => _LongPressMenuDialog(spell: spell),
//        );
//      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 3),
        decoration: spellTileDecoration,
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
              child: NameSubtitleColumn(spell),
            ),
            Expanded(
//              flex: 0,
//              child: Container(
//                height: 54,
//              ),
              flex: 2,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  showDialog(context: context, builder: (context) => _LongPressMenuDialog(spell: spell));
                },
                child: Container(
//                  color: Colors.blue,
                  height: 54,
                  child: Icon(
                    Icons.more_vert,
                    color: Provider.of<ThemeManager>(context).colorPalette.clickableTextLinkColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSpellTile extends StatelessWidget {
  final Spell spell;
  final List<Widget> children;
  final double height;

  CustomSpellTile({this.spell, this.children, this.height: 55});

  Route _spellScreenRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return SpellInfoScreen(
          spell: spell,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<HistoryManager>(context, listen: false).addToHistory(SpellView.now(spellName: spell.name));
        return Navigator.of(context).push(_spellScreenRoute());
      },
      child: Container(
        width: double.infinity,
        height: height,
        padding: EdgeInsets.only(left: 10, right: 3),
        decoration: spellTileDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this.children,
        ),
      ),
    );
  }
}

class NameSubtitleColumn extends StatelessWidget {
  final Spell spell;
  NameSubtitleColumn(this.spell);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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
            color: Provider.of<ThemeManager>(context).colorPalette.subTextColor,
          ),
        ),
      ],
    );
  }
}

class _LongPressMenuDialog extends StatelessWidget {
  final Spell spell;
  _LongPressMenuDialog({@required this.spell});

  @override
  Widget build(BuildContext context) {
    return DialogMenu(
      heading: Text(
        '${spell.name}',
        style: TextStyle(fontSize: 24),
      ),
      menuOptions: [
        MenuOption(
          text: 'Add to list',
          iconData: Icons.add,
          onTap: () => showDialog(
            context: context,
            builder: (context) => AddToListDialog(spell: this.spell),
          ),
        )
      ],
    );
  }
}

class SpellTileLeading extends StatelessWidget {
  final Spell spell;

  SpellTileLeading({this.spell});

  @override
  Widget build(BuildContext context) {
    IconData iconData = {
      CharacterOptionType.class_: FontAwesomeIcons.hatWizard,
      CharacterOptionType.subclass: FontAwesomeIcons.hatWizard,
      CharacterOptionType.race: FontAwesomeIcons.child,
      CharacterOptionType.subrace: FontAwesomeIcons.child,
      null: FontAwesomeIcons.question
    }[spell.characterOptionType];
    double iconSize = {
      CharacterOptionType.class_: 20.0,
      CharacterOptionType.subclass: 20.0,
      CharacterOptionType.race: 20.0,
      CharacterOptionType.subrace: 20.0,
      null: 20.0
    }[spell.characterOptionType];

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {},
      child: Icon(
        iconData,
        size: iconSize,
        color: Provider.of<ThemeManager>(context).colorPalette.buttonColor,
      ),
    );
  }
}
