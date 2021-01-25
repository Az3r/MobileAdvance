import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/skill_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:googleapis/firestore/v1.dart';
import 'package:meta/meta.dart';

import 'exceptions.dart';

/// Singleton class
class FirebaseService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final youtube = LocatorService().youtube;

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
    return firestore.collection('skills').snapshots().map((query) =>
        query.docs.map((doc) => SkillModel.fromJson(doc.data())).toList());
  }

  Future<List<PlaylistModel>> watchLaters() async {
    if (auth.currentUser == null) return Future.value(const []);
    final favs = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('watch_laters')
        .get();
    final ids = favs.docs.map((doc) => doc.id).toList();
    return youtube.getPlaylists(ids);
  }

  Future<List<PlaylistModel>> histories() async {
    if (auth.currentUser == null) return Future.value(const []);
    final favs = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('histories')
        .get();

    final ids = favs.docs.map((doc) => doc.id).toList();
    return youtube.getPlaylists(ids);
  }

  Future<List<PlaylistModel>> favorites() async {
    if (auth.currentUser == null) return Future.value(const []);
    final favs = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('favorites')
        .get();

    final ids = favs.docs.map((doc) => doc.id).toList();
    return youtube.getPlaylists(ids);
  }

  Future<void> addToHistories(String id) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('histories')
        .doc(id)
        .set({'timestamp': Timestamp.now()});
  }

  Future<void> addToWatchLaters(String id) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('watch_laters')
        .doc(id)
        .set({});
  }

  Future<void> addToFavorites(String id) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('favorites')
        .doc(id)
        .set({});
  }

  Future<void> removeFromHistories(List<String> ids) async {
    final favs = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('histories')
        .where(FieldPath.documentId, whereIn: ids)
        .get();
    for (final doc in favs.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> removeFromWatchLater(List<String> ids) async {
    final favs = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('watch_laters')
        .where(FieldPath.documentId, whereIn: ids)
        .get();
    for (final doc in favs.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> removeFromFavorites(List<String> ids) async {
    final favs = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('favorites')
        .where(FieldPath.documentId, whereIn: ids)
        .get();
    for (final doc in favs.docs) {
      await doc.reference.delete();
    }
  }
}
