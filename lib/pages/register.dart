import 'package:SingularSight/components/form_fields.dart';
import 'package:SingularSight/components/logo.dart';
import 'package:SingularSight/services/exceptions.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.white,
          child: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter:
                      ColorFilter.mode(Colors.black38, BlendMode.darken),
                  image: const AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: const RegisterForm(),
              width: 640,
            ),
          ],
        ));
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key key,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _form = GlobalKey<FormState>();
  final _email = GlobalKey<EmailFieldState>();
  final _password = GlobalKey<PasswordFieldState>();
  final _confirmPassword = GlobalKey<PasswordFieldState>();
  var _submitting = false;
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _submitting,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(flex: 20, child: banner),
              EmailField(enabled: !_submitting, key: _email),
              Spacer(flex: 1),
              PasswordField(key: _password, enabled: !_submitting),
              Spacer(flex: 1),
              confirmPasswordField,
              Spacer(flex: 2),
              registerButton,
              Flexible(flex: 12, child: loading),
            ],
          ),
        ),
      ),
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

  Widget get confirmPasswordField {
    return PasswordField(
      key: _confirmPassword,
      enabled: !_submitting,
      label: 'Confirm password',
      validator: (s) {
        final password = _password.currentState.password;
        if (s != password) return 'Password does not match';
        return null;
      },
    );
  }

  Widget get registerButton {
    return SizedBox(
      child: ElevatedButton(
        child: Text('REGISTER'),
        onPressed: () {},
      ),
    );
  }

  Widget get loading {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SpinningLogo(spinning: _submitting),
    );
  }

  Future<void> _submit() async {
    final email = _email.currentState.email;
    final password = _password.currentState.password;
    await LocatorService().users.register(
          email: email,
          password: password,
        );
    return Navigator.of(context).pushNamed(RouteNames.dashboard);
  }

  Future<void> _validate() async {
    final invalid = !_form.currentState.validate();
    if (invalid) return;
    setState(() => _submitting = true);
    try {
      await _submit();
    } on FirebaseAuthException {
      showSnackBar('');
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
