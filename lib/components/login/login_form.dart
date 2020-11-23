import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'password.dart';
import 'remember_me.dart';
import 'spinning_logo.dart';
import 'username.dart';

class LoginForm extends StatefulWidget {
  const LoginForm();
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _remember = GlobalKey<RememberMeState>();
  final _username = GlobalKey<UsernameState>();
  final _password = GlobalKey<PasswordState>();
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
            username,
            const Spacer(flex: 1),
            password,
            const Spacer(flex: 1),
            rememberMe,
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

  Future<bool> _submit({
    String username,
    String password,
  }) async {
    final users = await LocatorService().users;
    final user = await users.validate(username: username, password: password);
    return user != null;
  }

  Future<void> _validate() async {
    if (_form.currentState.validate()) {
      setState(() => _submitting = true);
      final success = await _submit(
        username: _username.currentState.username,
        password: _password.currentState.password,
      );
      if (success) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.dashboard,
          (route) => false,
        );
      } else {
        setState(() => _submitting = false);
        snackbar('Invalid username or password');
      }
    }
  }

  Widget get username => Username(key: _username, enabled: !_submitting);
  Widget get password => Password(key: _password, enabled: !_submitting);
  Widget get rememberMe => RememberMe(key: _remember);
  Widget get loginButton {
    return ElevatedButton(
      onPressed: _submitting ? null : _validate,
      child: const Text("LET'S GO"),
    );
  }

  Widget get registerButton {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.grey),
      onPressed: _submitting ? null : () {},
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
