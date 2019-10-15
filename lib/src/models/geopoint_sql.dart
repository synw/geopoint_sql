import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geopoint/geopoint.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:slugify2/slugify.dart';
import 'geoserie_sql.dart';

/// A class that provides sql methods for [GeoPoint]
class GeoPointSql extends GeoPoint with DbModel {
  /// The [GeoSerie] to which the geopoint belongs
  GeoSerieSql geoSerieSql;

  @override
  int id;

  /// The name of the geopoint
  @override
  String name;

  /// A latitude coordinate
  @override
  final double latitude;

  /// A longitude coordinate
  @override
  final double longitude;

  /// A string without spaces nor special characters. Can be used
  /// to define file paths
  @override
  String slug;

  /// The timestamp
  @override
  int timestamp;

  /// The altitude of the geopoint
  @override
  double altitude;

  /// The speed
  @override
  double speed;

  /// The accuracy of the mesurement
  @override
  double accuracy;

  /// The accuracy of the speed
  @override
  double speedAccuracy;

  /// The heading
  @override
  double heading;

  /// Number in the street
  @override
  String number;

  /// Street name
  @override
  String street;

  /// Locality name
  @override
  String locality;

  /// Sublocality name
  @override
  String sublocality;

  /// Local postal code
  @override
  String postalCode;

  /// Subregion
  @override
  String subregion;

  /// Region
  @override
  String region;

  /// Country
  @override
  String country;

  /// A list of images can be attached to the geopoint
  @override
  List<File> images;

  /// Default constructor: needs [latitude] and [longitude]
  GeoPointSql(
      {@required this.latitude,
      @required this.longitude,
      this.name,
      this.id,
      this.slug,
      this.timestamp,
      this.altitude,
      this.speed,
      this.accuracy,
      this.heading,
      this.country,
      this.locality,
      this.sublocality,
      this.number,
      this.postalCode,
      this.region,
      this.speedAccuracy,
      this.street,
      this.subregion,
      this.images})
      : assert(latitude != null),
        assert(longitude != null) {
    if (slug == null && name != null) {
      slug = Slugify().slugify(name);
    }
  }

  @override
  Map<String, dynamic> toDb() => <String, dynamic>{
        "name": name,
        "slug": Slugify().slugify(name),
        "latitude": latitude,
        "longitude": longitude,
        "speed": speed,
        "altitude": altitude,
        "heading": heading,
        "accuracy": accuracy,
        "speed_accuracy": speedAccuracy,
        "number": number,
        "street": street,
        "locality": locality,
        "sublocality": sublocality,
        "postal_code": postalCode,
        "region": region,
        "subregion": subregion,
        "country": country,
        "geoserie": geoSerieSql?.id
      };

  @override
  GeoPointSql fromDb(Map<String, dynamic> map) {
    final gpSql = GeoPointSql(
      latitude: map["latitude"] as double,
      longitude: map["longitude"] as double,
    );
    if (map.containsKey("name")) {
      gpSql.name = map["name"].toString();
    }
    if (map.containsKey("slug")) {
      gpSql.slug = map["slug"].toString();
    }
    if (map.containsKey("speed")) {
      gpSql.speed = map["speed"] as double;
    }
    if (map.containsKey("altitude")) {
      gpSql.altitude = map["altitude"] as double;
    }
    if (map.containsKey("accuracy")) {
      gpSql.accuracy = map["accuracy"] as double;
    }
    if (map.containsKey("speed_accuracy")) {
      gpSql.speedAccuracy = map["speed_accuracy"] as double;
    }
    if (map.containsKey("number")) {
      gpSql.number = map["number"].toString();
    }
    if (map.containsKey("street")) {
      gpSql.street = map["street"].toString();
    }
    if (map.containsKey("locality")) {
      gpSql.locality = map["locality"].toString();
    }
    if (map.containsKey("sublocality")) {
      gpSql.sublocality = map["sublocality"].toString();
    }
    if (map.containsKey("postal_code")) {
      gpSql.postalCode = map["postal_code"].toString();
    }
    if (map.containsKey("region")) {
      gpSql.region = map["region"].toString();
    }
    if (map.containsKey("subregion")) {
      gpSql.subregion = map["subregion"].toString();
    }
    if (map.containsKey("country")) {
      gpSql.country = map["country"].toString();
    }
    if (map.containsKey("geoserie")) {
      gpSql.geoSerieSql =
          GeoSerieSql().fromDb(map["geoserie"] as Map<String, dynamic>);
    }
    return gpSql;
  }
}
