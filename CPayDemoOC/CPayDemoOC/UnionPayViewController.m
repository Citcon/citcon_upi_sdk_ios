//
//  UPOPViewController.m
//  CPayDemoOC
//
//  Created by long.zhao on 3/2/22.
//

#import "UnionPayViewController.h"
#import "AppDefines.h"

@interface UnionPayViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtRefId;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrency;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeout;
@property (weak, nonatomic) IBOutlet UITextField *txtIPNUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtSucUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtCancelUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtFailUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtScheme;
@property (weak, nonatomic) IBOutlet UITextField *txtUnionPayMode;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (weak, nonatomic) IBOutlet UITextField *txtTxnId;

@end

@implementation UnionPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"UnionPay"];
    
    [self initOrderView];
    
    [self addCurrencyGesture];
    [self addCountryGesture];
    [self addUnionPayModeGesture];
}

#pragma mark - utils

- (void)initOrderView {
    _txtRefId.text = [NSString stringWithFormat:@"sdk_upop_%f", [[NSDate date] timeIntervalSince1970]];
    _txtAmount.text = @"1";
    _txtTimeout.text = @"60000";
    _txtIPNUrl.text = @"https://ipn.com";
    _txtSucUrl.text = @"https://success.com";
    _txtCancelUrl.text = @"https://cancel.com";
    _txtFailUrl.text = @"https://fail.com";
    _txtScheme.text = @"com.citcon.citconpay";
    _txtNote.text = @"note";
    _txtCountry.text = @"US";
    _txtCurrency.text = @"USD";
    _txtUnionPayMode.text = @"00";
}

- (void)addCurrencyGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCurrencySelect)];
    [_txtCurrency addGestureRecognizer:tap];
}

- (void)addCountryGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCountrySelect)];
    [_txtCountry addGestureRecognizer:tap];
}

- (void)addUnionPayModeGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUnionPayModeSelect)];
    [_txtUnionPayMode addGestureRecognizer:tap];
}

- (CPayRequest *)createOrder {
    CPayRequest *order = [CPayRequest new];
    order.transaction.reference = _txtRefId.text;
    order.transaction.amount = [_txtAmount.text intValue];
    order.transaction.currency = _txtCurrency.text;
    order.transaction.country = _txtCountry.text;
    order.transaction.note = _txtNote.text;
    
    order.payment = [CPayPayment new];
    order.payment.method = @"upop";
    
    order.urls.ipn = _txtIPNUrl.text;
    order.urls.success = _txtSucUrl.text;
    order.urls.cancel = _txtCancelUrl.text;
    order.urls.fail = _txtFailUrl.text;
    
    order.scheme = _txtScheme.text;
    order.unionpayMode = _txtUnionPayMode.text;
    order.controller = self;
    
    return order;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void)onUnionPayModeSelect {
    self.currentTextField = _txtUnionPayMode;
    self.pickerData = @[@"00", @"01"];
    [self showPicker];
}

#pragma mark - UI event

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
