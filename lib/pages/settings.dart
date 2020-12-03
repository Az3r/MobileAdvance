import 'package:SingularSight/components/form_fields.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  const UserSettings();

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final bool _editing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Form(
        child: Column(
          children: [
NameField(readOnly: _editing,)
          ]
        )

      ),
    );
  }
}
