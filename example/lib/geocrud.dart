import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geopoint_sql/geopoint_sql.dart';
import 'package:geojson/geojson.dart';
import 'conf.dart';

class _GeoCrudPageState extends State<GeoCrudPage> {
  bool ready = false;

  @override
  void initState() {
    geoDb.onReady.then((_) {
      // load data if not present
      // data is from http://www.naturalearthdata.com
      checkRecords().then((_) {
        setState(() => ready = true);
      });
    });
    super.initState();
  }

  Future<void> checkRecords() async {
    final numRecords = await geoDb.count(table: "geoserie");
    if (numRecords == 0) {
      print("Loading data...");
      final fileName = "railroads_of_north_america.geojson";
      final data = await rootBundle.loadString("assets/$fileName");
      final geoSerieSql = GeoSerieSql(db: geoDb);

      /// Use the [geojson] package to parse the data
      final features = await featuresFromGeoJson(data);
      for (final feature in features.collection) {
        final GeoJsonLine line = feature.geometry as GeoJsonLine;

        /// Save the data
        await geoSerieSql.save(line.geoSerie);
      }
      final geoSeries = await geoDb.count(table: "geoserie");
      final geoPoints = await geoDb.count(table: "geopoint");
      print("Saved $geoPoints geopoints in $geoSeries series");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ready
          ? GeoCrudNavigationPage(db: geoDb, activeTab: ActiveTab.line)
          : Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  const CircularProgressIndicator(),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Loading geojson in the database ..."),
                  )
                ])),
    );
  }
}

class GeoCrudPage extends StatefulWidget {
  @override
  _GeoCrudPageState createState() => _GeoCrudPageState();
}
