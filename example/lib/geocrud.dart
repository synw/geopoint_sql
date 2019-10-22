import 'package:example/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geopoint/geopoint.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint_sql/geopoint_sql.dart';
import 'db.dart';
import 'model.dart';

class _GeoCrudPageState extends State<GeoCrudPage> {
  bool ready = false;

  @override
  void initState() {
    onConfReady.then((dynamic _) {
      // load data if not present
      // data is from http://www.naturalearthdata.com
      checkRecords().then((_) {
        setState(() => ready = true);
      });
    });
    super.initState();
  }

  Future<void> checkRecords() async {
    final numRecords = await MyTimeSerieModel().sqlCount();
    if (numRecords == 0) {
      print("Loading data...");
      final fileName = "railroads_of_north_america.geojson";
      final data = await rootBundle.loadString("assets/$fileName");

      /// Use the [geojson] package to parse the data
      final geoSeriesToSave = <GeoSerie>[];
      final features = await featuresFromGeoJson(data, nameProperty: "ADMIN");
      for (final feature in features.collection) {
        final GeoJsonLine line = feature.geometry as GeoJsonLine;
        geoSeriesToSave.add(line.geoSerie);
      }

      /// Save the data
      await MyTimeSerieModel().batchSave(geoSeries: geoSeriesToSave);
      final ngeoPoints =
          geoSeriesToSave.fold(0, (int v, gs) => v += gs.geoPoints.length);
      print("Saved $ngeoPoints geopoints in ${geoSeriesToSave.length} series");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ready
          ? GeoCrudNavigationPage(db: db, activeTab: ActiveTab.point)
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
