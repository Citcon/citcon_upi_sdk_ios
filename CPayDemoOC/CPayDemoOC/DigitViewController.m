//
//  DigitViewController.m
//  CPayDemoOC
//
//  Created by long.zhao on 3/13/22.
//

#import "DigitViewController.h"
#import "AppDefines.h"

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

@end

@implementation DigitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showDigitTitle];
    
    [self initOrderView];
    
    [self addCurrencyGesture];
    [self addCountryGesture];
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
    _txtTimeout.text = @"60000";
    _txtIPNUrl.text = @"https://ipn.com";
    _txtSucUrl.text = @"com.citcon.citconpay://";
    _txtCancelUrl.text = @"com.citcon.citconpay://";
    _txtFailUrl.text = @"com.citcon.citconpay://";
    _txtNote.text = @"note";
    _txtCountry.text = @"US";
    _txtCurrency.text = @"USD";
}

- (CPayRequest *)createOrder {
    CPayRequest *order = [CPayRequest new];
    order.transaction.reference = _txtRefId.text;
    order.transaction.amount = [_txtAmount.text intValue];
    order.transaction.currency = _txtCurrency.text;
    order.transaction.country = _txtCountry.text;
    order.transaction.note = _txtNote.text;
    
    order.payment = [CPayPayment new];
    order.payment.method = _paymentMethod;
    
    if (_paymentMethod && ([_paymentMethod caseInsensitiveCompare:@"paypal"] == NSOrderedSame ||
                           [_paymentMethod caseInsensitiveCompare:@"venmo"] == NSOrderedSame)) {
        order.consumer = [CPayConsumer new];
        order.consumer.reference = @"123"; // Change to unique value to idenfier consumer
    }
    
    order.urls.ipn = _txtIPNUrl.text;
    order.urls.success = _txtSucUrl.text;
    order.urls.cancel = _txtCancelUrl.text;
    order.urls.fail = _txtFailUrl.text;
    
    order.controller = self;
    
    return order;
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
