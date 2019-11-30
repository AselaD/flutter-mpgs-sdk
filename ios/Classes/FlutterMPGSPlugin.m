#import "FlutterMPGSPlugin.h"
#import <flutter_mpgs/flutter_mpgs-Swift.h>

@implementation FlutterMPGSPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMPGSPlugin registerWithRegistrar:registrar];
}
@end
