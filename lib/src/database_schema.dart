import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';

/// The geo database sql schema
var geoDbSchema = <String>[
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
    type CHECK(type = "group" or type = "line" or type="polygon"))"""
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
