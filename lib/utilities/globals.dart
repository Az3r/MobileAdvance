import 'package:logger/logger.dart';
import 'package:html_unescape/html_unescape.dart';
/// a single [Logger] instance which is used through out the whole app
final log = Logger(level: Level.info);
final htmlUnEscape = HtmlUnescape();