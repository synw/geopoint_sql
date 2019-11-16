import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geopoint/geopoint.dart';
import 'package:sqlcool/sqlcool.dart';

/// The class to manage sql operations for [GeoPoint]
class GeoPointSql {
  /// Provide a [Db]
  GeoPointSql(
      {@required this.db,
      this.geoPointTableName = "geopoint",
      this.geoSerieTableName = "geoserie",
      this.geoPointImageTableName = "geopoint_image"}) {
    if (db == null) {
      throw ArgumentError("Database must not be null");
    }
  }

  /// The Sqlcool db to use
  final Db db;

  /// The table name
  final String geoPointTableName;

  /// The image table name
  final String geoPointImageTableName;

  /// The [GeoSerieSql] table name
  final String geoSerieTableName;

  /// Save a geopoint in the db
  ///
  /// Returns the [GeoPoint] with a database id set
  Future<GeoPoint> save(
      {@required GeoPoint geoPoint,
      bool withAddress,
      int serieId,
      bool verbose = false}) async {
    if (geoPoint == null) {
      throw ArgumentError("geoPoint must not be null");
    }
    withAddress ??= false;
    GeoPoint gp;
    try {
      gp = await _dbSaveGeoPoint(
          geoPoint: geoPoint,
          withAddress: withAddress,
          serieId: serieId,
          verbose: verbose);
    } catch (e) {
      rethrow;
    }
    return gp;
  }

  /// Save a geopoint image
  ///
  /// Returns the database id of the saved image
  Future<int> saveImage(
      {@required int geoPointId,
      String path,
      String url,
      bool verbose = false}) async {
    if (geoPointId == null) {
      throw ArgumentError("geoPointId must not be null");
    }
    if (path == null && url == null) {
      throw ArgumentError("You must provide either a path or an url");
    }
    final row = <String, String>{
      "path": path,
      "url": url,
      "geopoint": "$geoPointId"
    };
    int id;
    try {
      id = await db.insert(
          table: geoPointImageTableName, row: row, verbose: verbose);
    } catch (e) {
      rethrow;
    }
    return id;
  }

  /// Get images for a geopoint
  /*Future<List<File>> getImages({@required int geoPointId}) async {
    if (geoPointId == null) {
      throw ArgumentError("geoPointId must not be null");
    }
    final imgs = await db.select(
        table: geoPointImageTableName, where: "geopoint_id=$geoPointId");
    final files = <File>[];
    imgs.forEach((img) {
      final path = img["path"].toString();
      files.add(File(path));
    });
    return files;
  }*/

  Future<GeoPoint> _dbSaveGeoPoint(
      {@required GeoPoint geoPoint,
      bool withAddress,
      int serieId,
      bool verbose = false}) async {
    if (geoPoint == null) {
      throw ArgumentError("geoPoint must not be null");
    }
    withAddress ??= false;
    int id;
    try {
      id = await _saveGeoPoint(
          geoPoint: geoPoint, verbose: verbose, serieId: serieId);
    } catch (e) {
      rethrow;
    }
    geoPoint.id = id;
    return geoPoint;
  }

  Future<int> _saveGeoPoint(
      {GeoPoint geoPoint, bool verbose = false, int serieId}) async {
    if (geoPoint == null) {
      throw ArgumentError("geoPoint must not be null");
    }
    if (verbose) {
      print("Saving geopoint $geoPoint into db");
    }
    int id;
    final row = geoPoint.toStringsMap(withId: false);
    try {
      if (serieId != null) {
        row[geoSerieTableName] = "$serieId";
      }
      id =
          await db.insert(table: geoPointTableName, row: row, verbose: verbose);
    } catch (e) {
      rethrow;
    }
    return id;
  }
}
