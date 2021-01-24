import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/skill_model.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

import 'exceptions.dart';

/// Singleton class
class FirebaseService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  static FirebaseService instance = FirebaseService._();
  FirebaseService._();

  factory FirebaseService() => instance;

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
        password: password,
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
        password: password,
      );
      log.i('Login successfully, email $email');
      return credentials.user
        ..updateProfile(
            displayName: name,
            photoURL: 'https://avatarfiles.alphacoders.com/261/261533.jpg');
    } on FirebaseAuthException catch (authException) {
      if (authException.code == 'unknown') throw NetworkException();
      log.i('Failed to register, email is $email');
      rethrow;
    } catch (e) {
      log.e('Unknown exception', e);
      rethrow;
    }
  }

  Stream<List<SkillModel>> skills() {
    return firestore.collection('skills').snapshots().map((query) => query.docs
        .where((doc) => doc.exists)
        .map((doc) => SkillModel.fromJson(doc.data()))
        .toList());
  }
}
