import 'dart:collection';

import 'package:logging/logging.dart';

/// sets the logic for Flutter logging
class LoggingConfig {
  final int maxLogNumber = 100;
  final Queue<LogRecord> logs = Queue();

  void handleLogs(dynamic record) {
    // To get your preferred output only you can do something like this:
    //
    //  if (record.toString().contains('your preferred identifier here')) {
    //    print('your print logic here');
    //  }
    //  else { ...
    //

    print('[${record.level.name}] ${record.loggerName} '
        '-- ${record.time} -- ${record.message}');

    logs.addLast(record);
    while (logs.length > maxLogNumber) {
      logs.removeFirst();
    }
  }
}
