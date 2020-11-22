import 'dart:convert' show utf8;
import 'package:crypto/crypto.dart' show sha512;

extension StringUtilities on String {
  String hash() {
    return sha512.convert(utf8.encode(this)).toString();
  }
}
