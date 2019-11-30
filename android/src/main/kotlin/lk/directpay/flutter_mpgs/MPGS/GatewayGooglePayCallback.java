package lk.directpay.flutter_mpgs.MPGS;



import org.json.JSONObject;

public interface GatewayGooglePayCallback {

    /**
     * Called when payment data is returned from GooglePay
     *
     * @param paymentData A json object containing details about the payment
     * @see <a href="https://developers.google.com/pay/api/android/reference/object#PaymentData">PaymentData</a>
     */
    void onReceivedPaymentData(JSONObject paymentData);

    /**
     * Called when a user cancels a GooglePay transaction
     */
    void onGooglePayCancelled();

    /**
     * Called when an error occurs during a GooglePay transaction
     *
     * @param status The corresponding status object of the request
     */
//    void onGooglePayError(Status status);
}
