import 'package:dnd_spells_flutter/components/dialogmenu.dart';
import 'package:dnd_spells_flutter/models/colorpalette.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/screens/createlistscreen.dart';
import 'package:dnd_spells_flutter/screens/characterlistscreen.dart';
import 'package:dnd_spells_flutter/screens/genericlistscreen.dart';
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
//        title: Text('${Provider.of<SpellListManager>(context).spellLists.length} lists'),
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
              child: Text(
                'NO LISTS',
                style: TextStyle(fontSize: 20, letterSpacing: 2),
              ),
            );
          return ListView.builder(
            itemCount: spellListManager.spellLists.length,
            itemBuilder: (context, index) {
              AbstractSpellList spellList = spellListManager.spellLists[index];
              if (spellList is CharacterSpellList)
                return _CharacterSpellListTile(spellList);
              if (spellList is GenericSpellList)
                return _GenericSpellListTile(spellList);
            },
          );
        },
      ),
    );
  }
}

class _CharacterSpellListTile extends StatelessWidget {
  final CharacterSpellList spellList;
  _CharacterSpellListTile(this.spellList);

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<CharacterSpellList>.value(
              value: spellList,
              child: CharacterSpellListScreen(
                spellList: spellList,
              ),
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (dialogContext) => DialogMenu(
            dialogContext: dialogContext, // otherwise there's some issue with unsafe ancestors, idk
            heading: Text(
              '${spellList.name}',
              style: TextStyle(fontSize: 24),
            ),
            menuOptions: [
              MenuOption(
                text: 'Edit',
                iconData: FontAwesomeIcons.wrench,
                iconSize: 20,
                onTap: () {},
              ),
              MenuOption(
                text: 'Delete',
                iconData: FontAwesomeIcons.trash,
                iconSize: 20,
                onTap: () async {
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => _ConfirmSpellListDeleteDialog(spellList),
                  );
                  if (confirmDelete) {
                    Provider.of<SpellListManager>(context, listen: false).deleteSpellList(spellList);
                  }
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${spellList.name}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '${spellList.subtitle}',
              style: TextStyle(
                color: colorPalette.subTextColor,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _GenericSpellListTile extends StatelessWidget {
  final GenericSpellList spellList;
  _GenericSpellListTile(this.spellList);

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenericSpellListScreen(
              spellList: spellList,
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (dialogContext) => DialogMenu(
            dialogContext: dialogContext, // otherwise there's some issue with unsafe ancestors, idk
            heading: Text(
              '${spellList.name}',
              style: TextStyle(fontSize: 24),
            ),
            menuOptions: [
              MenuOption(
                text: 'Edit',
                iconData: FontAwesomeIcons.wrench,
                iconSize: 20,
                onTap: () {},
              ),
              MenuOption(
                text: 'Delete',
                iconData: FontAwesomeIcons.trash,
                iconSize: 20,
                onTap: () async {
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => _ConfirmSpellListDeleteDialog(spellList),
                  );
                  if (confirmDelete) {
                    Provider.of<SpellListManager>(context, listen: false).deleteSpellList(spellList);
                  }
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${spellList.name}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Generic Spell List',
              style: TextStyle(
                color: colorPalette.subTextColor,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ConfirmSpellListDeleteDialog extends StatelessWidget {
  final AbstractSpellList spellList;
  _ConfirmSpellListDeleteDialog(this.spellList);

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = Provider.of<ThemeManager>(context).colorPalette;
    return AlertDialog(
      backgroundColor: colorPalette.dialogBackgroundColor,
      title: Text(
        'Do you really want to delete ${this.spellList.name}?',
        style: TextStyle(
          color: colorPalette.mainTextColor,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Yes',
            style: TextStyle(
              fontSize: 18,
              color: colorPalette.clickableTextLinkColor,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        FlatButton(
          child: Text(
            'No',
            style: TextStyle(
              fontSize: 18,
              color: colorPalette.clickableTextLinkColor,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
