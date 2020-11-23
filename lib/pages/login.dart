import 'package:SingularSight/components/login/login_form.dart';
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
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
            image: const AssetImage('assets/images/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: const LoginForm(),
      ),
    );
  }

}
