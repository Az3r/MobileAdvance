import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  final bool enabled;
  const Password({Key key, this.enabled}) : super(key: key);
  @override
  PasswordState createState() => PasswordState();
}

class PasswordState extends State<Password> {
  var _hide = true;
  var password = '';
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      textInputAction: TextInputAction.done,
      obscureText: _hide,
      validator: (s) {
        if (s.isEmpty) return "Field can't be empty!";
        password = s;
        return null;
      },
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () => setState(() => _hide = !_hide),
              icon: Icon(_hide ? Icons.visibility : Icons.visibility_off)),
          filled: true,
          prefixIcon: Icon(Icons.vpn_key_rounded),
          fillColor: Colors.black54,
          labelText: 'Password',
          hintText: 'My sercret awesome password'),
    );
  }
}
