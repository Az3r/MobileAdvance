
import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final bool enabled;
  const EmailField({Key key, this.enabled}) : super(key: key);
  @override
  EmailFieldState createState() => EmailFieldState();
}

class EmailFieldState extends State<EmailField> {
  var email = '';
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      textInputAction: TextInputAction.next,
      validator: (s) {
        if (s.isEmpty) return "Field can't be empty!";
        email = s;
        return null;
      },
      decoration: InputDecoration(
          filled: true,
          prefixIcon: Icon(Icons.account_circle),
          fillColor: Colors.black54,
          labelText: 'Email',
          hintText: 'My awesome account'),
    );
  }
}