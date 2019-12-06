import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';

/// A list of all the default tables of the schema
List<DbTable> geoPointTables = [
  geoPointSchema,
  geoSerieSchema,
  geoPointPropertySchema,
  geoPointImageSchema
];

/// The [GeoPoint] database sql schema
final DbTable geoPointSchema = createGeoPointSchema();

/// Tha [GeoSerie] schema
final DbTable geoSerieSchema = createGeoSerieSchema();

/// The [GeoPointProperty] schema
final DbTable geoPointPropertySchema = createGeoPointPropertySchema();

/// The geopoint image schema
final DbTable geoPointImageSchema = createGeoPointImageSchema();

/// Create a geopoint schema from a name
List<DbTable> geoPointSqlSchemaFromName(String name) => geoPointSqlSchema(
      geoPointPropertyTableName: "${name}_property",
      geoPointTableName: "${name}_geopoint",
      geoSerieTableName: "${name}_geoserie",
      geoPointImageTableName: "${name}_image",
    );

/// A function to create a schema from table names
List<DbTable> geoPointSqlSchema({
  @required String geoPointTableName,
  @required String geoSerieTableName,
  String geoPointImageTableName,
  String geoPointPropertyTableName,
}) {
  final tables = <DbTable>[];
  final gp = createGeoPointSchema(
      tableName: geoPointTableName, geoSerieTableName: geoSerieTableName);
  final gs = createGeoSerieSchema(
      tableName: geoSerieTableName, geoPointTableName: geoPointImageTableName);
  tables..add(gp)..add(gs);
  if (geoPointImageTableName != null) {
    tables.add(createGeoPointImageSchema(
        tableName: geoPointImageTableName,
        geoPointTableName: geoPointTableName));
  }
  if (geoPointPropertyTableName != null) {
    tables.add(createGeoPointPropertySchema(
        tableName: geoPointPropertyTableName,
        geoPointTableName: geoPointTableName));
  }
  return tables;
}

/// Create a geopoint schema for a given table name
DbTable createGeoPointSchema(
    {String tableName = "geopoint", String geoSerieTableName = "geoserie"}) {
  return DbTable(tableName)
    ..varchar("name", nullable: true)
    ..varchar("slug", unique: true, nullable: true)
    ..timestamp()
    ..real("latitude")
    ..real("longitude")
    ..real("speed", nullable: true)
    ..real("altitude", nullable: true)
    ..real("heading", nullable: true)
    ..real("accuracy", nullable: true)
    ..real("speed_accuracy", nullable: true)
    ..varchar("number", nullable: true)
    ..varchar("street", nullable: true)
    ..varchar("locality", nullable: true)
    ..varchar("sublocality", nullable: true)
    ..varchar("postal_code", nullable: true)
    ..varchar('region', nullable: true)
    ..varchar("subregion", nullable: true)
    ..varchar("country", nullable: true)
    ..index("name")
    ..foreignKey(geoSerieTableName, nullable: true, onDelete: OnDelete.cascade);
}

/// Geopoint property schema generator
DbTable createGeoPointPropertySchema(
    {String tableName = "geopoint_property",
    String geoPointTableName = "geopoint"}) {
  return DbTable(tableName)
    ..varchar("name")
    ..varchar("value")
    ..varchar("type")
    ..foreignKey(geoPointTableName, onDelete: OnDelete.cascade)
    ..index("name");
}

/// The geoserie database schema generator
DbTable createGeoSerieSchema(
    {String tableName = "geoserie", String geoPointTableName = "geopoint"}) {
  return DbTable(tableName)
    ..varchar("name", nullable: true)
    ..varchar("slug", unique: true, nullable: true)
    ..varchar("type",
        check: 'type = "group" or type = "line" or type="polygon"')
    ..real("surface", nullable: true)
    ..foreignKey("centroid",
        reference: geoPointTableName,
        onDelete: OnDelete.cascade,
        nullable: true)
    ..foreignKey("boundary",
        reference: tableName, onDelete: OnDelete.cascade, nullable: true)
    ..index("name");
}

/// The geopoint image database schema generator
DbTable createGeoPointImageSchema(
    {String tableName = "geopoint_image",
    String geoPointTableName = "geopoint"}) {
  return DbTable(tableName)
    ..varchar('path', nullable: true)
    ..varchar("url",
        nullable: true, check: "path IS NOT NULL OR (url IS NOT NULL)")
    ..foreignKey(geoPointTableName, onDelete: OnDelete.cascade);
}
