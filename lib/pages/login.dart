import 'package:SingularSight/components/login/password.dart';
import 'package:SingularSight/components/login/remember_me.dart';
import 'package:SingularSight/components/login/spinning_logo.dart';
import 'package:SingularSight/components/login/username.dart';
import 'package:SingularSight/components/widgets/logo.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _remember = GlobalKey<RememberMeState>();
  final _username = GlobalKey<UsernameState>();
  final _password = GlobalKey<PasswordState>();
  final _form = GlobalKey<FormState>();
  var _submitting = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.softLight),
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: AbsorbPointer(
            absorbing: _submitting,
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  username,
                  password,
                  rememberMe,
                  loginButton,
                  registerButton,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SpinningLogo(submitting: _submitting),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _submit({
    String username,
    String password,
  }) async {
    return await Future.delayed(Duration(seconds: 5), () => false);
  }

  Widget get username => Username(key: _username, enabled: !_submitting);
  Widget get password => Password(key: _password, enabled: !_submitting);
  Widget get rememberMe => RememberMe(key: _remember);
  Widget get loginButton {
    return ElevatedButton(
      onPressed: () async {
        if (_form.currentState.validate()) {
          setState(() => _submitting = true);
          if (await _submit(
            username: _username.currentState.username,
            password: _password.currentState.password,
          )) {
          } else {
            setState(() => _submitting = false);
          }
        }
      },
      child: Text("LET'S GO"),
    );
  }

  Widget get registerButton {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.grey),
        onPressed: () {},
        child: Text('REGISTER'));
  }
}
