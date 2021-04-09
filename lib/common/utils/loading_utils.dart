import 'package:bot_toast/bot_toast.dart';

class LoadingUtils {
  static show({BackButtonBehavior btnBehavior = BackButtonBehavior.ignore}) {
    BotToast.showLoading(
      backButtonBehavior: btnBehavior,
    );
  }

  static cancel() {
    BotToast.closeAllLoading();
  }
}
