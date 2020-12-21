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
    @required String name,
    @required String password,
    @required String email,
  }) async {
    try {
      email = email.trim();
      password = password.trim();
      final credentials = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password.hash(),
      );
      log.i('Login successfully, email $email');
      return credentials.user..updateProfile(
        displayName: name,
        photoURL: 'https://avatarfiles.alphacoders.com/261/261533.jpg'
      );
    } on FirebaseAuthException catch (authException) {
      if (authException.code == 'unknown') throw NetworkException();
      log.i('Failed to register, email is $email');
      rethrow;
    } catch (e) {
      log.e('Unknown exception', e);
      rethrow;
    }
  }

  Future<bool> ifEmailExists(String email) async {
    try {
      email = email.trim();
      final list = await auth.fetchSignInMethodsForEmail(email);
      return list.isNotEmpty;
    } on FirebaseAuthException catch (authException) {
      if (authException.code == 'unknown') throw NetworkException();
      log.i('Email not found, email is $email');
      rethrow;
    } catch (e) {
      log.e('Unknown exception', e);
      rethrow;
    }
  }

  Future<void> logout() => auth.signOut();
}
