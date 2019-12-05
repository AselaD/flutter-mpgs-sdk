#import "FlutterMPGSPlugin.h"

@implementation FlutterMPGSPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMPGSPlugin registerWithRegistrar:registrar];
}
@end
