// data_list_page.dart
import 'package:flutter/material.dart';
import 'package:babel_talk/database_helper.dart';

class DataListPage extends StatefulWidget {
  @override
  _DataListPageState createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  List<String> _data = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final database = await DatabaseHelper.initializeDatabase();
    final List<String> data = await DatabaseHelper.fetchData(database);
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citaçoes Armazenadas'),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_data[index]),
          );
        },
      ),
    );
  }
}
