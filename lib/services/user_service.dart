import 'package:SingularSight/utilities/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import '../utilities/string_utils.dart' show StringUtilities;

class UserService {
  UserService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> login({
    @required String email,
    @required String password,
  }) {
    // remove whitespaces
    email = email.trim();
    password = password.trim();

    return auth
        .signInWithEmailAndPassword(email: email, password: password.hash())
        .then((credentials) => credentials.user)
        .catchError(
          (error) => log.e('Failed to login for user $email', error),
          test: (e) => e is PlatformException,
        )
        .catchError((e) => log.e('Unknown error', e), test: (e) => false);
  }

  Future<User> register({
    @required String password,
    @required String email,
  }) {
    return auth
        .createUserWithEmailAndPassword(email: email, password: password.hash())
        .then((credentials) => credentials.user)
        .catchError(
          (error) => log.e("Failed to resgister user", error),
          test: (e) => e is FirebaseAuthException,
        );
  }
}
