import '../utilities/string_utils.dart';
import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final bool enabled;
  final String Function(String s) validator;
  EmailField({
    Key key,
    this.enabled,
    this.validator,
  }) : super(key: key);
  @override
  EmailFieldState createState() => EmailFieldState();
}

class EmailFieldState extends State<EmailField> {
  var email = '';
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (s) {
        final validator = widget.validator ??
            (s) {
              if (s.isEmpty)
                return "Field can't be empty!";
              else if (!s.isEmail()) return 'Incorrect email format';
              return null;
            };
        final result = validator(s);
        if (result != null) email = s;
        return result;
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

class PasswordField extends StatefulWidget {
  final bool enabled;
  final String label;
  final TextInputAction action;
  final String Function(String s) validator;
  const PasswordField({
    Key key,
    this.label = 'Password',
    this.action = TextInputAction.done,
    this.validator,
    this.enabled,
  }) : super(key: key);
  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  var _hide = true;
  var password = '';
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      textInputAction: widget.action,
      obscureText: _hide,
      validator: (s) {
        final validator = widget.validator ??
            (s) => s.isEmpty ? "Field can't be empty!" : null;
        final result = validator(s);
        if (result == null) password = s;
        return result;
      },
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () => setState(() => _hide = !_hide),
              icon: Icon(_hide ? Icons.visibility : Icons.visibility_off)),
          filled: true,
          prefixIcon: Icon(Icons.vpn_key_rounded),
          fillColor: Colors.black54,
          labelText: widget.label,
          hintText: 'My sercret awesome password'),
    );
  }
}

class NumberField extends StatefulWidget {
  final bool enabled;
  final bool Function(String code) onVerify;
  const NumberField({
    Key key,
    this.enabled,
    this.onVerify,
  }) : super(key: key);
  @override
  NumberFieldState createState() => NumberFieldState();
}

class NumberFieldState extends State<NumberField> {
  var number = '';
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      validator: (s) {
        if (s.isEmpty) return 'Please check your email';
        number = s;
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          suffixIcon: Icon(Icons.close),
          filled: true,
          fillColor: Colors.black54,
          hintText: '123456'),
    );
  }
}
