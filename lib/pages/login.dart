import 'package:SingularSight/components/widgets/logo.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _remember = GlobalKey<_RememberMeState>();
  final _username = GlobalKey<_UsernameState>();
  final _password = GlobalKey<_PasswordState>();
  final _form = GlobalKey<FormState>();
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Logo(
                  width: 64,
                  height: 64,
                ),
              ),
              Username(key: _username),
              Password(key: _password),
              RememberMe(key: _remember),
              ElevatedButton(
                onPressed: () {
                  _remember.currentState.checked;
                },
                child: Text(
                  "Let's go".toUpperCase(),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  onPressed: () {},
                  child: Text('Register'.toUpperCase())),
            ],
          ),
        ),
      ),
    );
  }
}

class RememberMe extends StatefulWidget {
  const RememberMe({Key key}) : super(key: key);
  @override
  _RememberMeState createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  var checked = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.only(left: 4),
      controlAffinity: ListTileControlAffinity.leading,
      value: checked,
      onChanged: (value) => setState(() => checked = value),
      title: Text('Remember me', style: Theme.of(context).textTheme.subtitle2),
    );
  }
}

class Password extends StatefulWidget {
  const Password({Key key}) : super(key: key);
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  var _hide = true;
  var password = '';
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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

class Username extends StatefulWidget {
  const Username({Key key}) : super(key: key);
  @override
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  var username = '';
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      validator: (s) {
        if (s.isEmpty) return "Field can't be empty!";
        username = s;
        return null;
      },
      decoration: InputDecoration(
          filled: true,
          prefixIcon: Icon(Icons.account_circle),
          fillColor: Colors.black54,
          labelText: 'Username',
          hintText: 'My awesome account'),
    );
  }
}
