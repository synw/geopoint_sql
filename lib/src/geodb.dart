import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:geopoint/geopoint.dart';

import 'geopoint.dart';
import 'geoserie.dart';

/// The main class to handle database ops
class GeoDb {
  /// Provide a [Db]
  GeoDb(
      {@required this.db,
      this.geoPointTableName = "geopoint",
      this.geoSerieTableName = "geoserie",
      this.geoPointImageTableName = "geopoint_image"}) {
    if (db == null) {
      throw ArgumentError.notNull("[db] must not be null");
    }
    _gpSql = GeoPointSql(
        db: db,
        geoPointTableName: geoPointTableName,
        geoSerieTableName: geoSerieTableName,
        geoPointImageTableName: geoPointImageTableName);
    _gsSql = GeoSerieSql(
        db: db,
        geoPointTableName: geoPointTableName,
        geoSerieTableName: geoSerieTableName);
  }

  /// The Sqlcool database to use
  final Db db;

  /// The [GeoPointSql] table name
  final String geoPointTableName;

  /// The [GeoSerieSql] table name
  final String geoSerieTableName;

  /// The image table name
  final String geoPointImageTableName;

  GeoPointSql _gpSql;
  GeoSerieSql _gsSql;

  // **********************************************
  //                    Save
  // **********************************************

  // ***************** GeoPoint ********************

  /// Save a [GeoPoint] in the database
  Future<GeoPoint> saveGeoPoint(
          {@required GeoPoint geoPoint,
          bool withAddress,
          int serieId,
          bool verbose = false}) =>
      _gpSql.save(
          geoPoint: geoPoint,
          withAddress: withAddress,
          serieId: serieId,
          verbose: verbose);

  /// Save a [GeoPointImage] in the database
  Future<int> saveGeoPointImage(
          {@required int geoPointId,
          String path,
          String url,
          bool verbose = false}) =>
      _gpSql.saveImage(
          geoPointId: geoPointId, path: path, url: url, verbose: verbose);

  // ***************** GeoSerie ********************

  /// Save a [GeoSerie] in the database
  Future<void> save(GeoSerie geoSerie, {bool verbose = false}) =>
      _gsSql.save(geoSerie, verbose: verbose);

  /// Save a [GeoSerie] in the database ignoring constraint violations
  Future<void> saveIgnore(GeoSerie geoSerie, {bool verbose = false}) =>
      _gsSql.saveIgnore(geoSerie, verbose: verbose);

  /// Add a list of [GeoPoint] to a [GeoSerie]
  Future<void> addGeoPointsToGeoSerie(List<GeoPoint> geoPoints,
          {@required int geoSerieId, bool verbose = false}) =>
      _gsSql.addGeoPoints(geoPoints, geoSerieId: geoSerieId, verbose: verbose);

  /// Add a list of [GeoPoint] to a [GeoSerie] ignoring constraint violations
  ///
  /// Use when you have the origin database ids of the rows or an
  /// unique field to upsert geopoints (insert if not exists)
  Future<void> addGeoPointsToGeoSerieIgnore(List<GeoPoint> geoPoints,
          {@required int geoSerieId, bool verbose = false}) async =>
      _gsSql.addGeoPointsIgnore(geoPoints,
          geoSerieId: geoSerieId, verbose: verbose);

  // **********************************************
  //                    Update
  // **********************************************

  // ***************** GeoSerie ********************

  /// Update a [GeoSerie]
  Future<void> updateGeoSerie(GeoSerie geoSerie, {bool verbose = false}) =>
      _gsSql.update(geoSerie, verbose: verbose);

  // **********************************************
  //                    Delete
  // **********************************************
}
