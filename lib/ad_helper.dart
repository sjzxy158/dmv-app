import 'dart:io';

class AdHelper {
  static String get openAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544/3419835294";
      return "ca-app-pub-6874410873970579/6395591496";
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3940256099942544/5662855259";
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/2247696110';
      return 'ca-app-pub-6874410873970579/3592608808';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-3940256099942544/3986624511';
      return '';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get nativeFullScreenAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/2247696110';
      return 'ca-app-pub-6874410873970579/3083032440';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-3940256099942544/3986624511';
      return '';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
