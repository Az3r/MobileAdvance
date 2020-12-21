import 'package:SingularSight/components/errors.dart';
import 'package:SingularSight/components/logo.dart';
import 'package:SingularSight/components/snack_bar.dart';
import '../utilities/string_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  const UserSettings();

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final _form = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  var _submitting = false;
  var _username = '';
  var _newPassword = '';
  var _oldPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<User>(
            stream: auth.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ErrorMessage(message: snapshot.error.toString());
              } else if (snapshot.hasData)
                return Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        enabled: !_submitting,
                        textInputAction: TextInputAction.next,
                        initialValue: snapshot.data.displayName,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          labelText: 'Username',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          alignLabelWithHint: true,
                        ),
                        validator: (s) {
                          if (s.isEmpty) return 'Field cannot be empty';
                          _username = s;
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        enabled: !_submitting,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          labelText: 'Old password',
                          hintText: 'Please type your password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (s) {
                          _oldPassword = s;
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        enabled: !_submitting,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          labelText: 'New password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (s) {
                          if (_oldPassword.isNotEmpty && s.isEmpty)
                            return 'Field cannot be empty';
                          _newPassword = s;
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('SUBMIT'),
                        onPressed: _submitting
                            ? null
                            : () async {
                                if (_form.currentState.validate()) {
                                  setState(() => _submitting = true);
                                  try {
                                    // update displayName
                                    await snapshot.data.updateProfile(
                                      displayName: _username,
                                      photoURL: snapshot.data.photoURL,
                                    );

                                    // update password
                                    if (_oldPassword.isNotEmpty &&
                                        _newPassword.isNotEmpty) {
                                      // re-authenticate user
                                      final credential =
                                          EmailAuthProvider.credential(
                                        email: snapshot.data.email,
                                        password: _oldPassword,
                                      );
                                      await snapshot.data
                                          .reauthenticateWithCredential(
                                              credential);

                                      await snapshot.data
                                          .updatePassword(_oldPassword.hash());
                                    }

                                    Scaffold.of(context).showSnackBar(
                                      SuccessSnackBar(
                                          label: 'Update profile successfully'),
                                    );
                                  } catch (err) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Unable to update profile'),
                                        content: Text(err.toString()),
                                      ),
                                    );
                                  } finally {
                                    setState(() => _submitting = false);
                                  }
                                }
                              },
                      ),
                      SizedBox(height: 16),
                      if (_submitting)
                        Center(child: SpinningLogo(spinning: true))
                    ],
                  ),
                );
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
