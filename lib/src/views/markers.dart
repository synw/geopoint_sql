import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';
import 'crud.dart';

class _MarkersCrudPageState extends State<MarkersCrudPage> {
  _MarkersCrudPageState({@required this.db, this.markersTrailingBuilder}) {
    if (db == null) throw (ArgumentError.notNull());
  }

  final Db db;
  final ItemWidgetBuilder markersTrailingBuilder;

  @override
  Widget build(BuildContext context) {
    return CrudPage(
        db: db, type: "marker", markersTrailingBuilder: markersTrailingBuilder);
  }
}

class MarkersCrudPage extends StatefulWidget {
  MarkersCrudPage({@required this.db, this.markersTrailingBuilder});

  final Db db;
  final ItemWidgetBuilder markersTrailingBuilder;

  @override
  _MarkersCrudPageState createState() => _MarkersCrudPageState(
      db: db, markersTrailingBuilder: markersTrailingBuilder);
}
