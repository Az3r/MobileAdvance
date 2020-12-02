import 'package:SingularSight/utilities/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import '../utilities/string_utils.dart' show StringUtilities;
import 'exceptions.dart';

class UserService {
  UserService();
  FirebaseAuth get auth => FirebaseAuth.instance;

  Future<User> login({
    @required String email,
    @required String password,
  }) async {
    // remove whitespaces
    email = email.trim();
    password = password.trim();

    try {
      final credentials = await auth.signInWithEmailAndPassword(
        email: email,
        password: password.hash(),
      );
      return credentials.user;
    } on FirebaseAuthException catch (authException) {
      if (authException.code == 'unknown') throw NetworkException();
      log.i('Failed to login, email is $email');
      rethrow;
    } catch (e) {
      log.e('Unknown exception', e);
      rethrow;
    }
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

  Future<void> logout() => auth.signOut();
}
