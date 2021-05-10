import 'package:logger/logger.dart';

enum Type { Verbose, Debug, Info, Warning, Error, WTF }

class LoggerUtils {
  static void show({Type messageType = Type.Verbose, String message}) {
    var logger = Logger();
    if (message == null) {
      return;
    }

    switch (messageType) {
      case Type.Debug:
        logger.d(message);
        break;
      case Type.Error:
        logger.e(message);
        break;
      case Type.Info:
        logger.i(message);
        break;
      case Type.Warning:
        logger.w(message);
        break;
      case Type.WTF:
        logger.wtf(message);
        break;
      default:
        logger.v(message);
    }
  }
}
