import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            onPressed: () => print('Clear ALL fiters'),
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
                _ClearableTextField(
                  hintText: 'Name',
                  controller: _nameController,
                ),
                _ClearableTextField(
                  hintText: 'Description',
                  controller: _descController,
                ),
                FlatButton(
                  onPressed: () => _search(),
                  color: Colors.red,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClearableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  _ClearableTextField({this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: this.controller,
            decoration: InputDecoration(
              hintText: this.hintText,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            this.controller.clear();
          },
          child: Container(
            width: 30,
            height: 50,
            child: Center(
              child: Icon(Icons.close, size: 15),
            ),
          ),
        )
      ],
    );
  }
}
