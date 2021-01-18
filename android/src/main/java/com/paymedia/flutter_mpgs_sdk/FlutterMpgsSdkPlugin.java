package com.paymedia.flutter_mpgs_sdk;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.microblink.MicroblinkSDK;
import com.microblink.entities.recognizers.Recognizer;
import com.microblink.entities.recognizers.RecognizerBundle;
import com.microblink.entities.recognizers.blinkcard.BlinkCardRecognizer;
import com.microblink.fragment.overlay.blinkcard.scanlineui.ScanLineOverlayStrings;
import com.microblink.recognition.RecognitionSuccessType;
import com.microblink.uisettings.ActivityRunner;
import com.microblink.uisettings.BlinkCardUISettings;
import com.microblink.view.recognition.ScanResultListener;
import com.paymedia.flutter_mpgs_sdk.MPGS.ScannerActivity;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import lk.directpay.flutter_mpgs.MPGS.Gateway;
import lk.directpay.flutter_mpgs.MPGS.GatewayCallback;
import lk.directpay.flutter_mpgs.MPGS.GatewayMap;

/**
 * FlutterMpgsSdkPlugin
 */
public class FlutterMpgsSdkPlugin extends BroadcastReceiver implements FlutterPlugin, MethodCallHandler, ActivityAware {


    private static Activity activity;
    private Gateway gateway;
    private String apiVersion;
    private static Result result;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_mpgs_sdk");
        channel.setMethodCallHandler(new FlutterMpgsSdkPlugin());
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_mpgs_sdk");
        channel.setMethodCallHandler(new FlutterMpgsSdkPlugin());
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
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull final Result result) {
        if (methodCall.method.equals("init")) {
            gateway = new lk.directpay.flutter_mpgs.MPGS.Gateway();
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
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            result.success(true);
                        }
                    });
                }

                @Override
                public void onError(final Throwable throwable) {
                    gateway = null;
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            result.error("Error while updating session!", throwable.getMessage(), null);
                        }
                    });
                }
            });
        } else if (methodCall.method.equals("scanner")) {
            FlutterMpgsSdkPlugin.result = result;
            final String license = methodCall.argument("license");
            MicroblinkSDK.setLicenseKey(license, FlutterMpgsSdkPlugin.activity);
            // create BlinkCardRecognizer
            Intent intent = new Intent(FlutterMpgsSdkPlugin.activity, ScannerActivity.class);
            FlutterMpgsSdkPlugin.activity.startActivity(intent);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        FlutterMpgsSdkPlugin.activity = binding.getActivity();
        IntentFilter filter = new IntentFilter("MICROBLINK_DATA");
        binding.getActivity().registerReceiver(this, filter);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        FlutterMpgsSdkPlugin.activity = binding.getActivity();
        IntentFilter filter = new IntentFilter("MICROBLINK_DATA");
        binding.getActivity().registerReceiver(this, filter);
    }

    @Override
    public void onDetachedFromActivity() {
        FlutterMpgsSdkPlugin.activity.unregisterReceiver(this);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("RECEIVED", intent.getAction());
        if (intent.getAction().equals("MICROBLINK_DATA")) {
            if (FlutterMpgsSdkPlugin.result != null) {
                final String number = intent.getStringExtra("number");
                final String name = intent.getStringExtra("name");
                final String cvv = intent.getStringExtra("cvv");
                final int mm = intent.getIntExtra("mm", 0);
                final int yy = intent.getIntExtra("yy", 0);

                HashMap<String, Object> map = new HashMap<>();

                map.put("number", number);
                map.put("name", name);
                map.put("cvv", cvv);
                map.put("mm", mm);
                map.put("yy", yy);

                Log.d("DATA:", map.toString());
                FlutterMpgsSdkPlugin.result.success(map);
            } else {
                Log.d("RECEIVED", "RESULT IS NULL");
            }
        }
    }
}