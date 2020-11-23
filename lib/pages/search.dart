import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatelessWidget {
  const Search();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          child: Text('Open Youtube'),
          onPressed: () {
            launch(
              'https://www.youtube.com/watch?v=HV5YvpbyS6E',
              forceSafariVC: false,
              universalLinksOnly: false,
            );
          }),
    );
  }
}
