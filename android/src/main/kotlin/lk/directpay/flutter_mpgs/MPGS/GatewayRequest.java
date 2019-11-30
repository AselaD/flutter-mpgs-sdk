package lk.directpay.flutter_mpgs.MPGS;

import java.util.HashMap;
import java.util.Map;

class GatewayRequest {

    String url;
    Gateway.Method method;

    Map<String, String> extraHeaders = new HashMap<>();

    GatewayMap payload;
}
