import 'package:SingularSight/pages/browse.dart';
import 'package:SingularSight/pages/home.dart';
import 'package:SingularSight/pages/search.dart';
import 'package:flutter/material.dart';
import '../components/course/course_master.dart';

/// First page to open, displays app goals and a list of popular courses
/// seperated by type.
/// Each type provides an option to see all courses.
class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _index = 0;
  PageController _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: _index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pages[_index]),
        centerTitle: true,
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => _index = i),
        children: [
          const Home(),
          const Browse(),
          const Search(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          _index = i;
          _controller.jumpToPage(_index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on_outlined),
            activeIcon: Icon(Icons.grid_on),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }

  List<String> get pages => const ['Home', 'Browse', 'Search'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
