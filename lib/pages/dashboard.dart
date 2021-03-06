import 'package:SingularSight/components/drawer.dart';
import 'package:SingularSight/pages/featured_channels.dart';
import 'package:SingularSight/pages/home.dart';
import 'package:SingularSight/pages/search.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:flutter/material.dart';

/// First page to open, displays app goals and a list of popular courses
/// seperated by type.
/// Each type provides an option to see all courses.
class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _index = 1;
  PageController _controller;
  var _isSnackBarShown = false;
  final _scaffold = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _controller = PageController(
      initialPage: _index,
      keepPage: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_isSnackBarShown) {
          LocatorService().users.logout();
          Navigator.of(context).pop();
          return Future.value(false);
        }
        final snackBar = _scaffold.currentState.showSnackBar(
          SnackBar(
            onVisible: () => _isSnackBarShown = true,
            behavior: SnackBarBehavior.floating,
            content: Text('Press again to logout'),
            action: SnackBarAction(
              textColor: Colors.amber,
              label: 'LOGOUT',
              onPressed: () {
                LocatorService().users.logout();
                Navigator.of(context).pop();
              },
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        snackBar.closed.then((value) => _isSnackBarShown = false);
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffold,
        appBar: AppBar(
          title: Text(pages[_index]),
          centerTitle: true,
        ),
        drawer: const UserDrawer(),
        body: PageView(
          controller: _controller,
          onPageChanged: (i) => setState(() => _index = i),
          children: [
            const Home(),
            const FeaturedChannels(),
            const Search(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => _controller.animateToPage(
            i,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on_outlined),
              activeIcon: Icon(Icons.grid_on),
              label: 'Channels',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }

  List<String> get pages => const ['Home', 'Featured channels', 'Search'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
