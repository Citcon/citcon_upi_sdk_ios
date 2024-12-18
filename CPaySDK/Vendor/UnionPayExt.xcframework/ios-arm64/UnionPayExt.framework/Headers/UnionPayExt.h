//
//  UnionPayExt.h
//  UnionPayExt
//
//  Created by long.zhao on 2/23/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for UnionPayExt.
FOUNDATION_EXPORT double UnionPayExtVersionNumber;

//! Project version string for UnionPayExt.
FOUNDATION_EXPORT const unsigned char UnionPayExtVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <UnionPayExt/PublicHeader.h>

typedef void(^CompletionBlock)(NSString *errCode);

@interface UnionPayExt : NSObject

+ (void)payOrder:(NSString *)tradTn
          scheme:(NSString *)scheme
            mode:(NSString *)mode
      controller:(UIViewController *)controller
        callback:(CompletionBlock)completionBlock;

+ (void)handleUrl:(NSURL *)url;
+ (BOOL)isInstalled:(NSString *)mode merchantId:(NSString *)merchantId;

@end
