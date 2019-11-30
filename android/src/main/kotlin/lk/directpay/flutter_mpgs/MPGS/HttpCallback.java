package lk.directpay.flutter_mpgs.MPGS;

import org.json.JSONObject;

public interface HttpCallback {
    void success(JSONObject data);

    void error(String code, String title, String message);
}
