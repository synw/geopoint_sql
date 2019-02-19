import 'package:flutter/foundation.dart';
import 'package:geopoint/geopoint.dart';
import 'package:sqlcool/sqlcool.dart';

dbSaveGeoSerie(
    {@required Db database, GeoSerie geoSerie, bool verbose = false}) async {
  /// save a serie into a database
  /// [database] is the database to use
  /// [verbose] print query info
  if (verbose) {
    print("SAVING the ${geoSerie.name} ${geoSerie.serieType} serie");
  }
  Map<String, String> row = geoSerie.toMap(withId: false);
  try {
    await database
        .insert(table: "geoserie", row: row, verbose: verbose)
        .catchError((e) {
      throw (e);
    });
  } catch (e) {
    throw (e);
  }
}

dbUpdateGeoSerie(
    {@required database, GeoSerie geoSerie, bool verbose = false}) async {
  /// save a serie into a database
  /// [database] is the database to use
  /// [verbose] print query info
  if (verbose) {
    print("Updating the ${geoSerie.name} ${geoSerie.serieType} serie");
  }
  await database
      .update(
          table: "geoserie",
          row: geoSerie.toMap(withId: false),
          where: "id=${geoSerie.id}",
          verbose: verbose)
      .catchError((e) {
    throw (e);
  });
}

dbDeleteGeoSerie(
    {@required database, GeoSerie geoSerie, bool verbose = false}) async {
  /// delete a serie from a database
  /// [database] is the database to use
  /// [verbose] print query info
  if (verbose) {
    print("Deleting the ${geoSerie.name} ${geoSerie.serieType} serie");
  }
  await database
      .delete(table: "geoserie", where: "id=${geoSerie.id}", verbose: verbose)
      .catchError((e) {
    throw (e);
  });
}
