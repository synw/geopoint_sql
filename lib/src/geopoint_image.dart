import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';

void dbSaveGeopointImage(
    {@required Db database,
    String path,
    String url,
    @required int geoPointId,
    bool verbose: false}) async {
  Map<String, String> row = {
    "path": path,
    "url": url,
    "geopoint_id": "$geoPointId",
  };
  try {
    await database.insert(table: "geopoint_image", row: row, verbose: verbose);
  } catch (e) {
    throw (e);
  }
}
