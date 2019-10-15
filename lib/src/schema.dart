import 'package:sqlcool/sqlcool.dart';

/// Create a geopoint schema for a given table name
DbTable geoPointSchema({bool indexName = false}) {
  final table = DbTable("geopoint")
    ..varchar("name")
    ..varchar("slug", nullable: true)
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
    ..foreignKey("geoserie", nullable: true, onDelete: OnDelete.cascade);
  if (indexName) {
    table.index("name", indexName: "idx_geopoint_name");
  }
  return table;
}

/// The geoserie database schema generator
DbTable geoSerieSchema({bool indexName = false}) {
  final table = DbTable("geoserie")
    ..varchar("name")
    ..varchar("slug", nullable: true)
    ..varchar("type",
        check: 'type = "group" or type = "line" or type="polygon"')
    ..real("surface", nullable: true)
    ..foreignKey("centroid",
        reference: "geopoint", onDelete: OnDelete.cascade, nullable: true)
    ..foreignKey("boundary",
        reference: "geoserie", onDelete: OnDelete.cascade, nullable: true);
  if (indexName) {
    table.index("name", indexName: "idx_geoserie_name");
  }
  return table;
}
