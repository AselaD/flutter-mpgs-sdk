package lk.directpay.flutter_mpgs;

import android.app.Activity;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import lk.directpay.flutter_mpgs.MPGS.Gateway;
import lk.directpay.flutter_mpgs.MPGS.GatewayCallback;
import lk.directpay.flutter_mpgs.MPGS.GatewayMap;

public class FlutterMPGSPlugin implements MethodChannel.MethodCallHandler {

    private Activity activity;
    private Gateway gateway;
    private String apiVersion;

    private FlutterMPGSPlugin(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_mpgs");
        channel.setMethodCallHandler(new FlutterMPGSPlugin(registrar.activity()));
    }

    private Gateway.Region getRegion(String region) {
        switch (region) {
            case "ap-":
                return Gateway.Region.ASIA_PACIFIC;
            case "eu-":
                return Gateway.Region.EUROPE;
            case "na-":
                return Gateway.Region.NORTH_AMERICA;
            default:
                return Gateway.Region.MTF;
        }
    }

    @Override
    public void onMethodCall(MethodCall methodCall, final MethodChannel.Result result) {
        if (methodCall.method.equals("init")) {
            gateway = new Gateway();
            this.apiVersion = methodCall.argument("apiVersion");
            String gatewayId = methodCall.argument("gatewayId");
            String region = methodCall.argument("region");

            gateway.setMerchantId(gatewayId);
            gateway.setRegion(getRegion(region));

            result.success(true);
        } else if (methodCall.method.equals("updateSession")) {
            if (gateway == null) {
                result.error("Error", "Not initialized!", null);
            }

            final String sessionId = methodCall.argument("sessionId");
            final String cardHolder = methodCall.argument("cardHolder");
            final String cardNumber = methodCall.argument("cardNumber");
            final String year = methodCall.argument("year");
            final String month = methodCall.argument("month");
            final String cvv = methodCall.argument("cvv");

            Log.i("MPGS", "onMethodCall: updateSession " + this.apiVersion + ", sessionId:" + sessionId);
            GatewayMap request = new GatewayMap();

            request.set("sourceOfFunds.provided.card.nameOnCard", cardHolder);
            request.set("sourceOfFunds.provided.card.number", cardNumber);
            request.set("sourceOfFunds.provided.card.securityCode", cvv);
            request.set("sourceOfFunds.provided.card.expiry.month", month);
            request.set("sourceOfFunds.provided.card.expiry.year", year);

            gateway.updateSession(sessionId, this.apiVersion, request, new GatewayCallback() {
                @Override
                public void onSuccess(final GatewayMap response) {
                    gateway = null;
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(true);
                        }
                    });
                }

                @Override
                public void onError(final Throwable throwable) {
                    gateway = null;
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.error("Error while updating session!", throwable.getMessage(), null);
                        }
                    });
                }
            });
        } else {
            result.notImplemented();
        }
    }
}
