import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import '../utilities/string_utils.dart' show StringUtilities;

class UserService {
  UserService();

  final FirebaseFirestore store = FirebaseFirestore.instance;

  Future<bool> validate({
    String username,
    String password,
  }) async {
    final snapshot = await store
        .collection('users')
        .where('name', isEqualTo: username)
        .where('password', isEqualTo: password.hash())
        .limit(1)
        .get();
    return snapshot.size > 0;
  }

  Future<void> add() async {
    return store
        .collection('users')
        .add({
          'full_name': 'Az3r', // John Doe
          'company': 'single player company', // Stokes and Sons
          'age': 42 // 42
        })
        .then((value) => log.i('User "Az3r" added'))
        .catchError((error) => log.e('Failed to add user: $error'));
  }
}
