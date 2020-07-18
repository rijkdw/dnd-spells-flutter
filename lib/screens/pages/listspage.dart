import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/screens/createlistscreen.dart';
import 'package:dnd_spells_flutter/screens/spell_listscreen.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Provider.of<ThemeManager>(context).colorPalette.appBarBackgroundColor,
        title: Text('${Provider.of<SpellListManager>(context).spellLists.length} lists'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateListScreen(),
              ));
            },
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
      ),
    );
  }
}

class _SpellListListTile extends StatelessWidget {
  final SpellList spellList;
  _SpellListListTile(this.spellList);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpellListScreen(
              spellList: spellList,
            ),
          ),
        );
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${spellList.name}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '${spellList.spellNames.length} spells',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
