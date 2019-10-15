import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'geocrud.dart';
import 'db.dart';

void main() {
  unawaited(initDb());
  runApp(MyApp());
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
