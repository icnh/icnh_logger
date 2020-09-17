import 'package:flutter/material.dart';

enum LogLevel { debug, warning, error }

extension LogLevelFunctions on LogLevel {
  String get tag {
    switch (this) {
      case LogLevel.debug:
        return 'd';
      case LogLevel.warning:
        return 'w';
      case LogLevel.error:
        return 'e';
    }
    throw UnimplementedError('Missing case "$this"');
  }

  String get name {
    switch (this) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
    }
    throw UnimplementedError('Missing case "$this"');
  }

  Color get color {
    switch (this) {
      case LogLevel.debug:
        return Colors.blue;
      case LogLevel.warning:
        return Colors.yellow;
      case LogLevel.error:
        return Colors.red;
    }
    throw UnimplementedError('Missing case "$this"');
  }
}
