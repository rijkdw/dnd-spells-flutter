import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:dnd_spells_flutter/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortWidget extends StatefulWidget {
  final Function(OrderBy) onSortTap;
  final VoidCallback onButtonTap;
  final OrderBy toCheck;
  SortWidget({this.onSortTap, this.toCheck, this.onButtonTap});

  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 2, 0),
      margin: EdgeInsets.only(
        bottom: 7,
        left: 5,
        right: 5,
      ),
      height: 50,
      decoration: BoxDecoration(
        color: Provider.of<ThemeManager>(context).colorPalette.appBarBackgroundColor,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 10,
            child: Text(
              'SORT BY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
          ChoiceChip(
            label: Text('Name'),
            selected: widget.toCheck == OrderBy.name,
            onSelected: (newValue) => widget.onSortTap(OrderBy.name),
          ),
          SizedBox(width: 6),
          ChoiceChip(
            label: Text('Level'),
            selected: widget.toCheck == OrderBy.level,
            onSelected: (newValue) => widget.onSortTap(OrderBy.level),
          ),
          SizedBox(width: 6),
          ChoiceChip(
            label: Text('School'),
            selected: widget.toCheck == OrderBy.school,
            onSelected: (newValue) => widget.onSortTap(OrderBy.school),
          ),
          SizedBox(width: 6),
          FloatingActionButton(
            heroTag: getRandomStringOfLength(20),
            mini: true,
            elevation: 0,
            splashColor: Colors.transparent,
            child: Icon(Icons.arrow_upward),
            onPressed: widget.onButtonTap,
          )
        ],
      ),
    );
  }
}
