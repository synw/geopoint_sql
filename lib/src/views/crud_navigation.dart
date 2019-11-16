import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';
import 'geopoint.dart';
import 'groups.dart';
import 'lines.dart';
import 'polygons.dart';

/// The active tab when the page opens
enum ActiveTab {
  /// Activate the polygons tab
  polygon,

  /// Activate the lines tab
  line,

  /// Activate the groups tab
  group,

  /// Activate the points tab
  point
}

class _GeoCrudNavigationPageState extends State<GeoCrudNavigationPage> {
  _GeoCrudNavigationPageState(
      {@required this.db,
      this.appBar,
      this.activeTab,
      this.markersTrailingBuilder}) {
    if (db == null) {
      throw ArgumentError.notNull();
    }
    _getActiveTab();
  }

  final Db db;
  final AppBar appBar;
  final ActiveTab activeTab;
  final ItemWidgetBuilder markersTrailingBuilder;

  int _currentIndex;
  bool _dbIsReady = false;

  @override
  void initState() {
    db.onReady.then((_) {
      setState(() => _dbIsReady = true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _children = <Widget>[
      PolygonsCrudPage(db: db),
      LinesCrudPage(db: db),
      GroupsCrudPage(db: db),
      GeoPointCrudPage(db: db, markersTrailingBuilder: markersTrailingBuilder)
    ];
    final body = _children[_currentIndex];
    final bottomBar = BottomNavigationBar(
      showUnselectedLabels: true,
      onTap: onTabTapped, // new
      currentIndex: _currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_null, color: Colors.deepPurple),
            title: const Text("Polygons")),
        BottomNavigationBarItem(
            icon: Icon(Icons.trending_up, color: Colors.green),
            title: const Text("Lines")),
        BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart, color: Colors.red),
            title: const Text("Groups")),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.blue),
            title: const Text("Points")),
      ],
    );
    Widget w;
    if (appBar != null) {
      w = Scaffold(
          appBar: appBar,
          body: _dbIsReady
              ? body
              : const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: bottomBar);
    } else {
      w = Scaffold(
          body: _dbIsReady
              ? SafeArea(child: body)
              : const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: bottomBar);
    }
    return w;
  }

  void onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _getActiveTab() {
    switch (activeTab) {
      case ActiveTab.polygon:
        _currentIndex = 0;
        break;
      case ActiveTab.line:
        _currentIndex = 1;
        break;
      case ActiveTab.group:
        _currentIndex = 2;
        break;
      case ActiveTab.point:
        _currentIndex = 3;
        break;
      default:
        _currentIndex = 3;
    }
  }
}

/// Navigation page
class GeoCrudNavigationPage extends StatefulWidget {
  /// Default constructor
  const GeoCrudNavigationPage(
      {@required this.db,
      this.appBar,
      this.activeTab,
      this.markersTrailingBuilder});

  /// The dataabase
  final Db db;

  /// The appbar to use
  final AppBar appBar;

  /// The active tab
  final ActiveTab activeTab;

  /// The trailing widget for markers
  final ItemWidgetBuilder markersTrailingBuilder;

  @override
  _GeoCrudNavigationPageState createState() => _GeoCrudNavigationPageState(
      db: db,
      appBar: appBar,
      activeTab: activeTab,
      markersTrailingBuilder: markersTrailingBuilder);
}
