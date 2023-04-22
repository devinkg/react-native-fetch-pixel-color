
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNFetchPixelColorSpec.h"

@interface FetchPixelColor : NSObject <NativeFetchPixelColorSpec>
#else
#import <React/RCTBridgeModule.h>

@interface FetchPixelColor : NSObject <RCTBridgeModule>
#endif

@end
