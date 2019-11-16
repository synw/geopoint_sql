import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';
import 'crud.dart';

class _GeoPointCrudPageState extends State<GeoPointCrudPage> {
  _GeoPointCrudPageState({@required this.db, this.markersTrailingBuilder}) {
    if (db == null) {
      throw ArgumentError.notNull();
    }
  }

  final Db db;
  final ItemWidgetBuilder markersTrailingBuilder;

  @override
  Widget build(BuildContext context) {
    return CrudPage(db: db, type: "point");
  }
}

/// An automatic admin page for [GeoPoint]
class GeoPointCrudPage extends StatefulWidget {
  /// Provide a [db]
  const GeoPointCrudPage({@required this.db, this.markersTrailingBuilder});

  /// The trailing builder in list
  final ItemWidgetBuilder markersTrailingBuilder;

  /// The database
  final Db db;

  @override
  _GeoPointCrudPageState createState() => _GeoPointCrudPageState(db: db);
}
