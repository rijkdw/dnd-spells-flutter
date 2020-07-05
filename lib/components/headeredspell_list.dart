import 'package:dnd_spells_flutter/components/spell_listtile.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/appstatemanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

enum OrderBy { name, level, school }

class HeaderedSpellList extends StatefulWidget {
  final List<Spell> spells;
  final OrderBy orderBy;

  HeaderedSpellList({@required this.spells, @required this.orderBy}) : super(key: UniqueKey());

  @override
  _HeaderedSpellListState createState() => _HeaderedSpellListState();
}

class _HeaderedSpellListState extends State<HeaderedSpellList> {

  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  List<_SliverExpandableStickyHeader> headers;

  @override
  initState() {
    super.initState();
    headers = _getAllSplits();
  }

  List<_SliverExpandableStickyHeader> _getAllSplits() {
    List<_SliverExpandableStickyHeader> splitByLevel() {
      widget.spells.sort((a, b) => a.level.compareTo(b.level));
      List<dynamic> values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
      List<_SliverExpandableStickyHeader> returnList = [];

      int valueIndex = 0;
      List<Spell> spellsWithCurrentValue = [];
      for (Spell spell in widget.spells) {
        if (spell.level != values[valueIndex]) {
          // end of this list
          if (values[valueIndex] == 0)
            returnList.add(_SliverExpandableStickyHeader('Cantrip', spellsWithCurrentValue));
          else
            returnList.add(_SliverExpandableStickyHeader('Level ${values[valueIndex]}', spellsWithCurrentValue));
          // reset step
          valueIndex++;
          spellsWithCurrentValue = [];
        }
        spellsWithCurrentValue.add(spell);
      }
      returnList.add(_SliverExpandableStickyHeader('Level ${values.last}', spellsWithCurrentValue));

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
          returnList.add(_SliverExpandableStickyHeader('${values[valueIndex].toString().toUpperCase()}', spellsWithCurrentValue));
          // reset step
          valueIndex++;
          spellsWithCurrentValue = [];
        }
        spellsWithCurrentValue.add(spell);
      }
      returnList.add(_SliverExpandableStickyHeader('${values[valueIndex].toString().toUpperCase()}', spellsWithCurrentValue));

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
          returnList.add(_SliverExpandableStickyHeader('${values[valueIndex]}', spellsWithCurrentValue));
          // reset step
          valueIndex++;
          spellsWithCurrentValue = [];
        }
        spellsWithCurrentValue.add(spell);
      }
      returnList.add(_SliverExpandableStickyHeader('${values.last}', spellsWithCurrentValue));

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
    return CustomScrollView(
      controller: scrollController,
      shrinkWrap: true,
      slivers: headers,
    );
  }
}

class _SliverExpandableStickyHeader extends StatefulWidget {
  final List<Spell> spells;
  final String header;

  _SliverExpandableStickyHeader(this.header, this.spells);

  @override
  _SliverExpandableStickyHeaderState createState() => _SliverExpandableStickyHeaderState();
}

class _SliverExpandableStickyHeaderState extends State<_SliverExpandableStickyHeader> {
  bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = Provider.of<AppStateManager>(context, listen: false).retractedHeaders.contains(widget.header) ? false : true;
  }

  void _toggleShowExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
    if (_expanded)
      Provider.of<AppStateManager>(context, listen: false).retractedHeaders.remove(widget.header);
    else
      Provider.of<AppStateManager>(context, listen: false).retractedHeaders.add(widget.header);
  }

  @override
  Widget build(BuildContext context) {
    widget.spells.sort((a, b) => a.name.compareTo(b.name));

    return SliverStickyHeader(
      header: InkWell(
        onTap: () => _toggleShowExpanded(),
        child: Container(
          height: 35.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(150, 0, 0, 1),
            ),
            color: Color.fromRGBO(150, 0, 0, 1),
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
