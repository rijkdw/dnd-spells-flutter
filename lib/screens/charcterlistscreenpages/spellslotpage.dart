import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
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
        end: Alignment.bottomCenter);

    LinearGradient inactiveGradient = LinearGradient(
        colors: [colorPalette.stickyHeaderBackgroundColor, colorPalette.stickyHeaderBackgroundColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);

    return Container(
      padding: EdgeInsets.only(left: 8),
      child: Container(
        height: 36,
        width: 24,
        decoration: BoxDecoration(
          color: active ? colorPalette.navBarSelectedColor : colorPalette.stickyHeaderBackgroundColor,
//          gradient: active ? activeGradient : inactiveGradient,
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

    if (maxSlots == 0) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'LEVEL $level',
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
              color: colorPalette.clickableTextLinkColor,
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
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ListView(
          children: [
            SizedBox(height: 20),
            _CharacterStatsWidget(),
            SizedBox(height: 32),
            ...List.generate(
              9,
              (index) {
                int level = index + 1;
                return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: _buildRowForLevel(
                    level: level,
                    currentSlots: spellList.currentSpellSlots[level],
                    maxSlots: spellList.maxSpellSlots[level],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _CharacterStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterSpellList>(
      builder: (context, spellList, child) {
        ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
        Widget buildValueScroller({VoidCallback onUp, VoidCallback onDown, String heading, String value}) {
          InkWell buildButton(String text, VoidCallback onTap, {double fontsize: 24}) {
            return InkWell(
              child: Container(
                width: 24,
                height: 30,
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontsize,
                      color: colorPalette.clickableTextLinkColor,
                    ),
                  ),
                ),
              ),
              onTap: onTap,
            );
          }

          return Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
//              SizedBox(
//                width: 4,
//              ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildButton('+', onUp),
                          buildButton('-', onDown, fontsize: 30),
                        ],
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      heading,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildValueScroller(
              heading: 'Num Spells',
              value: '${spellList.numSpellsPrepared}',
              onUp: () => spellList.numSpellsPrepared++,
              onDown: () => spellList.numSpellsPrepared--,
            ),
            SizedBox(width: 20),
            buildValueScroller(
              heading: 'Attack Bonus',
              value: '${sign(spellList.spellAttackBonus)}',
              onUp: () => spellList.spellAttackBonus++,
              onDown: () => spellList.spellAttackBonus--,
            ),
            SizedBox(width: 20),
            buildValueScroller(
              heading: 'Save DC',
              value: '${spellList.saveDC}',
              onUp: () => spellList.saveDC++,
              onDown: () => spellList.saveDC--,
            )
          ],
        );
      },
    );
  }
}
