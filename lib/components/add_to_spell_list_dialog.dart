import 'package:dnd_spells_flutter/models/spell.dart';
import 'package:dnd_spells_flutter/models/spell_list.dart';
import 'package:dnd_spells_flutter/services/spell_listmanager.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToListDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        color: Provider.of<ThemeManager>(context).colorPalette.dialogBackgroundColor,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 25),
            Text(
              'Add to a list',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Provider.of<ThemeManager>(context, listen: false).colorPalette.appBarBackgroundColor,
                ),
              ),
              child: Consumer<SpellListManager>(
                builder: (context, spellListManager, child) {
                  if (spellListManager.spellLists.isEmpty) {
                    return Container(
                      height: 100,
                      child: Center(
                        child: Text('No lists to add to'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: spellListManager.spellLists.length,
                    itemBuilder: (context, index) => _SpellListListTile(spellListManager.spellLists[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class _SpellListListTile extends StatelessWidget {
  final SpellList spellList;
  _SpellListListTile(this.spellList);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${spellList.name}'),
      onTap: () {
        Spell spell = Provider.of<Spell>(context, listen: false);
        print('Adding spell ${spell.name} to list ${spellList.name}');
      },
    );
  }
}
