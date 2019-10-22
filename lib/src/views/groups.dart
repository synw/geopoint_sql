import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'crud.dart';

class _GroupsCrudPageState extends State<GroupsCrudPage> {
  _GroupsCrudPageState({@required this.db}) {
    if (db == null) {
      throw ArgumentError.notNull();
    }
  }

  final Db db;

  @override
  Widget build(BuildContext context) {
    return CrudPage(db: db, type: "group");
  }
}

class GroupsCrudPage extends StatefulWidget {
  const GroupsCrudPage({@required this.db});

  final Db db;

  @override
  _GroupsCrudPageState createState() => _GroupsCrudPageState(db: db);
}
