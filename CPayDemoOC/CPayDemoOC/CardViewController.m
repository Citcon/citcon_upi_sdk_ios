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
@property (weak, nonatomic) IBOutlet UITextField *txtCardFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtCardNo;
@property (weak, nonatomic) IBOutlet UITextField *txtCardLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtCvv;
@property (weak, nonatomic) IBOutlet UITextField *txtCardExpiry;
@property (weak, nonatomic) IBOutlet UITextField *txtPaymentFormat;

@property (weak, nonatomic) IBOutlet UISwitch *swEnableInstaments;
@property (weak, nonatomic) IBOutlet UITextField *txtInstallmentsId;
@property (weak, nonatomic) IBOutlet UITextField *txtInstallmentsQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtInstallmentsPaymentNumber;
@property (weak, nonatomic) IBOutlet UISwitch *autoCaptureSwitcher;


@property (nonatomic, copy) NSString *paymentMethod;
@property (nonatomic, copy) NSString *digitTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtTxnId;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:_digitTitle];
    
    [self initOrderView];
    [self init3DS];
    [self initCardInfo];
    
    _swEnable3DS.on = NO;
    [self enable3DS:NO];
    
    _swEnableInstaments.on = NO;
    
    [self addCurrencyGesture];
    [self addCountryGesture];
}

#pragma mark - Utils

- (void)initOrderView {
    _txtRefId.text = [NSString stringWithFormat:@"sdk_card_%f", [[NSDate date] timeIntervalSince1970]];
    _txtAmount.text = @"1";
//    _txtTimeout.text = @"1670000000";
    NSTimeInterval timestmp = ceil([[NSDate date] timeIntervalSince1970]);
    _txtTimeout.text = [NSString stringWithFormat:@"%@", @(timestmp + 2 *3600)];

    _txtIPNUrl.text = @"https://ipn-receive.qa01.citconpay.com/notify";
//    _txtSucUrl.text = @"com.citcon.citconpay://";
//    _txtCancelUrl.text = @"com.citcon.citconpay://";
//    _txtFailUrl.text = @"com.citcon.citconpay://";
    _txtSucUrl.text = @"https://success";
    _txtCancelUrl.text = @"https://cancel";
    _txtFailUrl.text = @"https://fail";
    _txtNote.text = @"note";
    _txtCurrency.text = @"PHP";
    _txtCountry.text = @"PH";
}

- (void)init3DS {
    _txtGiveName.text = @"Jill";
    _txtSurName.text = @"Doe";
    _txtEmail.text = @"sun.xiufang@citcon.cn";
    _txtPhoneNumber.text = @"5551234567";
    _txtStreetAddr.text = @"555 Smith St";
    _txtExtedAddr.text = @"#2";
    _txtLocality.text = @"Chicago";
    _txtRegion.text = @"IL";
    _txtZip.text = @"333000";
    _txtCountryCodeAlpha.text = @"PH";
}

- (void)initCardInfo {
    _txtPaymentFormat.text = @"redirect";
    _txtCardNo.text = @"4000000000000002";
    _txtCvv.text = @"123";
    _txtCardExpiry.text = @"12/25";
    _txtCardFirstName.text = @"mike";
    _txtCardLastName.text = @"bay";
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

- (NSString *)getTextValue: (UITextField *)field {
    if (field.text && field.text.length > 0) {
        return field.text;
    }
    return nil;
}

- (CPayRequest *)createOrder {
    CPayRequest *order = [CPayRequest new];
    order.transaction.reference = _txtRefId.text;
    order.transaction.amount = @([_txtAmount.text intValue]);
    order.transaction.currency = _txtCurrency.text;
    order.transaction.country = _txtCountry.text;
    order.transaction.note = _txtNote.text;
    order.transaction.autoCapture = _autoCaptureSwitcher.isOn;

    order.payment = [CPayPayment new];
    order.payment.method = _paymentMethod;
    order.payment.expiry = @([_txtTimeout.text intValue]);
    
    // card information [used in "fomo"]
    order.payment.data = [CPayPaymentData new];
    order.payment.data.firstName = [self getTextValue:_txtCardFirstName];
    order.payment.data.lastName = [self getTextValue:_txtCardLastName];
    order.payment.data.cvv = [self getTextValue:_txtCvv];
    order.payment.data.pan = [self getTextValue:_txtCardNo];
    order.payment.data.expiry = [self getTextValue:_txtCardExpiry];
    order.payment.format = [self getTextValue:_txtPaymentFormat];
    
    order.consumer = [CPayConsumer new];
    order.consumer.reference = @"88888"; // Change to unique value to idenfier consumer
    
    order.urls.ipn = _txtIPNUrl.text;
    order.urls.success = _txtSucUrl.text;
    order.urls.cancel = _txtCancelUrl.text;
    order.urls.fail = _txtFailUrl.text;
    
    order.controller = self;
    
    // If 3DS
    order.request3DSecureVerification = _swEnable3DS.isOn;
//      if (order.request3DSecureVerification) {
        order.consumer.email = _txtEmail.text;
        order.consumer.phone = _txtPhoneNumber.text;
        order.consumer.firstName = _txtGiveName.text;
        order.consumer.lastName = _txtSurName.text;
        
        order.payment.billingAddress = [CPayBillingAddr new];
        order.payment.billingAddress.street = _txtStreetAddr.text;
        order.payment.billingAddress.street2 = _txtExtedAddr.text;
        order.payment.billingAddress.state = _txtRegion.text;
        order.payment.billingAddress.city = _txtLocality.text;
        order.payment.billingAddress.country = _txtCountryCodeAlpha.text;
        order.payment.billingAddress.zip = _txtZip.text;
//    }
    
    // If Instaments
    if (_swEnableInstaments.isOn) {
        order.installments = [CPayInstallments new];
        order.installments.id = _txtInstallmentsId.text;
        order.installments.quantity = _txtInstallmentsQuantity.text.intValue;
        order.installments.paymentNumber = _txtInstallmentsPaymentNumber.text.floatValue;
    }
    
//    order.payment.format = @"json";
    
    order.ext = [CPayExt new];
    order.ext.transaction = [CPayExtTransaction new];
    order.ext.transaction.receipt = [CPayExtTransactionReceipt new];
    // the value of this field should be one of the following three values
    // income_deduction, expense_proof, not_issued
    order.ext.transaction.receipt.type = @"income_deduction";
    
    // Used in fomo pay
    order.ext.device = [CPayExtDevice new];
    order.ext.device.ip = @"122.235.240.87";
    
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

- (void)setDigitTitle:(NSString *)title {
    _digitTitle = title;
}

- (void)setPaymentMethod:(NSString *)payment {
    _paymentMethod = payment;
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

#pragma mark - UI event

- (IBAction)onEnable3DS:(id)sender {
    UISwitch *s = (UISwitch*)sender;
    [self enable3DS:s.on];
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
