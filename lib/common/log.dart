import 'package:logger/logger.dart';

class Log {
  Log._();

  static Logger _logger;

  static void _init() {
    _logger ??= Logger();
  }

  static void d(dynamic msg, [dynamic error, StackTrace stackTrace]) {
    _init();
    _logger.d(msg, error, stackTrace);
  }

  static void e(dynamic msg, [dynamic error, StackTrace stackTrace]) {
    _init();
    _logger.e(msg, error, stackTrace);
  }

  static void i(dynamic msg, [dynamic error, StackTrace stackTrace]) {
    _init();
    _logger.i(msg, error, stackTrace);
  }

  static void v(dynamic msg, [dynamic error, StackTrace stackTrace]) {
    _init();
    _logger.v(msg, error, stackTrace);
  }

  static void w(dynamic msg, [dynamic error, StackTrace stackTrace]) {
    _init();
    _logger.w(msg, error, stackTrace);
  }

  static void wtf(dynamic msg, [dynamic error, StackTrace stackTrace]) {
    _init();
    _logger.wtf(msg, error, stackTrace);
  }
}
