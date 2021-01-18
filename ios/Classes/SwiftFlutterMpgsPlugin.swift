import Flutter
import UIKit
import Microblink

public class SwiftFlutterMPGSPlugin: NSObject, FlutterPlugin, MBBlinkCardOverlayViewControllerDelegate {
    var flutterResult: FlutterResult?
    var blinkCardRecognizer: MBBlinkCardRecognizer!

    var gateway:Gateway? = nil
    var apiVersion:String? = nil
    var microblinkLicense:String? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_mpgs_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterMPGSPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func getRegion(_ region:String) -> GatewayRegion{
        switch region {
        case "ap-":
            return .asiaPacific
        case "eu-":
            return .europe
        case "na-":
            return .northAmerica
        default:
            return .mtf
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arguments:NSDictionary = call.arguments as? NSDictionary {
            switch call.method {
            case "init":
                let region = arguments.value(forKey: "region") as! String
                let gatewayId = arguments.value(forKey: "gatewayId") as! String
                self.apiVersion = (arguments.value(forKey: "apiVersion") as! String)
                
                self.gateway = Gateway(region: getRegion(region), merchantId: gatewayId)
                result(true)
                break
            case "scanner":
                self.flutterResult = result
                self.microblinkLicense = arguments.value(forKey: "license") as? String
                if(self.microblinkLicense == nil){
                    result(nil)
                }
                MBMicroblinkSDK.sharedInstance().setLicenseKey(self.microblinkLicense!)
                
                /** Create BlinkCard recognizer */
                blinkCardRecognizer = MBBlinkCardRecognizer()
                
                /** Create BlinkCard settings */
                let settings : MBBlinkCardOverlaySettings = MBBlinkCardOverlaySettings()
                
                /** Crate recognizer collection */
                let recognizerList = [blinkCardRecognizer!]
                let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
                
                /** Create your overlay view controller */
                let blinkCardOverlayViewController = MBBlinkCardOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
                
                /** Create recognizer view controller with wanted overlay view controller */
                let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: blinkCardOverlayViewController)
                recognizerRunneViewController.modalPresentationStyle = .fullScreen
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
                    topController.present(recognizerRunneViewController, animated: true, completion: nil)
                }
                break
            case "updateSession":
                if(gateway == nil){
                    print("Not initialized!")
                    result(FlutterError(code: "MPGS-01", message: "Not initialized", details: nil))
                }
                
                if(self.apiVersion == nil){
                    result(FlutterError(code: "MPGS-02", message: "Invalid api version", details: nil))
                }
                
                let sessionId = arguments.value(forKey: "sessionId") as! String
                let cardHolder = arguments.value(forKey: "cardHolder") as! String
                let cardNumber = arguments.value(forKey: "cardNumber") as! String
                let year = arguments.value(forKey: "year") as! String
                let month = arguments.value(forKey: "month") as! String
                let cvv = arguments.value(forKey: "cvv") as! String
                
                var request:GatewayMap = GatewayMap()
                
                request[at: "sourceOfFunds.provided.card.nameOnCard"] = cardHolder
                request[at: "sourceOfFunds.provided.card.number"] = cardNumber
                request[at: "sourceOfFunds.provided.card.securityCode"] = cvv
                request[at: "sourceOfFunds.provided.card.expiry.month"] = month
                request[at: "sourceOfFunds.provided.card.expiry.year"] = year
                
                self.gateway?.updateSession(sessionId, apiVersion: self.apiVersion!, payload: request, completion: { (response: GatewayResult<GatewayMap>) in
                    switch(response){
                    case .error(let error):
                        result(FlutterError(code: "MPGS-000",
                                            message: String(describing: error),
                                            details: nil))
                        break
                    case .success(_):
                        result(true)
                        break
                    }
                    self.gateway = nil
                })
                break
            default:
                result(FlutterError(code: "0", message: "Not implimented", details: nil))
            }
        }
    }
    
    public func blinkCardOverlayViewControllerDidFinishScanning(_ blinkCardOverlayViewController: MBBlinkCardOverlayViewController, state: MBRecognizerResultState) {

        if(self.flutterResult != nil){
            let card:[String:Any] = [
                "number" : blinkCardRecognizer.result.cardNumber,
                "cvv": blinkCardRecognizer.result.cvv,
                "mm": blinkCardRecognizer.result.validThru.month,
                "yy": blinkCardRecognizer.result.validThru.year,
                "name": blinkCardRecognizer.result.owner
            ]
            self.flutterResult!(card)
        }
        
        DispatchQueue.main.async {
            blinkCardOverlayViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func blinkCardOverlayViewControllerDidTapClose(_ blinkCardOverlayViewController: MBBlinkCardOverlayViewController) {
        blinkCardOverlayViewController.dismiss(animated: true, completion: nil)
    }
}
