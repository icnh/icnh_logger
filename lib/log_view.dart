import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'icnh_logger.dart';
import 'log_entry.dart';
import 'log_level.dart';

/// A view showing the content of the Log buffer.
///
/// [onClose] will be called when the close button of this
/// view is pressed.
class LogView extends StatefulWidget {
  const LogView({Key key, this.onClose}) : super(key: key);

  final void Function() onClose;

  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  final Set<LogLevel> _showLogLevels = {
    LogLevel.debug,
    LogLevel.warning,
    LogLevel.error,
  };
  LogEntry _selectedLogEntry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: AnimatedBuilder(
        animation: log.buffer,
        builder: (context, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicWidth(
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            _logLevelButton(LogLevel.debug),
                            const SizedBox(width: 8),
                            _logLevelButton(LogLevel.warning),
                            const SizedBox(width: 8),
                            _logLevelButton(LogLevel.error),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: widget.onClose,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: log.bufferToText()),
                      );
                      final snackBar = SnackBar(
                        content: Text('Log copied!'),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Icon(
                      Icons.content_copy,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: _selectedLogEntry != null
                    ? SingleChildScrollView(
                        child: _logEntryCard(
                          _selectedLogEntry,
                          compact: false,
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.all(0),
                        children: log.buffer.value
                            .where((element) =>
                                _showLogLevels.contains(element.level))
                            .map(_logEntryCard)
                            .toList(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _logLevelButton(LogLevel level) {
    return MaterialButton(
      onPressed: () => setState(() {
        _showLogLevels.contains(level)
            ? _showLogLevels.remove(level)
            : _showLogLevels.add(level);
      }),
      color: _showLogLevels.contains(level) ? level.color : Colors.grey,
      child: Text(level.name),
    );
  }

  Widget _logEntryCard(LogEntry logEntry, {bool compact = true}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedLogEntry == null) {
            _selectedLogEntry = logEntry;
          } else {
            _selectedLogEntry = null;
          }
        });
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: logEntry.level.color,
                  width: 20,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!compact)
                          MaterialButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: log.logEntryToText(logEntry),
                                ),
                              );

                              final snackBar = SnackBar(
                                content: Text('Entry copied!'),
                              );

                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                            child: Icon(Icons.content_copy),
                          ),
                        Text(
                          logEntry.timestamp.toString(),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          logEntry.print,
                          maxLines: compact ? 2 : null,
                          overflow: compact ? TextOverflow.ellipsis : null,
                        ),
                        if (!compact) const SizedBox(height: 20),
                        if (!compact) Text(logEntry.stackTrace.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
