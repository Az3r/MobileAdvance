import 'dart:convert' show utf8;
import 'package:crypto/crypto.dart' show sha512;

extension StringUtilities on String {
  /// SHA-512 hashing algorithm
  String hash() {
    return sha512.convert(utf8.encode(this)).toString();
  }

  Duration toISO8601() {
    if (!RegExp(
            r"^(-|\+)?P(?:([-+]?[0-9,.]*)Y)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)W)?(?:([-+]?[0-9,.]*)D)?(?:T(?:([-+]?[0-9,.]*)H)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)S)?)?$")
        .hasMatch(this)) {
      throw ArgumentError("String does not follow correct format");
    }

    final weeks = _parseTime(this, "W");
    final days = _parseTime(this, "D");
    final hours = _parseTime(this, "H");
    final minutes = _parseTime(this, "M");
    final seconds = _parseTime(this, "S");

    return Duration(
      days: days + (weeks * 7),
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }
}

int _parseTime(String duration, String timeUnit) {
  final timeMatch = RegExp(r"\d+" + timeUnit).firstMatch(duration);

  if (timeMatch == null) {
    return 0;
  }
  final timeString = timeMatch.group(0);
  return int.parse(timeString.substring(0, timeString.length - 1));
}
