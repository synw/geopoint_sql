import 'package:flutter/foundation.dart';
import 'package:geopoint/geopoint.dart';
import 'package:sqlcool/sqlcool.dart';
import '../exceptions.dart';

/// A class that provides sql methods for [GeoSerie]
class GeoSerieSql extends GeoSerie with DbModel {
  GeoSerieSql(
      {this.id,
      this.name = "geoserie",
      this.type = GeoSerieType.group,
      this.geoPoints,
      this.surface,
      this.boundary,
      this.centroid});

  @override
  int id;

  /// Name if the geoserie
  @override
  String name;

  /// Type of the geoserie
  @override
  GeoSerieType type;

  /// The list of [GeoPoint] in the serie
  @override
  List<GeoPoint> geoPoints;

  /// The surface of a geometry
  @override
  num surface;

  /// Boundaries of a geometry
  @override
  GeoSerie boundary;

  /// The centroid of a geometry
  @override
  GeoPoint centroid;

  @override
  Map<String, dynamic> toDb() => <String, dynamic>{
        "name": name,
        "type": typeStr,
        "surface": surface,
        "boundary": boundary,
        "centroid": centroid
      };

  @override
  GeoSerieSql fromDb(Map<String, dynamic> map) {
    final geoSerie = GeoSerie.fromJson(map);
    final gs = GeoSerieSql(
        name: geoSerie.name,
        type: geoSerie.type,
        surface: geoSerie.surface,
        boundary: geoSerie.boundary,
        centroid: geoSerie.centroid);
    return gs;
  }

  Future<GeoSerieSql> selectRelated(
      {int offset,
      int limit,
      String orderBy,
      String where,
      bool verbose = false}) async {
    final res = await db
        .select(
            table: table.name,
            offset: offset,
            limit: limit,
            orderBy: orderBy,
            where: where,
            verbose: verbose)
        .catchError((dynamic e) {
      throw DatabaseQueryError("Can not select from db $e");
    });
    if (res.length != 1) {
      throw DatabaseQueryError("Found ${res.length} geoserie in database");
    }
    final gs = fromDb(res[0]);
    // geopoints
    final gpres = await db.select(
        table: "geopoint", where: "id=${gs.id}", verbose: verbose);
    final geoPoints = <GeoPoint>[];
    if (gpres.isNotEmpty) {
      gpres.forEach((gp) {
        geoPoints.add(GeoPoint.fromJson(gp));
      });
      gs.geoPoints = geoPoints;
    }
    return gs;
  }

  /// Save a list of [GeoSerie] to the database
  Future<void> batchSave(
      {@required List<GeoSerie> geoSeries, bool verbose = false}) async {
    final geoPointsToSave = <GeoPoint>[];
    for (final geoSerie in geoSeries) {
      geoPointsToSave.addAll(geoSerie.geoPoints);
    }
    final geoSeriesRows = <Map<String, String>>[];
    geoSeries
        .forEach((s) => geoSeriesRows.add(Map<String, String>.from(s.toMap())));
    await db
        .batchInsert(table: "geoserie", rows: geoSeriesRows, verbose: verbose)
        .catchError((dynamic e) =>
            throw DatabaseQueryError("Can not insert geoseries $e"));
    final geoPointRows = <Map<String, String>>[];
    geoPointsToSave.forEach((gp) => geoPointRows.add(gp.toStringsMap()));
    await db
        .batchInsert(table: "geopoint", rows: geoPointRows, verbose: verbose)
        .catchError((dynamic e) =>
            throw DatabaseQueryError("Can not insert geopoints $e"));
  }
}
