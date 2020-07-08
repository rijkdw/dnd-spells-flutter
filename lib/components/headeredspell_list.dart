import 'package:dnd_spells_flutter/components/spell_listtile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

enum OrderBy { name, level, school }

class HeaderedSpellList extends StatefulWidget {
  final List<Spell> spells;
  final OrderBy orderBy;

  HeaderedSpellList({@required this.spells, @required this.orderBy, Key key}) : super(key: key ?? UniqueKey()); // : super(key: UniqueKey()); (why?)

  @override
  _HeaderedSpellListState createState() => _HeaderedSpellListState();
}

class _HeaderedSpellListState extends State<HeaderedSpellList> {
//  ScrollController scrollController = ScrollController();
  List<_SliverExpandableStickyHeader> headers;

  bool allExpanded = true;

  @override
  initState() {
    super.initState();
    headers = _getAllSplits();
  }

//  void
//
//  void _expandAllButtonPress() {
//    print('Expand all');
//    setState(() {
//      allExpanded = !allExpanded;
//    });
//  }

  List<_SliverExpandableStickyHeader> _getAllSplits() {
    List<_SliverExpandableStickyHeader> splitByLevel() {
      widget.spells.sort((a, b) => a.level.compareTo(b.level));
      List<dynamic> values = [];
      widget.spells.forEach((spell) {
        if (!values.contains(spell.level)) values.add(spell.level);
      });
      List<_SliverExpandableStickyHeader> returnList = [];

      int valueIndex = 0;
      List<Spell> spellsWithCurrentValue = [];
      for (Spell spell in widget.spells) {
        if (spell.level != values[valueIndex]) {
          // end of this list
          if (spellsWithCurrentValue.isNotEmpty) {
            if (values[valueIndex] == 0)
              returnList.add(_SliverExpandableStickyHeader(
                header: 'Cantrip',
                spells: spellsWithCurrentValue,
              ));
            else
              returnList.add(_SliverExpandableStickyHeader(
                header: 'Level ${values[valueIndex]}',
                spells: spellsWithCurrentValue,
              ));
          }
          // reset step
          valueIndex++;
          spellsWithCurrentValue = [];
        }
        spellsWithCurrentValue.add(spell);
      }
      if (spellsWithCurrentValue.isNotEmpty)
        returnList.add(_SliverExpandableStickyHeader(
          header: 'Level ${values.last}',
          spells: spellsWithCurrentValue,
        ));

      return returnList;
    }

    List<_SliverExpandableStickyHeader> splitByName() {
      widget.spells.sort((a, b) => a.name.compareTo(b.name));
      List<dynamic> values = [];
      widget.spells.forEach((spell) {
        String firstLetter = spell.name[0];
        if (!values.contains(firstLetter)) values.add(firstLetter);
      });
      List<_SliverExpandableStickyHeader> returnList = [];

      int valueIndex = 0;
      List<Spell> spellsWithCurrentValue = [];
      for (Spell spell in widget.spells) {
        if (spell.name[0] != values[valueIndex]) {
          // end of this list
          if (spellsWithCurrentValue.isNotEmpty)
            returnList.add(_SliverExpandableStickyHeader(
              header: '${values[valueIndex].toString().toUpperCase()}',
              spells: spellsWithCurrentValue,
            ));
          // reset step
          valueIndex++;
          spellsWithCurrentValue = [];
        }
        spellsWithCurrentValue.add(spell);
      }
      if (spellsWithCurrentValue.isNotEmpty)
        returnList.add(_SliverExpandableStickyHeader(
          header: '${values[valueIndex].toString().toUpperCase()}',
          spells: spellsWithCurrentValue,
        ));

      return returnList;
    }

    List<_SliverExpandableStickyHeader> splitBySchool() {
      widget.spells.sort((a, b) => a.school.compareTo(b.school));
      List<dynamic> values = [];
      widget.spells.forEach((spell) {
        if (!values.contains(spell.school)) values.add(spell.school);
      });
      List<_SliverExpandableStickyHeader> returnList = [];

      int valueIndex = 0;
      List<Spell> spellsWithCurrentValue = [];
      for (Spell spell in widget.spells) {
        if (spell.school != values[valueIndex]) {
          // end of this list
          if (spellsWithCurrentValue.isNotEmpty)
            returnList.add(_SliverExpandableStickyHeader(
              header: '${values[valueIndex]}',
              spells: spellsWithCurrentValue,
            ));
          // reset step
          valueIndex++;
          spellsWithCurrentValue = [];
        }
        spellsWithCurrentValue.add(spell);
      }
      if (spellsWithCurrentValue.isNotEmpty)
        returnList.add(_SliverExpandableStickyHeader(
          header: '${values.last}',
          spells: spellsWithCurrentValue,
        ));

      return returnList;
    }

    switch (this.widget.orderBy) {
      case OrderBy.level:
        return splitByLevel();
      case OrderBy.name:
        return splitByName();
      case OrderBy.school:
        return splitBySchool();
      default:
        return splitByLevel();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < -10) {
          print('You swiped right');
        }
      },
      child: Stack(
        children: <Widget>[
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: CustomScrollView(
              controller: scrollController,
              shrinkWrap: true,
              slivers: headers,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(6),
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton(
                  mini: true,
                  heroTag: null,
                  onPressed: () {
                    scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  backgroundColor: Provider.of<ThemeManager>(context).colorPalette.buttonColor,
                  child: Icon(
                    Icons.arrow_upward,
                    color: Provider.of<ThemeManager>(context).colorPalette.buttonTextColor,
                  ),
                ),
//                SizedBox(height: 2, width: 2),
                FloatingActionButton(
                  mini: true,
                  heroTag: null,
                  onPressed: () {},
                  backgroundColor: Provider.of<ThemeManager>(context).colorPalette.buttonColor,
                  child: Icon(
                    Icons.expand_less,
                    color: Provider.of<ThemeManager>(context).colorPalette.buttonTextColor,
                  ),
                ),
//                SizedBox(height: 2, width: 2),
                FloatingActionButton(
                  mini: true,
                  heroTag: null,
                  onPressed: () {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  backgroundColor: Provider.of<ThemeManager>(context).colorPalette.buttonColor,
                  child: Icon(
                    Icons.arrow_downward,
                    color: Provider.of<ThemeManager>(context).colorPalette.buttonTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class _SliverExpandableStickyHeader extends StatefulWidget {
  final List<Spell> spells;
  final String header;
  final bool expanded;

  _SliverExpandableStickyHeader({this.header, this.spells, this.expanded});

  @override
  _SliverExpandableStickyHeaderState createState() => _SliverExpandableStickyHeaderState();
}

class _SliverExpandableStickyHeaderState extends State<_SliverExpandableStickyHeader> {
  bool _expanded;
  GlobalKey scrollKey;

  @override
  void initState() {
    super.initState();
    scrollKey = GlobalKey();
    _expanded = widget.expanded ?? true;
  }

  void _toggleShowExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void compress() {
    setState(() {
      _expanded = false;
    });
  }

  void _jumpTo() {
    Scrollable.ensureVisible(scrollKey.currentContext);
  }

  @override
  Widget build(BuildContext context) {
    widget.spells.sort((a, b) => a.name.compareTo(b.name));

    return SliverStickyHeader(
      key: scrollKey,
      header: InkWell(
        onTap: () => _toggleShowExpanded(),
        child: Container(
          height: 35.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: Provider.of<ThemeManager>(context).colorPalette.stickyHeaderBackgroundColor,
            ),
            color: Provider.of<ThemeManager>(context).colorPalette.stickyHeaderBackgroundColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Text(
                  widget.header.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Text(
                  '${widget.spells.length} spells'.toUpperCase(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 4),
            ],
          ),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          (_expanded ? widget.spells : []).map((spell) => SpellListTile(spell: spell)).toList(),
        ),
      ),
    );
  }
}
