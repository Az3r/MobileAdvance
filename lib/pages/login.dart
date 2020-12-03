import 'package:SingularSight/components/form_fields.dart';
import 'package:SingularSight/components/logo.dart';
import 'package:SingularSight/services/exceptions.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login();
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                image: const AssetImage('assets/images/background.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: const LoginForm(),
            width: 640,
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm();
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _email = GlobalKey<EmailFieldState>();
  final _password = GlobalKey<NumberFieldState>();
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

  Future<void> _submit({
    String email,
    String password,
  }) async {
    await LocatorService().users.login(
          email: email,
          password: password,
        );
    return Navigator.of(context).pushNamed(RouteNames.dashboard);
  }

  Future<void> _validate() async {
    final invalid = _form.currentState.validate() == false;
    if (invalid) return Future<void>.value();
    setState(() => _submitting = true);
    try {
      await _submit(
        email: _email.currentState.email,
        password: _password.currentState.number,
      );
    } on FirebaseAuthException {
      showSnackBar('Invalid email or password');
    } on NetworkException {
      final retry = await Navigator.of(context).pushNamed(RouteNames.error);
      if (retry) return _validate();
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ErrorWidget(e)),
      );
    } finally {
      setState(() => _submitting = false);
    }
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
      child: SpinningLogo(spinning: _submitting),
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

  void showSnackBar(String msg) {
    Future.value(Scaffold.of(context)).then((scaffold) {
      scaffold.removeCurrentSnackBar();
      scaffold.showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning, color: Colors.yellow),
            SizedBox(width: 8),
            Text(msg),
          ],
        ),
        backgroundColor: Colors.red,
      ));
    });
  }
}
