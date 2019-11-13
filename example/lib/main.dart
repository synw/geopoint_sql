import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:geopoint_sql/geopoint_sql.dart';
import 'conf.dart';
import 'geocrud.dart';

void main() {
  runApp(MyApp());
  unawaited(initDb());
}

Future<void> initDb() async {
  await geoDb
      .init(
          path: "geodb.sqlite",
          schema: [geoPointSchema, geoSerieSchema],
          verbose: true)
      .catchError((dynamic e) {
    throw ("Can not init geo database $e");
  });
}

final routes = {
  '/': (BuildContext context) => GeoCrudPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geopoint sql example',
      routes: routes,
    );
  }
}
