import 'package:SingularSight/components/widgets/logo.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer();

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  PackageInfo _info = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  @override
  void initState() {
    Future.wait<dynamic>([
      PackageInfo.fromPlatform(),
    ]).then((value) {
      setState(() {
        _info = value[0] as PackageInfo;
      });
    }).catchError((error) => log.e('Failed to get infos', error));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onTap: () => Navigator.of(context).pushNamed(RouteNames.bookmarks),
          ),
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('My channels'),
            onTap: () => Navigator.of(context).pushNamed(RouteNames.channels),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.of(context).pushNamed(RouteNames.settings),
          ),
          AboutListTile(
            child: Text('About me'),
            icon: Icon(Icons.info),
            applicationIcon: Logo(width: 32, height: 32),
            applicationName: _info.appName,
            applicationVersion: _info.version,
            applicationLegalese: 'Approved by Mantis Lords',
            aboutBoxChildren: [
              Text('Nguyễn Mạnh Tuấn - 1712875'),
              InkWell(
                  child: Text(
                    AppInfos.github,
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    launch(
                      AppInfos.github,
                      forceSafariVC: false,
                      forceWebView: false,
                    );
                  }),
            ],
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logging out'),
                  content: Text('Are you sure?'),
                  actions: [
                    TextButton(
                      child: Text('Not really'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    ElevatedButton(
                      child: Text('Log me out'),
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteNames.login,
                        (route) => false,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
