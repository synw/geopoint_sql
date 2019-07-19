import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';
import 'crud.dart';

class _GeoPointCrudPageState extends State<GeoPointCrudPage> {
  _GeoPointCrudPageState({@required this.db, this.markersTrailingBuilder}) {
    if (db == null) throw (ArgumentError.notNull());
  }

  final Db db;
  final ItemWidgetBuilder markersTrailingBuilder;

  @override
  Widget build(BuildContext context) {
    return CrudPage(db: db, type: "point");
  }
}

class GeoPointCrudPage extends StatefulWidget {
  GeoPointCrudPage({@required this.db});

  final Db db;

  @override
  _GeoPointCrudPageState createState() => _GeoPointCrudPageState(db: db);
}
