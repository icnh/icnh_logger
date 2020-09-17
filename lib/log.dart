import 'package:flutter/foundation.dart';

import 'log_entry.dart';
import 'log_level.dart';

class Log {
  Log() {
    FlutterError.onError = (details) {
      error(details);
      FlutterError.presentError(details);
    };
  }

  final buffer = ValueNotifier(<LogEntry>[]);

  void debug(Object object) => _log(LogLevel.debug, object);
  void warn(Object object) => _log(LogLevel.warning, object);
  void error(Object object) => _log(
        LogLevel.error,
        object,
        printStackTrace: true,
      );

  void _log(
    LogLevel level,
    Object object, {
    bool printStackTrace = false,
  }) {
    buffer.value = [
          LogEntry(
            level,
            object.toString(),
            StackTrace.current,
          )
        ] +
        buffer.value;
    // ignore: avoid_print
    print('->${level.tag} $object');
    if (printStackTrace) {
      // ignore: avoid_print
      print(StackTrace.current);
    }
  }

  String bufferToText() {
    return buffer.value.reversed.fold('', (value, element) {
      return '$value${logEntryToText(element)}';
    });
  }

  String logEntryToText(LogEntry logEntry) {
    final time = logEntry.timestamp.toString();
    final level = logEntry.level.tag;
    var text = '->$level $time: ${logEntry.print}';
    if (logEntry.level == LogLevel.error) {
      text += '\n${logEntry.stackTrace}';
    }
    return '$text\n';
  }
}
