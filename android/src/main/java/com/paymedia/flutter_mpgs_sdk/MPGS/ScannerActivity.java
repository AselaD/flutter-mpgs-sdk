package com.paymedia.flutter_mpgs_sdk.MPGS;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;

import com.microblink.entities.recognizers.Recognizer;
import com.microblink.entities.recognizers.RecognizerBundle;
import com.microblink.entities.recognizers.blinkcard.BlinkCardRecognizer;
import com.microblink.uisettings.ActivityRunner;
import com.microblink.uisettings.BlinkCardUISettings;
import com.paymedia.flutter_mpgs_sdk.R;

public class ScannerActivity extends AppCompatActivity {
    private int MY_REQUEST_CODE = 69;

    private BlinkCardRecognizer mRecognizer;
    private RecognizerBundle mRecognizerBundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);

        setContentView(R.layout.activity_scanner);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        mRecognizer = new BlinkCardRecognizer();
        // bundle recognizers into RecognizerBundle
        mRecognizerBundle = new RecognizerBundle(mRecognizer);
        startScanning();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == MY_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                // load the data into all recognizers bundled within your RecognizerBundle
                mRecognizerBundle.loadFromIntent(data);

                // now every recognizer object that was bundled within RecognizerBundle
                // has been updated with results obtained during scanning session

                // you can get the result by invoking getResult on recognizer
                BlinkCardRecognizer.Result result = mRecognizer.getResult();

                if (result.getResultState() == Recognizer.Result.State.Valid) {
                    // result is valid, you can use it however you wish
                    Intent intent = new Intent("MICROBLINK_DATA");
                    intent.setAction("MICROBLINK_DATA");
                    intent.putExtra("name", result.getOwner());
                    intent.putExtra("number", result.getCardNumber());
                    intent.putExtra("cvv", result.getCvv());
                    intent.putExtra("mm", result.getValidThru().getDate().getMonth());
                    intent.putExtra("yy", result.getValidThru().getDate().getYear());

                    sendBroadcast(intent);
                    Log.d("SENT", "SENT");
                }

                finish();
            } else if (resultCode == Activity.RESULT_CANCELED) {
                finish();
            }
        }
    }

    // method within MyActivity from previous step
    public void startScanning() {
        // Settings for BlinkCardActivity
        BlinkCardUISettings settings = new BlinkCardUISettings(mRecognizerBundle);
        // tweak settings as you wish
        // Start activity
        ActivityRunner.startActivityForResult(this, MY_REQUEST_CODE, settings);
    }
}