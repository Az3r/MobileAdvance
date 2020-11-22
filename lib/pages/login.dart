import 'package:SingularSight/components/widgets/logo.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.contain,
          ),
        ),
        child: Hero(
          tag: 'logo',
          child: Logo(
            width: 64,
            height: 64,
          ),
        ),
      ),
    );
  }
}
