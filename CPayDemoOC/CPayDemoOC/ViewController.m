//
//  ViewController.m
//  CPayDemoOC
//
//  Created by long.zhao on 2/7/22.
//

#import "ViewController.h"
#import "AppDefines.h"
#import "WechatPayViewController.h"
#import "LoadingView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UITextField *txtRTEnv;
@property (weak, nonatomic) IBOutlet UITextField *txtVendorType;
@property (weak, nonatomic) IBOutlet UITextField *txtPaymethod;
@property (weak, nonatomic) IBOutlet UITextField *txtTxnId;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UIButton *btnAccessToken;

@property (nonatomic, retain) NSString *accessToken;

@end

@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lblVersion.text = [[CPayManager sharedInst] getVersion];
    _accessToken = nil;
    
    [self addPaymentGesture];
    [self addRTEnvGesture];
//    [self addVendorGesture];
    
    [self initEnvForm];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPaymentCompleted:)
                                                 name:[AppDefines sharedInst].ns_pay_completed
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAsyncResult:) name:[CPayRuntimeInst NTFY_ASYNC] object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initEnvForm {
    _txtRTEnv.text = @"QA";
    _txtPaymethod.text = @"wechatpay";
    _txtVendorType.text = @"sk-development-6531a79240d135e77c7a0affdf585bca";
}

- (void)setAccessToken {
    if (_txtVendorType.text == nil || _txtVendorType.text.length < 1) {
        [self showAlert:@"Error" andMessage:@"Please set payment method at first"];
        return;
    }
    
    [LoadingView show:self];
    [[AppDefines sharedInst] getAccessToken:_txtVendorType.text callback:^(NSString * _Nullable token) {
        [LoadingView dismiss];
        
        if (token == nil || token.length < 1) {
            [self showAlert:@"Error" andMessage:@"Set access-token failed"];
            return;
        }
        
        self.accessToken = token;
        if ([[CPayManager sharedInst] setAccessToken:token]) {
            [self showAlert:@"Citcon" andMessage:@"setAccessToken successful."];
        } else {
            [self showAlert:@"Citcon" andMessage:@"setAccessToken failed."];
        }
    }];
//    NSString *accessToken = @"UPI_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoia2ZjX3VwaV91c2QiLCJpYXQiOjE2NDY5MDQ0MzUsImV4cCI6MTY0ODYzNzc0MDM1NH0.3llU-in-PGEdxIyWPx9HkHbSso10mGu0CakqNSuLudM";
//    if ([[CPayManager sharedInst] setAccessToken:accessToken]) {
//        NSLog(@"CPayManager setAccessToken successful.");
//    } else {
//        NSLog(@"CPayManager setAccessToken failed");
//    }
}

- (void)reset {
    _txtTxnId.text = @"";
}

- (void)addPaymentGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPaymentSelect)];
    [_txtPaymethod addGestureRecognizer:tap];
}

- (void)addRTEnvGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRTEnvSelect)];
    [_txtRTEnv addGestureRecognizer:tap];
}

- (void)addVendorGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onVendorSelect)];
    [_txtVendorType addGestureRecognizer:tap];
}

# pragma mark - notification

- (void)onPaymentCompleted:(NSNotification *)notification {
    [self clearResult];
    [self showAccessToken];
    
    CPayResult *resp = [notification object];
    
    [self showOrderResult:resp];
}

- (void)onAsyncResult:(NSNotification *)notification {
    CPayCheck *resp = [notification object];
    
    [self showCheckResult:resp header:@"OrderNotification =============== \n"];
}

#pragma mark - utils

- (BOOL)alreadyAccessToken {
    if (self.accessToken && self.accessToken.length > 0) {
        return YES;
    }
    
    [self showAlert:@"Error" andMessage:@"You should get access token at first"];
    return NO;
}

- (void)clearResult {
    _lblResult.text = @"";
}

- (void)showAccessToken {
    _lblResult.text = self.accessToken ? [NSString stringWithFormat:@"%@\n\n\n", self.accessToken] : @"nil";
}

- (void)showOrderResult:(CPayResult *)resp {
    NSMutableString *ret = [NSMutableString string];
    if (_lblResult.text && _lblResult.text.length > 0) {
        [ret appendFormat:@"%@\n\n\n", _lblResult.text];
    }
    
    [ret appendFormat:@"OrderResult =============== \n"];
    [ret appendFormat:@"Result status:(%@) code:(%@) message:(%@)\n", resp.status, resp.data.code, resp.data.message];
    [ret appendFormat:@"Txn Id: %@\n", resp.data.id];
    [ret appendFormat:@"Ref Id: %@\n", resp.data.reference];
    [ret appendFormat:@"Amount: %ld\n", resp.data.amount];
    [ret appendFormat:@"Currency: %@\n", resp.data.currency];
    [ret appendFormat:@"Payment Method: %@\n", resp.data.payment.method];
    [ret appendFormat:@"Auto Capture: %@\n", resp.data.autoCapture ? @"true" : @"false"];
    [ret appendFormat:@"Txn status: %@\n", resp.data.status];
    [ret appendFormat:@"Time Created: %ld\n", (long)resp.data.timeCreated];
    [ret appendFormat:@"ChargeToken: %@\n", resp.data.chargeToken];
    
    _lblResult.text = ret;
    
    if (resp.data.id != nil) {
        _txtTxnId.text = resp.data.id;
    }
}

- (void)showCheckResult:(CPayCheck *)resp header:(NSString *)header {
    NSMutableString *ret = [NSMutableString string];
    if (_lblResult.text && _lblResult.text.length > 0) {
        [ret appendFormat:@"%@\n\n\n", _lblResult.text];
    }
    
    if (header && header.length > 0) {
        [ret appendFormat:@"%@", header];
    }
    
    [ret appendFormat:@"status(%@) code(%@) message(%@)\n", resp.status, resp.data.code, resp.data.message];
    if ([resp.status isEqualToString:@"success"]) {
        [ret appendFormat:@"id: %@\n", resp.data.id];
        [ret appendFormat:@"object: %@\n", resp.data.object];
        [ret appendFormat:@"amount: %ld\n", (long)resp.data.amount];
        [ret appendFormat:@"currency: %@\n", resp.data.currency];
        [ret appendFormat:@"Txn status: %@\n", resp.data.status];
        [ret appendFormat:@"timeCanceled: %ld\n", (long)resp.data.timeCanceled];
        [ret appendFormat:@"expiry: %@\n", resp.data.expiry];
        [ret appendFormat:@"timeCreated: %ld\n", (long)resp.data.timeCreated];
        [ret appendFormat:@"country: %@\n", resp.data.country];
        [ret appendFormat:@"reference: %@\n", resp.data.reference];
        [ret appendFormat:@"amountCaptured: %ld\n", (long)resp.data.amountCaptured];
        [ret appendFormat:@"amountRefunded: %ld\n", (long)resp.data.amountRefunded];
        [ret appendFormat:@"paymentMethod: %@\n", resp.data.payment.method];
    }
    
    _lblResult.text = ret;
}

- (void)showAlert:(NSString *)title andMessage:(NSString *)msg {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [vc addAction:confirm];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)presentPaymentView:(NSString *)resIdentifier {
    [self presentPaymentView:resIdentifier payment:nil title:nil];
}

- (void)presentPaymentView:(NSString *)resIdentifier payment:(NSString *)payment title:(NSString *)title {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainBoard instantiateViewControllerWithIdentifier:resIdentifier];
    
    if (!vc) {
        [self showAlert:@"Error" andMessage:@"Create view failed"];
        return;
    }
    
    if (payment && payment.length > 0) {
        SEL sel = NSSelectorFromString(@"setPaymentMethod:");
        IMP imp = [vc methodForSelector:sel];
        void (*func)(id, SEL, NSString *) = (void *)imp;
        func(vc, sel, payment);
//        if ([vc respondsToSelector:sel]) {
//            [vc performSelector:sel withObject:payment];
//        }
    }
    if (title && title.length > 0) {
        SEL sel = NSSelectorFromString(@"setDigitTitle:");
        IMP imp = [vc methodForSelector:sel];
        void (*func)(id, SEL, NSString *) = (void *)imp;
        func(vc, sel, title);
//        if ([vc respondsToSelector:sel]) {
//            [vc performSelector:sel withObject:title];
//        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentPaymentView {
    NSString *payment = _txtPaymethod.text;
    if ([payment isEqualToString:@"upop"]) {
        [self presentPaymentView:@"upop"];
    } else if ([payment isEqualToString:@"wechatpay"]) {
        [self presentPaymentView:@"wechatpay"];
    } else if ([payment isEqualToString:@"alipay"]) {
        [self presentPaymentView:@"alipay"];
    } else if ([payment isEqualToString:@"paypal"]) {
        [self presentPaymentView:@"digit" payment:payment title:@"PayPal"];
    } else if ([payment isEqualToString:@"venmo"]) {
        [self presentPaymentView:@"digit" payment:payment title:@"Venmo"];
    } else if ([payment isEqualToString:@"card"]) {
        [self presentPaymentView:@"card"];
    } else {
        [self showAlert:@"Error" andMessage:@"Unsupport Payment"];
    }
}

- (BOOL)setRTEnv {
    NSString *rtenv = _txtRTEnv.text;
    if (rtenv == nil || rtenv.length < 1) {
        [self showAlert:@"Error" andMessage:@"Please set Runtime Environment at first."];
        return NO;
    }
    
    if ([rtenv isEqualToString:@"DEV"]) {
        return [[CPayManager sharedInst] setMode:CPayENVModeDEV];
    } else if ([rtenv isEqualToString:@"QA"]) {
        return [[CPayManager sharedInst] setMode:CPayENVModeQA];
    } else if ([rtenv isEqualToString:@"UAT"]) {
        return [[CPayManager sharedInst] setMode:CPayENVModeUAT];
    } else {
        return [[CPayManager sharedInst] setMode:CPayENVModePROD];
    }
    return NO;
}

#pragma mark - picker event

- (void)onPaymentSelect {
    self.currentTextField = _txtPaymethod;
    self.pickerData = [[AppDefines sharedInst] getPayments];
    [self showPicker];
}

- (void)onRTEnvSelect {
    self.currentTextField = _txtRTEnv;
    self.pickerData = @[
        @"DEV",
        @"QA",
        @"UAT",
        @"PROD"
    ];
    [self showPicker];
}

- (void)onVendorSelect {
    self.currentTextField = _txtVendorType;
    self.pickerData = [[AppDefines sharedInst] getVendors];
    [self showPicker];
}

#pragma mark - UI event

- (IBAction)onAccessToken:(id)sender {
    if ([self setRTEnv]) {
        [self setAccessToken];
    }
}

- (IBAction)requestCharge:(id)sender {
    if ([self setRTEnv] && [self alreadyAccessToken]) {
        [self reset];
        [self presentPaymentView];
    }
}

- (IBAction)inquireOrder:(id)sender {
    NSString *txnId = _txtTxnId.text;
    if (txnId == nil || txnId.length < 1) {
        [self showAlert:@"Error" andMessage:@"Transaction Id can not be empty."];
        return;
    }
    
    if (![self setRTEnv] && ![self alreadyAccessToken]) {
        return;
    }
    
    [self clearResult];
    [self showAccessToken];
    
    [LoadingView show: self];
    [[CPayManager sharedInst] inquireOrder:txnId callback:^(CPayCheck * _Nullable resp) {
        [LoadingView dismiss];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showCheckResult:resp header:@"OrderCheck =============== \n"];
        });
    }];
}

@end
