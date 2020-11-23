import 'package:SingularSight/components/login/login_form.dart';
import 'package:SingularSight/components/login/password.dart';
import 'package:SingularSight/components/login/remember_me.dart';
import 'package:SingularSight/components/login/spinning_logo.dart';
import 'package:SingularSight/components/login/username.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
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
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.blue[700], BlendMode.darken),
            image: const AssetImage('assets/images/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: const LoginForm(),
      ),
    );
  }

}
