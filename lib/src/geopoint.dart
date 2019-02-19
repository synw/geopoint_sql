import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:geopoint/geopoint.dart';

Future<GeoPoint> dbSaveGeoPoint(
    {@required String name,
    @required Db database,
    GeoPoint geopoint,
    bool withAddress: false,
    int serieId,
    verbose: false}) async {
  /// get a geopoint and record it into the database
  /// [name] the geopoint identifier
  /// [database] the Db to save into
  /// [withAddress] add the address information
  /// [verbose] print info
  GeoPoint gp;

  (geopoint == null)
      ? gp = await getGeoPoint(
          name: name, withAddress: withAddress, verbose: verbose)
      : gp = geopoint;
  if (verbose) {
    print("GEOPOINT $gp");
  }

  _saveGeoPoint(
          database: database, geoPoint: gp, verbose: verbose, serieId: serieId)
      .catchError((e) {
    throw (e);
  });
  return gp;
}

_saveGeoPoint(
    {@required Db database,
    GeoPoint geoPoint,
    bool verbose = false,
    int serieId}) async {
  if (verbose) {
    print(
        "SAVING GEOPOINT ${geoPoint.latitude}/${geoPoint.longitude} INTO DB $database");
  }
  Map<String, String> row = geoPoint.toMap();
  try {
    if (serieId != null) {
      row["geoserie"] = "$serieId";
    }
    await database
        .insert(table: "geopoint", row: row, verbose: verbose)
        .catchError((e) {
      throw (e);
    });
  } catch (e) {
    throw (e);
  }
}
