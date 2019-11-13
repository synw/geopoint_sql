import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:geopoint/geopoint.dart';

/// The class to manage sql operations for [GeoPoint]
class GeoPointSql {
  /// Provide a [Db]
  GeoPointSql({@required this.db, this.verbose = false}) {
    if (db == null) {
      throw ArgumentError("Database must not be null");
    }
  }

  /// The Sqlcool db to use
  final Db db;

  /// Verbosity
  final bool verbose;

  /// Save a geopoint in the db
  Future<GeoPoint> save(
      {@required GeoPoint geoPoint, bool withAddress, int serieId}) async {
    if (geoPoint == null) {
      throw ArgumentError("geoPoint must not be null");
    }
    withAddress = withAddress ?? false;
    final gp = await _dbSaveGeoPoint(
            geoPoint: geoPoint, withAddress: withAddress, serieId: serieId)
        .catchError((dynamic e) {
      throw (e);
    });
    return gp;
  }

  /// Save a geopoint image
  Future<void> saveImage(
      {@required int geoPointId, String path, String url}) async {
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
    await db
        .insert(table: "geopoint_image", row: row, verbose: verbose)
        .catchError((dynamic e) {
      throw (e);
    });
  }

  /// Get images for a geopoint
  Future<List<File>> getImages({@required int geoPointId}) async {
    if (geoPointId == null) {
      throw ArgumentError("geoPointId must not be null");
    }
    final imgs = await db.select(
        table: "geopoint_image", where: "geopoint_id=$geoPointId");
    final files = <File>[];
    imgs.forEach((img) {
      final path = img["path"].toString();
      files.add(File(path));
    });
    return files;
  }

  Future<GeoPoint> _dbSaveGeoPoint(
      {@required GeoPoint geoPoint, bool withAddress, int serieId}) async {
    if (geoPoint == null) {
      throw ArgumentError("geoPoint must not be null");
    }
    withAddress = withAddress ?? false;
    int id;
    id = await _saveGeoPoint(
            geoPoint: geoPoint, verbose: verbose, serieId: serieId)
        .catchError((dynamic e) {
      throw (e);
    });
    geoPoint.id = id;
    return geoPoint;
  }

  Future<int> _saveGeoPoint(
      {GeoPoint geoPoint, bool verbose, int serieId}) async {
    if (geoPoint == null) {
      throw ArgumentError("geoPoint must not be null");
    }
    verbose = verbose ?? false;
    if (verbose) {
      print(
          "SAVING GEOPOINT ${geoPoint.latitude}/${geoPoint.longitude} INTO DB $db");
    }
    int id;
    final row = geoPoint.toStringsMap(withId: false);
    try {
      if (serieId != null) {
        row["geoserie"] = "$serieId";
      }
      id = await db
          .insert(table: "geopoint", row: row, verbose: verbose)
          .catchError((dynamic e) {
        throw (e);
      });
    } catch (e) {
      rethrow;
    }
    return id;
  }
}
