import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/services/searchmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortWidget extends StatefulWidget {

  final Function(OrderBy) onTap;
  final OrderBy toCheck;
  SortWidget({this.onTap, this.toCheck});

  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 10, 0),
      height: 50,
      decoration: BoxDecoration(
        color: Provider.of<ThemeManager>(context).colorPalette.appBarBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Provider.of<ThemeManager>(context).colorPalette.stickyHeaderBackgroundColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              'SORT BY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ChoiceChip(
                  label: Text('Name'),
                  selected: widget.toCheck == OrderBy.name,
                  onSelected: (newValue) => widget.onTap(OrderBy.name),
                ),
                ChoiceChip(
                  label: Text('Level'),
                  selected: widget.toCheck == OrderBy.level,
                  onSelected: (newValue) => widget.onTap(OrderBy.level),
                ),
                ChoiceChip(
                  label: Text('School'),
                  selected: widget.toCheck == OrderBy.school,
                  onSelected: (newValue) => widget.onTap(OrderBy.school),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
