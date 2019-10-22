import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'crud.dart';

class _LinesCrudPageState extends State<LinesCrudPage> {
  _LinesCrudPageState({@required this.db}) {
    if (db == null) {
      throw ArgumentError.notNull();
    }
  }

  final Db db;

  @override
  Widget build(BuildContext context) {
    return CrudPage(db: db, type: "line");
  }
}

class LinesCrudPage extends StatefulWidget {
  const LinesCrudPage({@required this.db});

  final Db db;

  @override
  _LinesCrudPageState createState() => _LinesCrudPageState(db: db);
}
