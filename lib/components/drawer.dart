import 'package:SingularSight/components/errors.dart';
import 'package:SingularSight/components/logo.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer();

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
    return Drawer(
      child: ListView(
        children: [
          StreamBuilder<User>(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return ErrorMessage(message: snapshot.error.toString());
                else if (snapshot.hasData) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(snapshot.data.displayName),
                    accountEmail: Text(snapshot.data.email),
                    currentAccountPicture: snapshot.data.photoURL != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data.photoURL),
                          )
                        : Icon(Icons.image),
                  );
                }
                return Center(child: SpinningLogo());
              }),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('My profile'),
            onTap: () => Navigator.of(context).pushNamed(RouteNames.settings),
          ),
          AboutListTile(
            child: Text('App info'),
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
                    InkWell(
                      child: Text('Not really'),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    ElevatedButton(
                      child: Text('Log me out'),
                      onPressed: () {
                        LocatorService().users.logout();
                        // close drawer
                        Navigator.of(context).pop();
                        // now we push login screen
                        Navigator.of(context)
                            .pushReplacementNamed(RouteNames.login);
                      },
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

  @override
  bool get wantKeepAlive => true;
}
