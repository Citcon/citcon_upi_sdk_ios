//
//  WechatPayExt.h
//  WechatPayExt
//
//  Created by long.zhao on 2/22/22.
//

#import <Foundation/Foundation.h>

//! Project version number for WechatPayExt.
FOUNDATION_EXPORT double WechatPayExtVersionNumber;

//! Project version string for WechatPayExt.
FOUNDATION_EXPORT const unsigned char WechatPayExtVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WechatPayExt/PublicHeader.h>

typedef void(^CompletionBlock)(int errCode, NSString *errStr);

@interface WechatPayExt : NSObject

+ (BOOL)registerApp:(NSString *)appId universalLink:(NSString *)links;
+ (BOOL)handleUrl:(NSURL *)url;
+ (BOOL)handleUniversalLink:(NSUserActivity *)userActivity;
+ (void)payOrder:(NSDictionary *)order callback:(CompletionBlock)completionBlock;

@end
