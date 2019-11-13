import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'crud.dart';

class _PolygonsCrudPageState extends State<PolygonsCrudPage> {
  _PolygonsCrudPageState({@required this.db}) {
    if (db == null) {
      throw (ArgumentError.notNull());
    }
  }

  final Db db;

  @override
  Widget build(BuildContext context) {
    return CrudPage(db: db, type: "polygon");
  }
}

/// An automatic admin page for [GeoSerie] of type polygon
class PolygonsCrudPage extends StatefulWidget {
  /// Provide a [db]
  PolygonsCrudPage({@required this.db});

  /// The database
  final Db db;

  @override
  _PolygonsCrudPageState createState() => _PolygonsCrudPageState(db: db);
}
