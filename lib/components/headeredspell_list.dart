import 'package:dnd_spells_flutter/components/sortwidget.dart';
import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

enum OrderBy { name, level, school }

typedef Widget SpellTileBuilder(Spell spell);

class HeaderedSpellList extends StatefulWidget {
  final List<Spell> spells;
  final SpellTileBuilder spellTileBuilder;
  ScrollController scrollController;

  HeaderedSpellList({@required this.spells, this.spellTileBuilder, this.scrollController, Key key})
      : assert(spellTileBuilder != null),
        super(key: key ?? UniqueKey()); // : super(key: UniqueKey()); (why?)

  @override
  _HeaderedSpellListState createState() => _HeaderedSpellListState();
}

class _HeaderedSpellListState extends State<HeaderedSpellList> {
  List<_SliverExpandableStickyHeader> stickyHeaders;
//  Map<String, bool> headerToExpandedMap = {};
  bool showUpButton;
  OrderBy orderBy;
  ScrollController scrollController;

  @override
  initState() {
    super.initState();
    orderBy = OrderBy.name;
//    initialiseExpandedMap();
    showUpButton = true;
    scrollController = widget.scrollController ?? ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (this.showUpButton)
          setState(() {
            this.showUpButton = false;
          });
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward || scrollController.position.pixels == 0) {
        if (!this.showUpButton)
          setState(() {
            this.showUpButton = true;
          });
      }
    });
  }

  Map<String, List<Spell>> splitSpells() {
    // make the sticky headers
    Map<String, List<Spell>> headerToSpellsMap = {};
    widget.spells.forEach((spell) {
      String spellHeaderName = getHeaderName(spell);
      // if list not exists in map, make list
      if (!headerToSpellsMap.keys.contains(spellHeaderName)) headerToSpellsMap[spellHeaderName] = [];
      headerToSpellsMap[spellHeaderName].add(spell);
    });
    return headerToSpellsMap;
  }

  List<Widget> getStickyHeaders() {
    Map<String, List<Spell>> headerToSpellsMap = splitSpells();
    List<String> sortedKeys = headerToSpellsMap.keys.map((e) => e.toString()).toList();
    sortedKeys.sort((a, b) => a.compareTo(b));
    return sortedKeys.map((headerName) {
      return _SliverExpandableStickyHeader(
        header: headerName,
        spells: headerToSpellsMap[headerName],
        spellTileBuilder: widget.spellTileBuilder,
//        expanded: headerToExpandedMap[headerName],
//        onExpandedChange: () {
//          setState(() {
//            print('boi $headerName');
//            print(headerToExpandedMap[headerName]);
//            headerToExpandedMap[headerName] = !headerToExpandedMap[headerName];
//            print(headerToExpandedMap[headerName]);
//          });
//        },
      );
    }).toList();
  }

  String getHeaderName(Spell spell) {
    switch (orderBy) {
      case OrderBy.name:
        return spell.name.toUpperCase()[0];
      case OrderBy.level:
        if (spell.level == 0) return 'Cantrip';
        return 'level ${spell.level}';
      case OrderBy.school:
        return spell.school;
    }
    return '';
  }

//  bool allIsExpanded() {
//    for (String headerName in headerToExpandedMap.keys) {
//      if (!headerToExpandedMap[headerName]) return false;
//    }
//    return true;
//  }
//
//  bool allIsCompressed() {
//    for (String headerName in headerToExpandedMap.keys) {
//      if (headerToExpandedMap[headerName]) return false;
//    }
//    return true;
//  }

//  void allExpandOrCompressButtonPress() {
//    print('Time to alter all');
//    if (allIsCompressed()) {
//      print('All is compressed');
//      for (String name in headerToExpandedMap.keys) {
//        setState(() {
//          headerToExpandedMap[name] = true;
//        });
//      }
//    } else if (allIsExpanded()) {
//      print('All is expanded');
//      for (String name in headerToExpandedMap.keys) {
//        setState(() {
//          headerToExpandedMap[name] = false;
//        });
//      }
//    } else {
//      print('All is mixed');
//      for (String name in headerToExpandedMap.keys) {
//        setState(() {
//          headerToExpandedMap[name] = false;
//        });
//      }
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // the list
        ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: Scrollbar(
            isAlwaysShown: true,
            controller: scrollController,
            child: CustomScrollView(
              controller: scrollController,
              shrinkWrap: true,
              slivers: [
//                  SliverAppBar(
//                    floating: true,
//                    title: SortWidget(
//                      onTap: (newOrderBy) => Provider.of<SearchManager>(context, listen: false).orderBy = newOrderBy,
//                      toCheck: Provider.of<SearchManager>(context).orderBy,
//                    ),
//                  ),
                ...getStickyHeaders(),
              ],
            ),
          ),
        ),

        // the navigation buttons
        Container(
          alignment: Alignment.bottomCenter,
          child: AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            crossFadeState: this.showUpButton ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: SortWidget(
              toCheck: this.orderBy,
              onSortTap: (newOrderBy) {
                setState(() {
                  this.orderBy = newOrderBy;
                });
              },
              onButtonTap: () {
                scrollController.jumpTo(0);
              },
            ),
            secondChild: SizedBox(width: double.infinity),
          ),
        ),
      ],
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
  final VoidCallback onExpandedChange;
  final SpellTileBuilder spellTileBuilder;

  _SliverExpandableStickyHeader({this.spellTileBuilder, this.header, this.spells, this.expanded: true, this.onExpandedChange});

  @override
  _SliverExpandableStickyHeaderState createState() => _SliverExpandableStickyHeaderState();
}

class _SliverExpandableStickyHeaderState extends State<_SliverExpandableStickyHeader> {
  GlobalKey scrollKey;

  @override
  void initState() {
    super.initState();
    scrollKey = GlobalKey();
  }

  void _toggleShowExpanded() {
//    setState(() {
//      _expanded = !_expanded;
//    });
  }

  void _jumpTo() {
    Scrollable.ensureVisible(scrollKey.currentContext);
  }

  Widget buildHeader() {
    return InkWell(
      onTap: _jumpTo,
//      onTap: widget.onExpandedChange,
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
                  widget.expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Text(
                '${widget.spells.length} ${plural('spell', widget.spells.length)}'.toUpperCase(),
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.spells.sort((a, b) => a.name.compareTo(b.name));

    if (widget.expanded) {
      return SliverStickyHeader(
        key: scrollKey,
        header: buildHeader(),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            widget.spells.map((spell) => widget.spellTileBuilder(spell)).toList(),
          ),
        ),
      );
    } else {
      return SliverStickyHeader(
        key: scrollKey,
        header: buildHeader(),
        sliver: SliverList(
          delegate: SliverChildListDelegate([]),
        ),
      );
    }
  }
}
