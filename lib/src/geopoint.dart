import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:geopoint/geopoint.dart';

class GeoPointSql {
  GeoPointSql();

  static Future<GeoPoint> save(
      {@required geoPoint,
      @required database,
      withAddress,
      serieId,
      verbose}) async {
    if (database == null) throw ArgumentError("Database must not be null");
    if (geoPoint == null) throw ArgumentError("geoPoint must not be null");
    withAddress = withAddress ?? false;
    verbose = verbose ?? false;
    GeoPoint gp = await _dbSaveGeoPoint(
            database: database,
            geoPoint: geoPoint,
            withAddress: withAddress,
            serieId: serieId,
            verbose: verbose)
        .catchError((e) {
      throw (e);
    });
    return gp;
  }

  static Future<GeoPoint> saveCurrentPosition(
      {@required Db database,
      String name,
      int serieId,
      bool withAddress,
      bool verbose}) async {
    if (database == null) throw ArgumentError("Database must not be null");
    verbose = verbose ?? false;
    GeoPoint _gp = await getGeoPoint(name: name).catchError((e) {
      throw (e);
    });
    GeoPoint gp = await _dbSaveGeoPoint(
            database: database,
            geoPoint: _gp,
            withAddress: withAddress,
            serieId: serieId,
            verbose: verbose)
        .catchError((e) {
      throw (e);
    });
    return gp;
  }

  static Future<void> saveImage(
      {@required Db database,
      String path,
      String url,
      @required int geoPointId,
      bool verbose}) async {
    assert(path != null || url != null);
    if (database == null) throw ArgumentError("Database must not be null");
    if (geoPointId == null) throw ArgumentError("geoPointId must not be null");
    if (path != null || url != null)
      throw ArgumentError("You must provide either a path or an url");
    verbose = verbose ?? false;
    Map<String, String> row = {
      "path": path,
      "url": url,
      "geopoint_id": "$geoPointId",
    };
    await database
        .insert(table: "geopoint_image", row: row, verbose: verbose)
        .catchError((e) {
      throw (e);
    });
  }

  static Future<List<File>> getImages(
      {@required Db database, @required int geoPointId}) async {
    if (database == null) throw ArgumentError("Database must not be null");
    if (geoPointId == null) throw ArgumentError("geoPointId must not be null");
    List<Map<String, dynamic>> imgs = await database.select(
        table: "geopoint_images", where: "geopoint_id=$geoPointId");
    List<File> files;
    imgs.forEach((img) {
      files.add(File(img["path"]));
    });
    return files;
  }

  Db database;
  GeoPoint geoPoint;
  String name;
  bool withAddress;
  int serieId;
  bool verbose;
}

Future<GeoPoint> _dbSaveGeoPoint(
    {@required Db database,
    @required GeoPoint geoPoint,
    bool withAddress,
    int serieId,
    verbose}) async {
  /// get a geopoint and record it into the database
  /// [name] the geopoint identifier
  /// [database] the Db to save into
  /// [withAddress] add the address information
  /// [verbose] print info
  /// Returns the geopoint with it's id set
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
      .catchError((e) {
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
  Map<String, String> row = geoPoint.toMap();
  try {
    if (serieId != null) {
      row["geoserie"] = "$serieId";
    }
    id = await database
        .insert(table: "geopoint", row: row, verbose: verbose)
        .catchError((e) {
      throw (e);
    });
  } catch (e) {
    throw (e);
  }
  return id;
}
