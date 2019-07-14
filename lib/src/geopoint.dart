import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:geopoint/geopoint.dart';

/// Save a geopoint in the database
Future<GeoPoint> saveGeoPoint(
    {@required GeoPoint geoPoint,
    @required Db database,
    bool withAddress,
    int serieId,
    bool verbose}) async {
  if (database == null) throw ArgumentError("Database must not be null");
  if (geoPoint == null) throw ArgumentError("geoPoint must not be null");
  withAddress = withAddress ?? false;
  verbose = verbose ?? false;
  final gp = await _dbSaveGeoPoint(
          database: database,
          geoPoint: geoPoint,
          withAddress: withAddress,
          serieId: serieId,
          verbose: verbose)
      .catchError((dynamic e) {
    throw (e);
  });
  return gp;
}

/// Save a geopoint image
Future<void> saveGeoPointImage(
    {@required Db database,
    String path,
    String url,
    @required int geoPointId,
    bool verbose}) async {
  if (database == null) throw ArgumentError("Database must not be null");
  if (geoPointId == null) throw ArgumentError("geoPointId must not be null");
  if (path == null && url == null) {
    throw ArgumentError("You must provide either a path or an url");
  }
  verbose = verbose ?? false;
  final row = <String, String>{
    "path": path,
    "url": url,
    "geopoint_id": "$geoPointId",
  };
  await database
      .insert(table: "geopoint_image", row: row, verbose: verbose)
      .catchError((dynamic e) {
    throw (e);
  });
}

/// Get images for a geopoint
Future<List<File>> getGeoPointImages(
    {@required Db database, @required int geoPointId}) async {
  if (database == null) throw ArgumentError("Database must not be null");
  if (geoPointId == null) throw ArgumentError("geoPointId must not be null");
  final imgs = await database.select(
      table: "geopoint_image", where: "geopoint_id=$geoPointId");
  final files = <File>[];
  imgs.forEach((img) {
    final path = img["path"].toString();
    files.add(File(path));
  });
  return files;
}

Future<GeoPoint> _dbSaveGeoPoint(
    {@required Db database,
    @required GeoPoint geoPoint,
    bool withAddress,
    int serieId,
    bool verbose}) async {
  if (database == null) throw ArgumentError("Database must not be null");
  if (geoPoint == null) throw ArgumentError("geoPoint must not be null");
  withAddress = withAddress ?? false;
  verbose = verbose ?? false;
  int id;
  id = await _saveGeoPoint(
          database: database,
          geoPoint: geoPoint,
          verbose: verbose,
          serieId: serieId)
      .catchError((dynamic e) {
    throw (e);
  });
  geoPoint.id = id;
  return geoPoint;
}

Future<int> _saveGeoPoint(
    {@required Db database,
    GeoPoint geoPoint,
    bool verbose,
    int serieId}) async {
  if (database == null) throw ArgumentError("Database must not be null");
  if (geoPoint == null) throw ArgumentError("geoPoint must not be null");
  verbose = verbose ?? false;
  if (verbose) {
    print(
        "SAVING GEOPOINT ${geoPoint.latitude}/${geoPoint.longitude} INTO DB $database");
  }
  int id;
  final row = geoPoint.toMap(withId: false);
  try {
    if (serieId != null) {
      row["geoserie"] = "$serieId";
    }
    id = await database
        .insert(table: "geopoint", row: row, verbose: verbose)
        .catchError((dynamic e) {
      throw (e);
    });
  } catch (e) {
    rethrow;
  }
  return id;
}
