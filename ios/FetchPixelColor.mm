#import "FetchPixelColor.h"
#import <React/RCTImageLoader.h>
#import "ImageAndPixelColor.h"

@implementation FetchPixelColor

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(double)a withB:(double)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    NSNumber *result = @(a * b);

    resolve(result);
}

RCT_EXPORT_METHOD(getHex:(NSString *)path
                  options:(NSDictionary *)options
                  callback:(RCTResponseSenderBlock)callback)
{

    [[_bridge moduleForName:@"ImageLoader" lazilyLoadIfNecessary:YES] loadImageWithURLRequest:[RCTConvert NSURLRequest:path] callback:^(NSError *error, UIImage *image) {
        if (error || image == nil) { // if couldn't load from bridge create a new UIImage
            if ([path hasPrefix:@"data:"] || [path hasPrefix:@"file:"]) {
                NSURL *imageUrl = [[NSURL alloc] initWithString:path];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            } else {
                image = [[UIImage alloc] initWithContentsOfFile:path];
            }

            if (image == nil) {
                callback(@[@"Could not create image from given path.", @""]);
                return;
            }
        }
 
        NSInteger x = [RCTConvert NSInteger:options[@"x"]];
        NSInteger y = [RCTConvert NSInteger:options[@"y"]];
        if (options[@"width"] && options[@"height"]) {
            NSInteger scaledWidth = [RCTConvert NSInteger:options[@"width"]];
            NSInteger scaledHeight = [RCTConvert NSInteger:options[@"height"]];
            float originalWidth = image.size.width;
            float originalHeight = image.size.height;
            
            x = x * (originalWidth / scaledWidth);
            y = y * (originalHeight / scaledHeight);
            
        }
        
        CGPoint point = CGPointMake(x, y);
        
        UIColor *pixelColor = [image colorAtPixel:point];
        callback(@[[NSNull null], hexStringForColor(pixelColor)]);
     
    }];
}

NSString * hexStringForColor( UIColor* color ) {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    if(!components){
        return @"#000000";
    }
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"#%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];

    return hexString;
}


// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeFetchPixelColorSpecJSI>(params);
}
#endif

@end
