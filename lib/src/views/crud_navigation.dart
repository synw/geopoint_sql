import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'markers.dart';
import 'groups.dart';
import 'lines.dart';
import 'polygons.dart';

class _GeoCrudNavigationPageState extends State<GeoCrudNavigationPage> {
  _GeoCrudNavigationPageState({@required this.db}) {
    if (db == null) throw (ArgumentError.notNull());
    _activeWidget = MarkersCrudPage(
      db: db,
    );
  }

  final Db db;

  SelectBloc bloc;
  int _selectedPos = 3;
  double bottomNavBarHeight = 60;
  bool _dbIsReady = false;
  Widget _activeWidget;

  List<TabItem> tabItems = List.of([
    TabItem(Icons.signal_cellular_null, "Polygons", Colors.deepPurple),
    TabItem(Icons.trending_up, "Lines", Colors.green),
    TabItem(Icons.bubble_chart, "Groups", Colors.red),
    TabItem(Icons.location_on, "Markers", Colors.blue),
  ]);

  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    _navigationController = CircularBottomNavigationController(_selectedPos);
    db.onReady.then((_) {
      setState(() {
        _dbIsReady = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_dbIsReady
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: <Widget>[
              Padding(
                child: _activeWidget,
                padding: EdgeInsets.only(bottom: bottomNavBarHeight),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularBottomNavigation(
                    tabItems,
                    selectedPos: _selectedPos,
                    controller: _navigationController,
                    barHeight: bottomNavBarHeight,
                    selectedCallback: (int selectedPos) {
                      setState(() {
                        switch (_navigationController.value) {
                          case 0:
                            _activeWidget = PolygonsCrudPage(db: db);
                            break;
                          case 1:
                            _activeWidget = LinesCrudPage(db: db);
                            break;
                          case 2:
                            _activeWidget = GroupsCrudPage(db: db);
                            break;
                          case 3:
                            _activeWidget = MarkersCrudPage(db: db);
                            break;
                        }
                      });
                    },
                  ))
            ],
          );
  }
}

class GeoCrudNavigationPage extends StatefulWidget {
  GeoCrudNavigationPage({@required this.db});

  final Db db;

  @override
  _GeoCrudNavigationPageState createState() =>
      _GeoCrudNavigationPageState(db: db);
}
