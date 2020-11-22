
import 'package:flutter/material.dart';

class Username extends StatefulWidget {
  final bool enabled;
  const Username({Key key, this.enabled}) : super(key: key);
  @override
  UsernameState createState() => UsernameState();
}

class UsernameState extends State<Username> {
  var username = '';
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      textInputAction: TextInputAction.next,
      validator: (s) {
        if (s.isEmpty) return "Field can't be empty!";
        username = s;
        return null;
      },
      decoration: InputDecoration(
          filled: true,
          prefixIcon: Icon(Icons.account_circle),
          fillColor: Colors.black54,
          labelText: 'Username',
          hintText: 'My awesome account'),
    );
  }
}