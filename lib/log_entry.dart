import 'log_level.dart';

class LogEntry {
  LogEntry(this.level, this.print, this.stackTrace);

  final LogLevel level;
  final String print;
  final StackTrace stackTrace;
  final timestamp = DateTime.now();
}
