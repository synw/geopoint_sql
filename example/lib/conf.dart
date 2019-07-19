import 'package:sqlcool/sqlcool.dart';
import 'package:geopoint_sql/geopoint_sql.dart';

final geoDb = Db();
final geoSerieSql = GeoSerieSql(db: geoDb, verbose: true);
