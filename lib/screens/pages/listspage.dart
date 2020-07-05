import 'dart:convert';

import 'package:dnd_spells_flutter/components/drawer.dart';
import 'package:dnd_spells_flutter/components/headeredspell_list.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/spellsrepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ListsPage extends StatefulWidget {
  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.keyboard_arrow_right),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.plus, size: 20),
            )
          ],
        ),
        body: Consumer<SpellListManager>(
          builder: (context, spellListManager, child) {
            if (spellListManager.spellLists.isEmpty)
              return Center(
                child: Text('No lists'),
              );
            return ListView.builder(
              itemCount: spellListManager.spellLists.length,
              itemBuilder: (context, index) => _SpellListListTile(spellListManager.spellLists[index]),
            );
          },
        ));
  }
}

class _SpellListListTile extends StatelessWidget {
  final SpellList spellList;
  _SpellListListTile(this.spellList);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('${spellList.name}'),
          Text('${spellList.spellNames.length} spells')
        ],
      ),
    );
  }
}
