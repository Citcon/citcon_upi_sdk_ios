//
//  AlipayViewController.m
//  CPayDemoOC
//
//  Created by long.zhao on 3/2/22.
//

#import "AlipayViewController.h"
#import "AppDefines.h"

@interface AlipayViewController ()
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
@property (weak, nonatomic) IBOutlet UITextField *txtNote;

@end

@implementation AlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"Alipay"];
    
    [self initOrderView];
    
    [self addCurrencyGesture];
    [self addCountryGesture];
}

#pragma mark - utils

- (void)initOrderView {
    _txtRefId.text = [NSString stringWithFormat:@"sdk_alipay_%f", [[NSDate date] timeIntervalSince1970]];
    _txtAmount.text = @"1";
    _txtTimeout.text = @"60000";
    _txtIPNUrl.text = @"https://ipn.com";
    _txtSucUrl.text = @"https://success.com";
    _txtCancelUrl.text = @"https://cancel.com";
    _txtFailUrl.text = @"https://fail.com";
    _txtScheme.text = @"com.citcon.citconpay";
    _txtNote.text = @"note";
    _txtCurrency.text = @"USD";
    _txtCountry.text = @"US";
}

- (void)addCurrencyGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCurrencySelect)];
    [_txtCurrency addGestureRecognizer:tap];
}

- (void)addCountryGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCountrySelect)];
    [_txtCountry addGestureRecognizer:tap];
}

- (CPayRequest *)createOrder {
    CPayRequest *order = [CPayRequest new];
    order.transaction.reference = _txtRefId.text;
    order.transaction.amount = [_txtAmount.text intValue];
    order.transaction.currency = _txtCurrency.text;
    order.transaction.country = _txtCountry.text;
    order.transaction.note = _txtNote.text;
    
    order.payment = [CPayPayment new];
    order.payment.method = @"alipay";
    
    order.urls.ipn = _txtIPNUrl.text;
    order.urls.success = _txtSucUrl.text;
    order.urls.cancel = _txtCancelUrl.text;
    order.urls.fail = _txtFailUrl.text;
    
    order.scheme = _txtScheme.text;
    
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

#pragma mark - UI event

- (IBAction)onConfirm:(id)sender {
    [self confirmCharge:[self createOrder]];
}

@end
