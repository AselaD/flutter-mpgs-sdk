import 'dart:io';

import '../flutter_mpgs.dart';

const String STAGE = Environment.PROD; //DEV or PROD
const bool IS_DEV = false; //use to enable logs

class Environment {
  static const String DEV = "dev";
  static const String PROD = "prod";
}

class Parameters {
  static const String VERSION = "0.0.1";
  static const String REGION =
      STAGE == Environment.PROD ? Region.ASIA_PACIFIC : Region.MTF;
  static const String BASE_URL = STAGE == Environment.DEV
      ? "https://dev.paymediasolutions.com/v1/mpg/api/external/cardManage/"
      : "https://prod.orelpay.lk/v1/mpg/api/external/cardManage/";
}

class APIRoutes {
  static const String GET_SESSION = Parameters.BASE_URL + "session";
  static const String ADD_CARD = Parameters.BASE_URL + "cardAdd";
  static const String CHECK_3DS = Parameters.BASE_URL + "check3ds";
  static const String CARD_OTP_VERIFY = Parameters.BASE_URL + "otpVerify";
}

class ScreenState {
  static const int OTP_WIDGET = 2;
  static const int SUCCESS_WIDGET = 4;
  static const int ADD_CARD_WIDGET = 1;
  static const int INITIAL_WIDGET = 0;
  static const int FAILED_WIDGET = 3;
}

class GatewayResponse {
  static const String AUTHENTICATION_SUCCESSFUL = "AUTHENTICATION_SUCCESSFUL";
  static const String AUTHENTICATION_ATTEMPTED = "AUTHENTICATION_ATTEMPTED";
  static const String REDIRECT_SCHEMA = "https";
  static const String ACS_RESULT = "acsResult";
  static const String REDIRECT_HOST = "prod.orelpay.lk";
}

getPlatform() {
  if (Platform.isIOS) {
    return "IOS";
  } else if (Platform.isAndroid) {
    return "Android";
  } else {
    return "NA";
  }
}
