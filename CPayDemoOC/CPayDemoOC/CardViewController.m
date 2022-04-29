//
//  BraintreeViewController.m
//  CPayDemoOC
//
//  Created by long.zhao on 3/3/22.
//

#import "CardViewController.h"
#import "AppDefines.h"

@interface CardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtRefId;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrency;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeout;
@property (weak, nonatomic) IBOutlet UITextField *txtIPNUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtSucUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtCancelUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtFailUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;

// 3DS
@property (weak, nonatomic) IBOutlet UITextField *txtGiveName;
@property (weak, nonatomic) IBOutlet UITextField *txtSurName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtStreetAddr;
@property (weak, nonatomic) IBOutlet UITextField *txtExtedAddr;
@property (weak, nonatomic) IBOutlet UITextField *txtLocality;
@property (weak, nonatomic) IBOutlet UITextField *txtRegion;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtCountryCodeAlpha;
@property (weak, nonatomic) IBOutlet UISwitch *swEnable3DS;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"Card"];
    
    [self initOrderView];
    [self init3DS];
    
    _swEnable3DS.on = NO;
    [self enable3DS:NO];
    
    [self addCurrencyGesture];
    [self addCountryGesture];
}

#pragma mark - Utils

- (void)initOrderView {
    _txtRefId.text = [NSString stringWithFormat:@"sdk_card_%f", [[NSDate date] timeIntervalSince1970]];
    _txtAmount.text = @"1";
    _txtTimeout.text = @"60000";
    _txtIPNUrl.text = @"https://ipn.com";
    _txtSucUrl.text = @"https://success.com";
    _txtCancelUrl.text = @"https://cancel.com";
    _txtFailUrl.text = @"https://fail.com";
    _txtNote.text = @"note";
    _txtCurrency.text = @"USD";
    _txtCountry.text = @"US";
}

- (void)init3DS {
    _txtGiveName.text = @"Jill";
    _txtSurName.text = @"Doe";
    _txtEmail.text = @"test@email.com";
    _txtPhoneNumber.text = @"5551234567";
    _txtStreetAddr.text = @"555 Smith St";
    _txtExtedAddr.text = @"#2";
    _txtLocality.text = @"Chicago";
    _txtRegion.text = @"IL";
    _txtZip.text = @"12345";
    _txtCountryCodeAlpha.text = @"US";
}

- (void)enable3DS:(BOOL)enable {
    _txtGiveName.enabled = enable;
    _txtSurName.enabled = enable;
    _txtEmail.enabled = enable;
    _txtPhoneNumber.enabled = enable;
    _txtStreetAddr.enabled = enable;
    _txtLocality.enabled = enable;
    _txtRegion.enabled = enable;
    _txtZip.enabled = enable;
    _txtExtedAddr.enabled = enable;
    _txtCountryCodeAlpha.enabled = enable;
}

- (CPayRequest *)createOrder {
    CPayRequest *order = [CPayRequest new];
    order.transaction.reference = _txtRefId.text;
    order.transaction.amount = [_txtAmount.text intValue];
    order.transaction.currency = _txtCurrency.text;
    order.transaction.country = _txtCountry.text;
    order.transaction.note = _txtNote.text;
    
    order.payment = [CPayPayment new];
    order.payment.method = @"card";
    
    order.consumer = [CPayConsumer new];
    order.consumer.reference = @"123"; // Change to unique value to idenfier consumer
    
    order.urls.ipn = _txtIPNUrl.text;
    order.urls.success = _txtSucUrl.text;
    order.urls.cancel = _txtCancelUrl.text;
    order.urls.fail = _txtFailUrl.text;
    
    order.controller = self;
    
    // If 3DS
    order.request3DSecureVerification = _swEnable3DS.isOn;
    if (order.request3DSecureVerification) {
        order.consumer.email = _txtEmail.text;
        order.consumer.phone = _txtPhoneNumber.text;
        order.consumer.firstName = _txtGiveName.text;
        order.consumer.lastName = _txtSurName.text;
        
        order.consumer.billingAddress = [CPayBillingAddr new];
        order.consumer.billingAddress.street = _txtStreetAddr.text;
        order.consumer.billingAddress.street2 = _txtExtedAddr.text;
        order.consumer.billingAddress.state = _txtRegion.text;
        order.consumer.billingAddress.city = _txtLocality.text;
        order.consumer.billingAddress.country = _txtCountryCodeAlpha.text;
        order.consumer.billingAddress.zip = _txtZip.text;
    }
    
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

#pragma mark - UI event

- (IBAction)onEnable3DS:(id)sender {
    UISwitch *s = (UISwitch*)sender;
    [self enable3DS:s.on];
}

- (IBAction)onConfirm:(id)sender {
    [self confirmCharge:[self createOrder]];
}

@end
