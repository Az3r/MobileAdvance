import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/pages/channel_details.dart';
import 'package:SingularSight/pages/error.dart';
import 'package:SingularSight/pages/login.dart';
import 'package:SingularSight/pages/watch_playlist.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';

class Routings {
  Routings._();
  static Route<dynamic> login() {
    return LongerMaterialPageRoute(
      builder: (context) => Login(),
      duration: Duration(seconds: 1),
      settings: RouteSettings(name: RouteNames.login),
    );
  }

  static Route<void> channelDetails(ChannelModel channel) {
    return MaterialPageRoute(
      builder: (context) => ChannelDetails(channel: channel),
      settings: RouteSettings(name: RouteNames.channelDetails),
    );
  }

  static Route<void> watch(PlaylistModel arguments) {
    return MaterialPageRoute(
      builder: (context) => WatchPlaylist(playlist: arguments),
      settings: RouteSettings(name: RouteNames.watch),
    );
  }
}

class LongerMaterialPageRoute extends MaterialPageRoute {
  final Duration duration;
  final WidgetBuilder builder;
  final RouteSettings settings;

  LongerMaterialPageRoute({
    this.builder,
    this.duration,
    this.settings,
  }) : super(
          builder: builder,
          settings: settings,
        );
  @override
  Duration get transitionDuration => duration;
}
