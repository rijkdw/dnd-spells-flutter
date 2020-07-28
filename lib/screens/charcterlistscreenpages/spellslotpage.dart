import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/main.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpellSlotPage extends StatefulWidget {
  @override
  _SpellSlotPageState createState() => _SpellSlotPageState();
}

class _SpellSlotPageState extends State<SpellSlotPage> {
  Widget _buildDot(bool active) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    LinearGradient activeGradient = LinearGradient(
      colors: [colorPalette.navBarSelectedColor, colorPalette.navBarSelectedColor.withOpacity(0.7)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
    );

    LinearGradient inactiveGradient = LinearGradient(
        colors: [colorPalette.stickyHeaderBackgroundColor, colorPalette.stickyHeaderBackgroundColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
    );

    return Container(
      padding: EdgeInsets.only(left: 8),
      child: Container(
        height: 36,
        width: 24,
        decoration: BoxDecoration(
//          color: active ? colorPalette.navBarSelectedColor : colorPalette.stickyHeaderBackgroundColor,
          gradient: active ? activeGradient : inactiveGradient,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
//      child: CircleAvatar(
//        backgroundColor: active ? Colors.red : colorPalette.stickyHeaderBackgroundColor,
//        radius: 16,
//      ),
    );
  }

  Widget _buildRowForLevel({int level, int currentSlots, int maxSlots}) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    List<Widget> dots = [];
    for (int i = 0; i < currentSlots; i++) {
      dots.add(_buildDot(true));
    }
    for (int i = currentSlots; i < maxSlots; i++) {
      dots.add(_buildDot(false));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Level $level',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: dots,
          ),
        ),
        InkWell(
          child: Text(
            'USE',
            style: TextStyle(
              color: colorPalette.mainTextColor,
              fontSize: 18,
            ),
          ),
          onTap: () {
            CharacterSpellList spellList = Provider.of<CharacterSpellList>(context, listen: false);
            spellList.spendSpellSlotOfLevel(level);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CharacterSpellList spellList = Provider.of<CharacterSpellList>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(9, (index) {
              int level = index + 1;
              return Container(
                padding: EdgeInsets.only(bottom: 10),
                child: _buildRowForLevel(
                  level: level,
                  currentSlots: spellList.currentSpellSlots[level],
                  maxSlots: spellList.maxSpellSlots[level],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
