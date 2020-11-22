import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import '../utilities/string_utils.dart' show StringUtilities;

class UserService {
  UserService();

  final FirebaseFirestore store = FirebaseFirestore.instance;
  String loggedUserId = null;
  dynamic loggedUser = null;

  Future<String> validate({
    String username,
    String password,
  }) async {
    username = username.trim();
    password = password.trim();
    return store
        .collection('users')
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password.hash())
        .limit(1)
        .get()
        .then((value) {
      return value.docs.first.id;
    }).catchError((error) {
      log.i({
        'result': 'user does not exist in database',
        'params': {
          'username': username,
          'password': password,
        }
      });
      return null;
    });
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
