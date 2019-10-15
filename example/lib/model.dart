import 'package:sqlcool/sqlcool.dart';
import 'package:geopoint_sql/geopoint_sql.dart';
import 'db.dart' as database;

class MyTimeSerieModel extends GeoSerieSql {
  @override
  Db get db => database.db;

  @override
  DbTable get table => geoSerieSchema();
}
