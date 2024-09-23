import 'package:logger/logger.dart';

final lg = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Number of method calls to be displayed
    errorMethodCount: 8, // Number of method calls if stacktrace is provided
    lineLength: 120, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: false, // Print an emoji for each log message
    // dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
