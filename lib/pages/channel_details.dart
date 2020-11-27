import 'package:SingularSight/components/channel/channel_courses.dart';
import 'package:SingularSight/components/channel/channel_header.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:flutter/material.dart';

class ChannelDetails extends StatelessWidget {
  final ChannelModel channel;

  const ChannelDetails({Key key, this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: profileColor,
        title: Text(channel.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notifications),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0,),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white12,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ChannelHeader(channel: channel),
                ),
              ],
            ),
          ),
          SliverChannelCourses(channelId: channel.id),
        ],
      ),
    );
  }

  Color get profileColor {
    return channel.profileColor == '#000000'
        ? null
        : Color(int.parse(channel.profileColor.replaceRange(0, 1, '0xFF')));
  }
}
