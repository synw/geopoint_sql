import 'dart:async';
import 'package:sqlcool/sqlcool.dart';
import 'package:geopoint_sql/geopoint_sql.dart';

final db = Db();
final verbose = true;

final _onReadyCompleter = Completer<Null>();

Future get onConfReady => _onReadyCompleter.future;

Future<void> initDb() async {
  final geoPointTable = geoPointSchema();
  final geoSerieTable = geoSerieSchema();
  await db
      .init(
          path: "geodb.sqlite",
          schema: <DbTable>[geoPointTable, geoSerieTable],
          verbose: verbose)
      .catchError((dynamic e) => throw ("Can not initialize database $e"));
  _onReadyCompleter.complete();
}
