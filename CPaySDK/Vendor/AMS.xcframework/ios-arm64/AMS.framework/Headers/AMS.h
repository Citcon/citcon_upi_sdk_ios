//
//  AMS.h
//  AMS
//
//  Created by long.zhao on 3/25/22.
//

#import <Foundation/Foundation.h>

//! Project version number for AMS.
FOUNDATION_EXPORT double AMSVersionNumber;

//! Project version string for AMS.
FOUNDATION_EXPORT const unsigned char AMSVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AMS/PublicHeader.h>

typedef void(^CompletionBlock)(NSDictionary *resultDic);

@interface AMS : NSObject

+ (void)payOrder:(NSString *)url callback:(CompletionBlock)callback;

+ (void)handleUrl:(NSURL *)url;

@end
