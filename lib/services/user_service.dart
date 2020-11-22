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
}
