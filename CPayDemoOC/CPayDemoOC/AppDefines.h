//
//  AppDefines.h
//  CPayDemoOC
//
//  Created by long.zhao on 3/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#undef UIAlertView
#define UIAlertView     UIAlertController

typedef void (^onGetTokenBlock)(NSString * _Nullable token);

@interface AppDefines : NSObject

+ (AppDefines *)sharedInst;
- (NSArray *)getPayments;
- (NSArray *)getCurrencies;
- (NSArray *)getCountries;
- (NSArray *)getVendors;

/// Get access token
/// Note: This function will be remove when offical release.
/// @param vendor The name of vendor
- (void)getAccessToken:(NSString *)vendor callback:(onGetTokenBlock)callback;

@property (nonatomic, retain) NSString *ns_pay_completed;
@property (nonatomic, assign) NSTimeInterval startTime;

@end

NS_ASSUME_NONNULL_END
