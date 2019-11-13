import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';

class _CrudPageState extends State<CrudPage> {
  _CrudPageState({@required this.db, @required this.type}) {
    if (db == null) throw (ArgumentError.notNull());
    _dbIsReady = db.isReady;
  }

  final Db db;
  final String type;

  SelectBloc bloc;
  bool _dbIsReady;
  ItemWidgetBuilder _trailingBuilder;

  @override
  void initState() {
    String where;
    String table = "geoserie";
    switch (type) {
      case "group":
        where = 'type = "group"';
        break;
      case "line":
        where = 'type = "line"';
        break;
      case "polygon":
        where = 'type = "polygon"';
        break;
      case "point":
        where = "geoserie IS NULL";
        table = "geopoint";
    }
    bloc = SelectBloc(database: db, table: table, where: where, reactive: true);
    if (!_dbIsReady) {
      db.onReady.then((_) => setState(() => _dbIsReady = true));
    }
    print("TRAILING $_trailingBuilder");
    print("TYPE $type");
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_dbIsReady
        ? Center(
            child: const CircularProgressIndicator(),
          )
        : Stack(children: <Widget>[
            CrudView(bloc: bloc),
          ]);
  }
}

/// An admin page
class CrudPage extends StatefulWidget {
  /// Default constructor
  CrudPage({@required this.db, @required this.type});

  /// The database
  final Db db;

  /// The type of geoserie
  final String type;

  @override
  _CrudPageState createState() => _CrudPageState(db: db, type: type);
}
