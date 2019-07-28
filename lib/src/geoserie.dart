import 'package:flutter/foundation.dart';
import 'package:geopoint/geopoint.dart';
import 'package:sqlcool/sqlcool.dart';

/// The class that manages the [GeoSerie] db operations
class GeoSerieSql {
  /// Provide a [Db]
  GeoSerieSql({@required this.db, this.verbose = false});

  /// The Sqlcool database to use
  final Db db;

  /// Verbosity
  final bool verbose;

  /// Save a geoserie in the db
  void save(GeoSerie geoSerie) async {
    if (verbose) {
      print("Saving serie ${geoSerie.name} ${geoSerie.typeStr}");
    }
    final row = Map<String, String>.from(geoSerie.toMap(withId: false));
    int id;
    try {
      id = await db
          .insert(table: "geoserie", row: row, verbose: verbose)
          .catchError((dynamic e) {
        throw (e);
      });
    } catch (e) {
      rethrow;
    }
    // save the geopoints in the serie
    final rows = <Map<String, String>>[];
    var i = 0;
    for (final geoPoint in geoSerie.geoPoints) {
      final gp = geoPoint.toStringsMap(withId: false);
      gp["geoserie"] = "$id";
      if (gp["name"] == null) {
        gp["name"] = "Geopoint $i";
      }
      rows.add(gp);
      ++i;
    }
    if (verbose) {
      print("Saving ${rows.length} geopoints for serie");
    }
    try {
      await db.batchInsert(table: "geopoint", rows: rows, verbose: verbose);
    } catch (e) {
      throw ("Can not insert geopoints $e");
    }
  }

  /// Update a geoserie
  void update(GeoSerie geoSerie) async {
    if (verbose) {
      print("Updating the ${geoSerie.name} ${geoSerie.typeStr} serie");
    }
    final row = Map<String, String>.from(geoSerie.toMap(withId: false));
    await db
        .update(
            table: "geoserie",
            row: row,
            where: "id=${geoSerie.id}",
            verbose: verbose)
        .catchError((dynamic e) {
      throw (e);
    });
  }

  /// Delete a geoserie
  void delete(GeoSerie geoSerie) async {
    if (verbose) {
      print("Deleting the ${geoSerie.name} ${geoSerie.typeStr} serie");
    }
    await db
        .delete(table: "geoserie", where: "id=${geoSerie.id}", verbose: verbose)
        .catchError((dynamic e) {
      throw (e);
    });
  }
}
