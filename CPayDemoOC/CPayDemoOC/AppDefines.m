//
//  AppDefines.m
//  CPayDemoOC
//
//  Created by long.zhao on 3/2/22.
//

#import "AppDefines.h"
#import <CPaySDK/CPaySDK-Swift.h>

@interface AppDefines ()
@property (nonatomic, retain) NSArray *ns_payment;
@property (nonatomic, retain) NSArray *ns_currency;
@property (nonatomic, retain) NSArray *ns_country;
@property (nonatomic, retain) NSArray *ns_vendors;
@end

@implementation AppDefines

+ (AppDefines *)sharedInst {
    static AppDefines *inst = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        inst = [AppDefines new];
        [inst initData];
    });
    return inst;
}

- (NSArray *)getPayments {
    return self.ns_payment;
}

- (NSArray *)getCountries {
    return self.ns_country;
}

- (NSArray *)getCurrencies {
    return self.ns_currency;
}

- (NSArray *)getVendors {
    return self.ns_vendors;
}

- (void)initData {
    self.ns_pay_completed = @"CPayDemoOC.payment_completed";
    
    self.ns_payment = @[
        @"upop",
        @"wechatpay",
        @"alipay",
        @"card",
        @"paypal",
        @"venmo"
    ];
    
    self.ns_country = @[
        @"CN",
        @"US",
        @"CA",
        @"EN",
        @"AU",
        @"SG",
        @"NZ"
    ];
    
    self.ns_currency = @[
        @"CNY",
        @"USD",
        @"CAD",
        @"GBP",
        @"AUD",
        @"SGD",
        @"NZD"
    ];
    
    self.ns_vendors = @[
        @"braintree",
        @"kfc_upi_usd",
        @"kfc_upi_cad"
    ];
}

- (void)getAccessToken:(NSString *)vendor callback:(nonnull onGetTokenBlock)callback {
    [[CPayManager sharedInst] getAccessToken:vendor onComplete:^(NSString * _Nullable token) {
        NSLog(@"\nGet a new access-token:\n%@", token);
        callback(token);
    }];
}

@end
