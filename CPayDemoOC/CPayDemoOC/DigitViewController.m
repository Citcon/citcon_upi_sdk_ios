//
//  DigitViewController.m
//  CPayDemoOC
//
//  Created by long.zhao on 3/13/22.
//

#import "DigitViewController.h"
#import "AppDefines.h"
//#import <CPaySDK/CPaySDK.h>
#import <CPaySDK/CPaySDK-Swift.h>


@interface DigitViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtRefId;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrency;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeout;
@property (weak, nonatomic) IBOutlet UITextField *txtSucUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtIPNUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtCancelUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtFailUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;

@property (nonatomic, copy) NSString *paymentMethod;
@property (nonatomic, copy) NSString *digitTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtTxnId;
@property (weak, nonatomic) IBOutlet UISwitch *autoCaptureSwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *requestTokenSwitcher;

@end

@implementation DigitViewController

- (void)dealloc {
    NSLog(@"back to ..");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showDigitTitle];
    
    [self initOrderView];
    
    [self addCurrencyGesture];
    [self addCountryGesture];
    
    [self addButtons];
}

- (void)addButtons {
    if (self.isPPCPPayPal) {
        _txtAmount.text = @"8";
     
        
        {
            UIButton *button = [CPayStyleManager buildPayPalButtonWithColor:@"blue" size:@"full" lable:nil];
            if (button) {
                [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:button];
                
                [NSLayoutConstraint activateConstraints:@[
                    [button.bottomAnchor constraintEqualToAnchor:self.confirmBtn.bottomAnchor constant:10],
                    [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
                ]];
            }
        }

        {
            UIButton *button = [CPayStyleManager buildPayPalButtonWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) edges:4 color:@"red" size:@"full" lable:@"checkout"];
            if (button) {
                [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:button];
                
                [NSLayoutConstraint activateConstraints:@[
                    [button.bottomAnchor constraintEqualToAnchor:self.confirmBtn.bottomAnchor constant:10 + 100],
                    [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
                ]];
            }
        }
    }
    
    if (self.isCashApp) {
        {
            UIView *button =
            [CPayStyleManager buildCashAppPaymentButtonWithSize:@"large" action:^{
                [self buttonTapped];
            }];
            
            if (button) {
                [self.view addSubview:button];
                
                [NSLayoutConstraint activateConstraints:@[
                    [button.bottomAnchor constraintEqualToAnchor:self.confirmBtn.bottomAnchor constant:10 + 100],
                    [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
                ]];
            }
            
        }
        
        {
            UIView *button =
            [CPayStyleManager buildCashAppPaymentMethodWithSize:@"large" cashTag:@"$USD" cashTagColor:[UIColor redColor] cashTagFont: [UIFont systemFontOfSize:10]];
            
            if (button) {
                [self.view addSubview:button];
                
                [NSLayoutConstraint activateConstraints:@[
                    [button.bottomAnchor constraintEqualToAnchor:self.confirmBtn.bottomAnchor constant:10 + 150],
                    [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
                ]];
                
            }
        }
        
    }
    
}

- (void)buttonTapped {
    [self onConfirm:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showDigitTitle {
    if (self.digitTitle && self.digitTitle.length > 0) {
        [self setNavTitle:self.digitTitle];
    }
}

- (void)setDigitTitle:(NSString *)title {
    _digitTitle = title;
}

- (void)setPaymentMethod:(NSString *)payment {
    _paymentMethod = payment;
}

#pragma mark - utils

- (void)initOrderView {
    _txtRefId.text = [NSString stringWithFormat:@"sdk_digit_%f", [[NSDate date] timeIntervalSince1970]];
    _txtAmount.text = @"1";
//    _txtTimeout.text = @"1670000000";
    NSTimeInterval timestmp = ceil([[NSDate date] timeIntervalSince1970]);
    _txtTimeout.text = [NSString stringWithFormat:@"%@", @(timestmp + 2 *3600)];
    
    _txtIPNUrl.text = @"https://ipn-receive.qa01.citconpay.com/notify";
    _txtSucUrl.text = @"com.citcon.citconpay://";
    _txtCancelUrl.text = @"com.citcon.citconpay://";
    _txtFailUrl.text = @"com.citcon.citconpay://";
    _txtNote.text = @"note";
    _txtCountry.text = @"US";
    _txtCurrency.text = @"USD";
}

- (CPayRequest *)createOrder {
    CPayRequest *order = CPayRequest.new;
    order.transaction.reference = _txtRefId.text;
    order.transaction.amount = @([_txtAmount.text intValue]);
    order.transaction.currency = _txtCurrency.text;
    order.transaction.country = (_txtCountry.text && _txtCountry.text.length > 0) ? _txtCountry.text : nil;
    order.transaction.note = _txtNote.text;
    order.transaction.autoCapture = _autoCaptureSwitcher.isOn;

    order.payment = CPayPayment.new;
    order.payment.method = _paymentMethod;
    order.payment.expiry = @([_txtTimeout.text intValue]);
    
    if (_paymentMethod) {
        if (([_paymentMethod caseInsensitiveCompare:@"paypal"] == NSOrderedSame
            || [_paymentMethod caseInsensitiveCompare:@"venmo"] == NSOrderedSame)
            || [_paymentMethod isEqualToString:@"grabpay"]
            || [_paymentMethod isEqualToString:@"shopeepay"]

            || [_paymentMethod isEqualToString:@"gcash"]
            || [_paymentMethod isEqualToString:@"paymaya"]

            
            || [_paymentMethod isEqualToString:@"billease"]
            || [_paymentMethod isEqualToString:@"cashalo"]
            
            
            ) {
            order.consumer = CPayConsumer.new;
            order.consumer.reference = @"1234567"; // Change to unique value to idenfier consumer
            
            if ([_paymentMethod isEqualToString:@"grabpay"]
                || [_paymentMethod isEqualToString:@"shopeepay"]
                
                
                || [_paymentMethod isEqualToString:@"gcash"]
                || [_paymentMethod isEqualToString:@"paymaya"]

                || [_paymentMethod isEqualToString:@"billease"]
                || [_paymentMethod isEqualToString:@"cashalo"]

                
                ) {
                order.consumer.phone = @"+8615167186161";
                order.consumer.lastName = @"zhang";
                order.consumer.firstName = @"san";
                
                order.consumer.city = @"Manila";
                order.consumer.email = @"test@123.com";
                order.consumer.street = @"Privada Germa";
                order.consumer.zip = @"1106";
                order.consumer.country = @"PH";
                
            }
            
            
            if ([_paymentMethod isEqualToString:@"billease"]
                || [_paymentMethod isEqualToString:@"cashalo"]
                ) {
                order.goods = CPayGoods.new;
                
                CPayProduct *good = CPayProduct.new;
                good.name = @"test";
                good.sku = @"abc";
                good.category = @"shop";
                good.totalAmount = @1000;
                good.unitAmount = @1000;
                good.quantity = @1;
                good.desc = @"test desc";
                good.productType = @"physical_service";
                good.url = @"https://www.huawei.com";
                
                order.goods.goods = @[good];
                
            }
            
        }
        
        if ([_paymentMethod isEqualToString:@"cashapppay"]) {
            order.scheme = @"com.citcon.citconpay";
            order.payment.requestToken = _requestTokenSwitcher.isOn;
            
            order.consumer = CPayConsumer.new;
            order.consumer.reference = @"1234567"; // Change to unique value to idenfier consumer
            

        }
        
    }
    
    
    
    if (_paymentMethod) {
        bool minimun = true;
        if (self.isPPCPPayPal) {
            
            if (minimun) {
                CPayProduct *good = CPayProduct.new;
                good.name = @"shoes";
                good.quantity = @1;
                good.unitAmount = @1;
                good.productType = @"physical";

                order.goods = CPayGoods.new;
                order.goods.goods = @[good];
                
                CPayShipping *shipping = CPayShipping.new;
                shipping.city = @"CA";
                shipping.zip = @"95134";
                shipping.country = @"US";
                order.goods.shipping = shipping;
            } else {
                order.transaction.vertical = @"Household goods, shoes, clothing, tickets";
                
                CPayBillingAddr *billingAddress = CPayBillingAddr.new;
                billingAddress.street = @"2425 Example Rd";
                billingAddress.street2 = @"";
                billingAddress.city = @"Columbus";
                billingAddress.state = @"OH";
                billingAddress.zip = @"43221";
                billingAddress.country = @"US";
                order.payment.billingAddress = billingAddress;
                
                CPayProduct *good = CPayProduct.new;
                good.name = @"shoes";
                good.sku = @"shoes";
                good.url = @"https://www.ttshop.com";
                good.quantity = @4;
                good.unitAmount = @1;
                good.unitTaxAmount = @1;
                good.totalDiscountAmount = @1;
                good.productType = @"physical";

                order.goods = CPayGoods.new;
                order.goods.goods = @[good];
                
                CPayShipping *shipping = CPayShipping.new;
                shipping.firstName = @"first";
                shipping.lastName = @"last";
                shipping.phone = @"1-888-254-4887";
                shipping.email = @"test@citcon.cn";
                shipping.street = @"3 Main St";
                shipping.street2 = @"";
                shipping.city = @"CA";
                shipping.state = @"San Jose";
                shipping.zip = @"95134";
                shipping.country = @"US";
                shipping.type = @"shipping";
                shipping.amount = @1;
                order.goods.shipping = shipping;

                order.consumer = CPayConsumer.new;
                order.consumer.reference = @"citcon-001";
                order.consumer.firstName = @"first";
                order.consumer.lastName = @"last";
                order.consumer.phone = @"+8615167186161";
                order.consumer.email = @"test@citcon.cn";
                order.consumer.registrationTime = @1663311480;
                order.consumer.firstInteractionTime = @1663312480;
                order.consumer.registrationIp = @"23.12.32.21";
                order.consumer.riskLevel = @"medium";
                order.consumer.totalTransactionCount = @1;

                order.urls.mobile = _txtSucUrl.text;
            }
            
        }
    }
    
    
    order.urls.ipn = _txtIPNUrl.text;
    order.urls.success = _txtSucUrl.text;
    order.urls.cancel = _txtCancelUrl.text;
    order.urls.fail = _txtFailUrl.text;

    // temporary fix xendit
    
    if ([self.digitTitle isEqualToString:@"Xendit"]) {
        order.urls.success = @"https://www.baidu.com";
        order.urls.cancel = @"https://www.baidu.com";
        order.urls.fail = @"https://www.baidu.com";
    }
    

    
    order.controller = self;
    
    if (self.isPPCPPayPal) {
//        order.paypalClientId = @"Aevy5i-20TVIB6j6KyjbWoUuqopBtx0UKg8L6xlbHv3_ZP3ddoVXkAXSooCsg7HUWDOJgt4oJmh8l2Yg";
    }

    
    
    return order;
}

- (BOOL) isPPCPPayPal {
    return [_paymentMethod isEqualToString:@"paypal"] && _digitTitle && [_digitTitle isEqualToString:@"PPCP PayPal"];
}



- (BOOL) isCashApp {
    return [_paymentMethod isEqualToString:@"cashapppay"] ;
}
- (void)addCurrencyGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCurrencySelect)];
    [_txtCurrency addGestureRecognizer:tap];
}

- (void)addCountryGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCountrySelect)];
    [_txtCountry addGestureRecognizer:tap];
}

#pragma mark - Gesture Event

- (void)onCurrencySelect {
    self.currentTextField = _txtCurrency;
    self.pickerData = [[AppDefines sharedInst] getCurrencies];
    [self showPicker];
}

- (void)onCountrySelect {
    self.currentTextField = _txtCountry;
    self.pickerData = [[AppDefines sharedInst] getCountries];
    [self showPicker];
}

- (IBAction)onRequest:(id)sender {
    [self requestCharge:[self createOrder] onComplete:^(NSString * _Nullable chargeToken) {
        self.txtTxnId.text = chargeToken;
    }];
}

- (IBAction)onConfirm:(id)sender {
    if (_txtTxnId.text == nil || _txtTxnId.text.length < 1) {
        [self showAlert:@"Error" andMessage:@"You should first request charge"];
        return;
    }
    
    CPayRequest *order = [self createOrder];
    order.chargeToken = [_txtTxnId.text copy];
    
    _txtTxnId.text = nil;
    [self confirmCharge:order];
}

@end
