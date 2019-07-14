import 'package:flutter/foundation.dart';
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
  ..varchar("country", nullable: true);

/// The geoserie database schema
final geoSerieSchema = DbTable("geoserie")
  ..varchar("name", unique: true)
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

var geoDbSchema = const <String>[
  """CREATE TABLE geopoint (
    id INTEGER PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    slug VARCHAR(60),
    timestamp INTEGER DEFAULT (strftime('%s','now', 'localtime')),
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    speed REAL,
    altitude REAL,
    heading REAL,
    accuracy REAL,
    speed_accuracy REAL,
    number VARCHAR(60),
    street VARCHAR(60),
    locality VARCHAR(60),
    sublocality VARCHAR(60),
    postal_code VARCHAR(60),
    subregion VARCHAR(60),
    region VARCHAR(60),
    country VARCHAR(60),
    geoserie_id INTEGER,
    CONSTRAINT geoserie_name
         FOREIGN KEY (geoserie_id)
         REFERENCES geoserie(id)
         ON DELETE CASCADE)""",
  """CREATE TABLE geopoint_image(
    id INTEGER PRIMARY KEY,
    path VARCHAR(255),
    url VARCHAR(255),
    geopoint_id INTEGER,
    CONSTRAINT geopoint
        FOREIGN KEY (geopoint_id)
        REFERENCES geopoint(id)
        ON DELETE CASCADE,
    CHECK(path IS NOT NULL OR (url IS NOT NULL)))""",
  """CREATE TABLE geoserie (
    id INTEGER PRIMARY KEY,
    name VARCHAR(30) NOT NULL,    
    type CHECK(type = "group" or type = "line" or type="polygon"),
    surface REAL,
    centroid_id INTEGER,
    boundaries_id INTEGER,
    CONSTRAINT centroid
        FOREIGN KEY (centroid_id)
        REFERENCES geopoint(id)
        ON DELETE CASCADE,
    CONSTRAINT boundaries
        FOREIGN KEY (boundaries_id)
        REFERENCES geoserie(id)
        ON DELETE CASCADE
    )"""
];

initGeoDb(
    {@required String dbpath, @required Db database, verbose = false}) async {
  /// initialize a geo database
  /// [dbpath] is the path to the database file
  /// relative to the documents directory
  /// [database] is the database to use, defaults to the
  /// default Sqlcool database
  /// [verbose] print the query
  await database
      .init(path: dbpath, queries: geoDbSchema, verbose: verbose)
      .catchError((e) {
    throw (e);
  });
}
