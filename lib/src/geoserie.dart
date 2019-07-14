import 'package:flutter/foundation.dart';
import 'package:geopoint/geopoint.dart';
import 'package:sqlcool/sqlcool.dart';

/// Save a geoserie in the database
void dbSaveGeoSerie(
    {@required Db database, GeoSerie geoSerie, bool verbose = false}) async {
  /// save a serie into a database
  /// [database] is the database to use
  /// [verbose] print query info
  if (verbose) {
    print("SAVING the ${geoSerie.name} ${geoSerie.typeStr} serie");
  }
  final row = geoSerie.toMap(withId: false);
  try {
    await database
        .insert(table: "geoserie", row: row, verbose: verbose)
        .catchError((dynamic e) {
      throw (e);
    });
  } catch (e) {
    rethrow;
  }
}

/// Update a geoserie
void dbUpdateGeoSerie(
    {@required Db database, GeoSerie geoSerie, bool verbose = false}) async {
  /// save a serie into a database
  /// [database] is the database to use
  /// [verbose] print query info
  if (verbose) {
    print("Updating the ${geoSerie.name} ${geoSerie.typeStr} serie");
  }
  await database
      .update(
          table: "geoserie",
          row: geoSerie.toMap(withId: false),
          where: "id=${geoSerie.id}",
          verbose: verbose)
      .catchError((dynamic e) {
    throw (e);
  });
}

/// Delete a geoserie
void dbDeleteGeoSerie(
    {@required Db database, GeoSerie geoSerie, bool verbose = false}) async {
  /// delete a serie from a database
  /// [database] is the database to use
  /// [verbose] print query info
  if (verbose) {
    print("Deleting the ${geoSerie.name} ${geoSerie.typeStr} serie");
  }
  await database
      .delete(table: "geoserie", where: "id=${geoSerie.id}", verbose: verbose)
      .catchError((dynamic e) {
    throw (e);
  });
}
