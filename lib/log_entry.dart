import 'log_level.dart';

/// Entry in the Log continaing [LogLevel], Timestamp, StackTrace and log message.
/// The timestamp is auto generated on object initialization.
class LogEntry {
  LogEntry(this.level, this.print, this.stackTrace);

  final LogLevel level;
  final String print;
  final StackTrace stackTrace;
  final timestamp = DateTime.now();
}
