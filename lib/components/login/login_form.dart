import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'password_field.dart';
import 'spinning_logo.dart';
import 'email_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm();
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _email = GlobalKey<EmailFieldState>();
  final _password = GlobalKey<PasswordFieldState>();
  final _form = GlobalKey<FormState>();
  var _submitting = false;
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _submitting,
      child: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(flex: 20, child: banner),
            email,
            const Spacer(flex: 1),
            password,
            const Spacer(flex: 2),
            loginButton,
            const Spacer(flex: 1),
            registerButton,
            Flexible(flex: 12, child: loading),
          ],
        ),
      ),
    );
  }

  Future<User> _submit({
    String username,
    String password,
  }) {
    return LocatorService().users.login(email: username, password: password);
  }

  Future<void> _validate() async {
    final invalid = _form.currentState.validate() == false;
    if (invalid) return null;
    setState(() => _submitting = true);
    return _submit(
      username: _email.currentState.email,
      password: _password.currentState.password,
    ).then((value) {
      if (value == null) {
        snackbar('Invalid email or password');
        setState(() => _submitting = false);
      }
      return Navigator.of(context).pushReplacementNamed(RouteNames.dashboard);
    }).catchError(
      (error) => Navigator.of(context).pushNamed(
        RouteNames.error,
        arguments: () {},
      ),
    );
  }

  Widget get email => EmailField(key: _email, enabled: !_submitting);
  Widget get password => PasswordField(key: _password, enabled: !_submitting);
  Widget get loginButton {
    return ElevatedButton(
      onPressed: _submitting ? null : _validate,
      child: const Text("LET'S GO"),
    );
  }

  Widget get registerButton {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.grey),
      onPressed: _submitting
          ? null
          : () => Navigator.of(context).pushNamed(RouteNames.register),
      child: const Text('REGISTER'),
    );
  }

  Widget get loading {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SpinningLogo(submitting: _submitting),
    );
  }

  Widget get banner {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SingularSight',
          style: Theme.of(context).textTheme.headline3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'You request, we provide',
            style: Theme.of(context).textTheme.overline,
          ),
        )
      ],
    );
  }

  void snackbar(String msg) {
    Future.value(Scaffold.of(context)).then((scaffold) {
      scaffold.removeCurrentSnackBar();
      scaffold.showSnackBar(SnackBar(
        content: Text(msg),
      ));
    });
  }
}
