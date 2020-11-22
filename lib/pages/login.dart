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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.blue[700], BlendMode.darken),
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: AbsorbPointer(
          absorbing: _submitting,
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    flex: 20,
                    child: Column(
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
                    )),
                username,
                Spacer(flex: 1),
                password,
                Spacer(flex: 1),
                rememberMe,
                Spacer(flex: 2),
                loginButton,
                Spacer(flex: 1),
                registerButton,
                Flexible(flex: 12, child: loading),
              ],
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
      child: Text('REGISTER'),
    );
  }

  Widget get loading {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SpinningLogo(submitting: _submitting),
    );
  }
}
