import 'package:dnd_spells_flutter/components/clearabletextfield.dart';
import 'package:dnd_spells_flutter/services/thememanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  void _dropFocus() {
    print('dropping focus');
    FocusScope.of(context).unfocus();
  }

  void _search() {
    print('Submitted search with parameters:');
    print('Name: ${_nameController.text}');
    print('Description: ${_descController.text}');
  }

  void _clearAll() {
    print('Clear ALL fiters');
    _nameController.clear();
    _descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Search & Filter',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _clearAll,
            icon: Icon(Icons.clear),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => _dropFocus(),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(
              left: 13,
              right: 13,
              top: 15,
            ),
            child: Column(
              children: <Widget>[
                ClearableTextField(
                  hintText: 'Name',
                  controller: _nameController,
                ),
                ClearableTextField(
                  hintText: 'Description',
                  controller: _descController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
