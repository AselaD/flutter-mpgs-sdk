import Flutter
import UIKit

public class SwiftFlutterMPGSPlugin: NSObject, FlutterPlugin {
    var gateway:Gateway? = nil
    var apiVersion:String? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_mpgs", binaryMessenger: registrar.messenger())
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
}
