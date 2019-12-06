import 'package:flutter/foundation.dart';
import 'package:geopoint/geopoint.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqflite/sqflite.dart';

/// The class that manages the [GeoSerie] db operations
class GeoSerieSql {
  /// Provide a [Db]
  GeoSerieSql(
      {@required this.db,
      this.geoSerieTableName = "geoserie",
      this.geoPointTableName = "geopoint"});

  /// The Sqlcool database to use
  final Db db;

  /// The table name
  final String geoSerieTableName;

  /// The [GeoPointSql] table name
  final String geoPointTableName;

  /// Save a geoserie in the db
  Future<void> save(GeoSerie geoSerie, {bool verbose = false}) async =>
      _save(geoSerie,
          conflictAlgorithm: ConflictAlgorithm.rollback, verbose: verbose);

  /// Save a geoserie in the db ignoring constraint violations
  Future<void> saveIgnore(GeoSerie geoSerie, {bool verbose = false}) async =>
      _save(geoSerie,
          conflictAlgorithm: ConflictAlgorithm.ignore, verbose: verbose);

  /// Add geopoints to this geoserie
  Future<void> addGeoPoints(List<GeoPoint> geoPoints,
          {@required int geoSerieId, bool verbose = false}) async =>
      _addGeoPoints(geoPoints,
          geoSerieId: geoSerieId,
          conflictAlgorithm: ConflictAlgorithm.abort,
          verbose: verbose);

  /// Add geopoints to this geoserie ignoring constraint violations
  ///
  /// Use when you have the origin database ids of the rows or an
  /// unique field to upsert geopoints (insert if not exists)
  Future<void> addGeoPointsIgnore(List<GeoPoint> geoPoints,
          {@required int geoSerieId, bool verbose = false}) async =>
      _addGeoPoints(geoPoints,
          geoSerieId: geoSerieId,
          conflictAlgorithm: ConflictAlgorithm.ignore,
          verbose: verbose);

  /// Update a geoserie
  Future<void> update(GeoSerie geoSerie, {bool verbose = false}) async {
    if (verbose) {
      print("Updating the ${geoSerie.name} ${geoSerie.typeStr} serie");
    }
    final row = Map<String, String>.from(geoSerie.toMap(withId: false));
    try {
      await db.update(
          table: geoSerieTableName,
          row: row,
          where: "id=${geoSerie.id}",
          verbose: verbose);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a geoserie
  Future<void> delete(GeoSerie geoSerie, {bool verbose = false}) async {
    if (verbose) {
      print("Deleting the ${geoSerie.name} ${geoSerie.typeStr} serie");
    }
    try {
      await db.delete(
          table: geoSerieTableName,
          where: "id=${geoSerie.id}",
          verbose: verbose);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _addGeoPoints(List<GeoPoint> geoPoints,
      {@required int geoSerieId,
      @required ConflictAlgorithm conflictAlgorithm,
      bool verbose = false}) async {
    try {
      await db.database.transaction((txn) async {
        final batch = txn.batch();
        var i = 1;
        for (final geoPoint in geoPoints) {
          final gp = geoPoint.toMap();
          gp[geoSerieTableName] = "$geoSerieId";
          batch.insert(geoPointTableName, gp,
              conflictAlgorithm: conflictAlgorithm);
          ++i;
        }
        if (verbose) {
          print("Saving $i geopoints from geoserie $geoSerieId");
        }
        await batch.commit();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<int> _save(GeoSerie geoSerie,
      {@required ConflictAlgorithm conflictAlgorithm,
      bool verbose = false}) async {
    if (verbose) {
      print("Saving serie ${geoSerie.name} ${geoSerie.typeStr}");
    }
    final row = geoSerie.toMap();
    int id;
    try {
      await db.database.transaction((txn) async {
        id = await txn.insert(geoSerieTableName, row,
            conflictAlgorithm: ConflictAlgorithm.abort);
        final batch = txn.batch();
        var i = 1;
        for (final geoPoint in geoSerie.geoPoints) {
          geoPoint.timestamp ??= DateTime.now().millisecondsSinceEpoch;
          final gp = geoPoint.toMap();
          gp[geoSerieTableName] = "$id";
          batch.insert(geoPointTableName, gp,
              conflictAlgorithm: conflictAlgorithm);
          ++i;
        }
        if (verbose) {
          print(
              "Saving $i geopoints for serie ${geoSerie?.name ?? id} ${geoSerie.typeStr}");
        }
        await batch.commit();
      });
    } catch (e) {
      rethrow;
    }
    return id;
  }
}
