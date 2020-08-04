import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class SpellSlotPage extends StatefulWidget {
  @override
  _SpellSlotPageState createState() => _SpellSlotPageState();
}

class _SpellSlotPageState extends State<SpellSlotPage> {
  Widget _buildDot({bool active, int index, int level}) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;

    return Container(
      padding: EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: () {
          CharacterSpellList spellList = Provider.of<CharacterSpellList>(context, listen: false);
          spellList.setCurrentSpellSlotAtLevel(level: level, count: index + 1);
        },
        child: Container(
          height: 36,
          width: 24,
          decoration: BoxDecoration(
            color: active ? colorPalette.spellSlotActive : colorPalette.spellSlotInactive,
            borderRadius: BorderRadius.circular(100),
          ),
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
      dots.add(_buildDot(
        active: true,
        index: i,
        level: level,
      ));
    }
    for (int i = currentSlots; i < maxSlots; i++) {
      dots.add(_buildDot(
        active: false,
        index: i,
        level: level,
      ));
    }

    if (maxSlots == 0) return Container();

    CharacterSpellList spellList = Provider.of<CharacterSpellList>(context, listen: false);
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
              color: spellList.currentSpellSlots[level] > 0 ? colorPalette.clickableTextLinkColor : colorPalette.spellSlotInactive,
              fontSize: 18,
            ),
          ),
          onTap: () {
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
        //
        Widget buildValueScroller({VoidCallback onUp, VoidCallback onDown, String heading, String value}) {
          //
          InkWell buildButton(String text, VoidCallback onTap, {double fontSize: 24}) {
            return InkWell(
              child: Container(
//                width: 24,
//                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
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
                          buildButton('—', onDown),
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
