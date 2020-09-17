import 'package:flutter/foundation.dart';

import 'log_entry.dart';
import 'log_level.dart';

/// Manages all logging functionality.
/// Basicliy wraps the print statement.
class Log {
  Log() {
    FlutterError.onError = (details) {
      error(details);
      FlutterError.presentError(details);
    };
  }

  /// Collects all messages send to the buffer.
  final buffer = ValueNotifier(<LogEntry>[]);

  /// Print a debug message.
  void debug(Object object) => _log(LogLevel.debug, object);

  /// Print a warning message.
  void warn(Object object) => _log(LogLevel.warning, object);

  /// Print an error. This will also print the stack trace to the console.
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

  /// Get the complete buffer as a string.
  String bufferToText() {
    return buffer.value.reversed.fold('', (value, element) {
      return '$value${logEntryToText(element)}';
    });
  }

  /// Get a specific log entry as a string.
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
