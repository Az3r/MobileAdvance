import 'package:SingularSight/models/playlist_model.dart';
import 'package:flutter/material.dart';

class WatchPlaylist extends StatelessWidget {
  final PlaylistModel playlist;

  const WatchPlaylist({Key key, this.playlist}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
