import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'crud.dart';

class _MarkersCrudPageState extends State<MarkersCrudPage> {
  _MarkersCrudPageState({@required this.db}) {
    if (db == null) throw (ArgumentError.notNull());
  }

  final Db db;

  @override
  Widget build(BuildContext context) {
    return CrudPage(db: db, type: "marker");
  }
}

class MarkersCrudPage extends StatefulWidget {
  MarkersCrudPage({@required this.db});

  final Db db;

  @override
  _MarkersCrudPageState createState() => _MarkersCrudPageState(db: db);
}
