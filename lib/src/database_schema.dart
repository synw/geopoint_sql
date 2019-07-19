import 'package:sqlcool/sqlcool.dart';

/// The geopoint database sql schema
final geoPointSchema = DbTable("geopoint")
  ..varchar("name")
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
  ..foreignKey("geoserie", nullable: true);

/// The geoserie database schema
final geoSerieSchema = DbTable("geoserie")
  ..varchar("name")
  ..varchar("slug", unique: true, nullable: true)
  ..varchar("type", check: 'type = "group" or type = "line" or type="polygon"')
  ..real("surface", nullable: true)
  ..foreignKey("centroid",
      reference: "geopoint", onDelete: OnDelete.cascade, nullable: true)
  ..foreignKey("boudaries",
      reference: "geoserie", onDelete: OnDelete.cascade, nullable: true);

/// The geopoint image database schema
final geoPointImageSchema = DbTable("geopoint_image")
  ..varchar('path', nullable: true)
  ..varchar("url",
      nullable: true, check: "path IS NOT NULL OR (url IS NOT NULL))")
  ..foreignKey("geopoint");
