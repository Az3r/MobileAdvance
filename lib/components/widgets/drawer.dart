import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Az3r'),
              accountEmail: Text('myemail@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://avatarfiles.alphacoders.com/261/261533.jpg'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bookmarks),
              title: Text('Saved bookmarks'),
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteNames.bookmarks),
            ),
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('My channels'),
              onTap: () => Navigator.of(context).pushNamed(RouteNames.channels),
            )
          ],
        ),
      ),
    );
  }
}
