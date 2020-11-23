import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import '../utilities/string_utils.dart' show StringUtilities;
import '../models/user.dart';

class UserService {
  UserService();

  final FirebaseFirestore store = FirebaseFirestore.instance;
  String get loggedUserId => loggedUser?.id;
  User loggedUser = null;

  Future<User> validate({
    String username,
    String password,
  }) async {
    username = username.trim();
    password = password.trim();
    return store
        .collection('users')
        .where('name', isEqualTo: username)
        .where('password', isEqualTo: password.hash())
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        loggedUser = User.fromJson(value.docs.first.data());
        return loggedUser;
      }
      return null;
    }).catchError((error) {
      log.e('Failed to validate user', error);
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
