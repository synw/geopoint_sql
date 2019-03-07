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
      case "marker":
        where = "geoserie_id IS NULL";
        table = "geopoint";
    }
    bloc = SelectBloc(
        database: db,
        table: table,
        where: where,
        limit: 100,
        reactive: true,
        verbose: true);
    if (!_dbIsReady)
      db.onReady.then((_) {
        setState(() {
          _dbIsReady = true;
        });
      });
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
            child: CircularProgressIndicator(),
          )
        : Stack(children: <Widget>[
            CrudView(
              bloc: bloc,
            ),
          ]);
  }
}

class CrudPage extends StatefulWidget {
  CrudPage({@required this.db, @required this.type});

  final Db db;
  final String type;

  @override
  _CrudPageState createState() => _CrudPageState(db: db, type: type);
}
