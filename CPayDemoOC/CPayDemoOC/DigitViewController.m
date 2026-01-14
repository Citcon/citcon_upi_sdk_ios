//
//  DigitViewController.m
//  CPayDemoOC
//
//  Created by long.zhao on 3/13/22.
//

#import "DigitViewController.h"
#import "AppDefines.h"
// #import <CPaySDK/CPaySDK.h>
#import <CPaySDK/CPaySDK-Swift.h>

@interface DigitViewController ()
@property(weak, nonatomic) IBOutlet UITextField *txtRefId;
@property(weak, nonatomic) IBOutlet UITextField *txtCurrency;
@property(weak, nonatomic) IBOutlet UITextField *txtCountry;
@property(nonatomic, strong) UIView *klarnaOSMView;
@property(nonatomic, strong) NSLayoutConstraint *klarnaOSMHeightConstraint;
@property(weak, nonatomic) IBOutlet UITextField *txtAmount;
@property(weak, nonatomic) IBOutlet UITextField *txtTimeout;
@property(weak, nonatomic) IBOutlet UITextField *txtSucUrl;
@property(weak, nonatomic) IBOutlet UITextField *txtIPNUrl;
@property(weak, nonatomic) IBOutlet UITextField *txtCancelUrl;
@property(weak, nonatomic) IBOutlet UITextField *txtFailUrl;
@property(weak, nonatomic) IBOutlet UITextField *txtNote;

@property(nonatomic, copy) NSString *paymentMethod;
@property(nonatomic, copy) NSString *digitTitle;
@property(weak, nonatomic) IBOutlet UITextField *txtTxnId;
@property(weak, nonatomic) IBOutlet UISwitch *autoCaptureSwitcher;
@property(weak, nonatomic) IBOutlet UISwitch *requestTokenSwitcher;

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
      UIButton *button = [CPayStyleManager buildPayPalButtonWithColor:@"blue"
                                                                 size:@"full"
                                                                lable:nil];
      if (button) {
        [button addTarget:self
                      action:@selector(buttonTapped)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

        [NSLayoutConstraint activateConstraints:@[
          [button.bottomAnchor
              constraintEqualToAnchor:self.confirmBtn.bottomAnchor
                             constant:10],
          [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
        ]];
      }
    }

    {
      UIButton *button = [CPayStyleManager
          buildPayPalButtonWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                edges:4
                                color:@"red"
                                 size:@"full"
                                lable:@"checkout"];
      if (button) {
        [button addTarget:self
                      action:@selector(buttonTapped)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

        [NSLayoutConstraint activateConstraints:@[
          [button.bottomAnchor
              constraintEqualToAnchor:self.confirmBtn.bottomAnchor
                             constant:10 + 100],
          [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
        ]];
      }
    }
  }

  if (self.isCashApp) {
    {
      UIView *button =
          [CPayStyleManager buildCashAppPaymentButtonWithSize:@"large"
                                                       action:^{
                                                         [self buttonTapped];
                                                       }];

      if (button) {
        [self.view addSubview:button];

        [NSLayoutConstraint activateConstraints:@[
          [button.bottomAnchor
              constraintEqualToAnchor:self.confirmBtn.bottomAnchor
                             constant:10 + 100],
          [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
        ]];
      }
    }

    {
      UIView *button = [CPayStyleManager
          buildCashAppPaymentMethodWithSize:@"large"
                                    cashTag:@"$USD"
                               cashTagColor:[UIColor redColor]
                                cashTagFont:[UIFont systemFontOfSize:10]];

      if (button) {
        [self.view addSubview:button];

        [NSLayoutConstraint activateConstraints:@[
          [button.bottomAnchor
              constraintEqualToAnchor:self.confirmBtn.bottomAnchor
                             constant:10 + 150],
          [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
        ]];
      }
    }
  }

  if (self.isKlarna) {
    // Add Klarna OSM view
    [self addKlarnaOSMView];

    // add Klarna button
    UIButton *klarnaButton = [UIButton buttonWithType:UIButtonTypeSystem];
    klarnaButton.translatesAutoresizingMaskIntoConstraints = NO;
    [klarnaButton setTitle:@"Pay with Klarna" forState:UIControlStateNormal];
    klarnaButton.backgroundColor = [UIColor colorWithRed:255 / 255.0
                                                   green:179 / 255.0
                                                    blue:199 / 255.0
                                                   alpha:1.0]; // Klarna Pink
    [klarnaButton setTitleColor:[UIColor blackColor]
                       forState:UIControlStateNormal];
    klarnaButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    klarnaButton.layer.cornerRadius = 8;
    [klarnaButton addTarget:self
                     action:@selector(buttonTapped)
           forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:klarnaButton];

    [NSLayoutConstraint activateConstraints:@[
      [klarnaButton.bottomAnchor
          constraintEqualToAnchor:self.confirmBtn.bottomAnchor
                         constant:10 + 100],
      [klarnaButton.centerXAnchor
          constraintEqualToAnchor:self.view.centerXAnchor],
      [klarnaButton.widthAnchor constraintEqualToConstant:280],
      [klarnaButton.heightAnchor constraintEqualToConstant:50]
    ]];
  }
}

- (void)buttonTapped {
  [self onConfirm:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
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
  _txtRefId.text = [NSString
      stringWithFormat:@"sdk_digit_%f", [[NSDate date] timeIntervalSince1970]];
  _txtAmount.text = @"1";
  //    _txtTimeout.text = @"1670000000";
  NSTimeInterval timestmp = ceil([[NSDate date] timeIntervalSince1970]);
  _txtTimeout.text = [NSString stringWithFormat:@"%@", @(timestmp + 2 * 3600)];

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
  order.transaction.country = (_txtCountry.text && _txtCountry.text.length > 0)
                                  ? _txtCountry.text
                                  : nil;
  order.transaction.note = _txtNote.text;
  order.transaction.autoCapture = _autoCaptureSwitcher.isOn;

  order.payment = CPayPayment.new;
  order.payment.method = _paymentMethod;
  order.payment.expiry = @([_txtTimeout.text intValue]);
  //    order.payment.token = @"67341a877892a73ad493ba8e"; // cashapp uat vault
  //    token

  if (_paymentMethod) {
    if (([_paymentMethod caseInsensitiveCompare:@"paypal"] == NSOrderedSame ||
         [_paymentMethod caseInsensitiveCompare:@"venmo"] == NSOrderedSame) ||
        [_paymentMethod isEqualToString:@"grabpay"] ||
        [_paymentMethod isEqualToString:@"shopeepay"]

        || [_paymentMethod isEqualToString:@"gcash"] ||
        [_paymentMethod isEqualToString:@"paymaya"]

        || [_paymentMethod isEqualToString:@"billease"] ||
        [_paymentMethod isEqualToString:@"cashalo"]

    ) {
      order.consumer = CPayConsumer.new;
      order.consumer.reference =
          @"1234567"; // Change to unique value to idenfier consumer

      if ([_paymentMethod isEqualToString:@"grabpay"] ||
          [_paymentMethod isEqualToString:@"shopeepay"]

          || [_paymentMethod isEqualToString:@"gcash"] ||
          [_paymentMethod isEqualToString:@"paymaya"]

          || [_paymentMethod isEqualToString:@"billease"] ||
          [_paymentMethod isEqualToString:@"cashalo"]

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

      if ([_paymentMethod isEqualToString:@"billease"] ||
          [_paymentMethod isEqualToString:@"cashalo"]) {
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

        order.goods.goods = @[ good ];
      }
    }

    if ([_paymentMethod isEqualToString:@"cashapppay"]) {
      order.scheme = @"com.citcon.citconpay";

      order.payment.requestToken = self.requestTokenSwitcher.isOn;

      order.consumer = CPayConsumer.new;
      order.consumer.reference =
          @"citcon-003"; // Change to unique value to idenfier consumer

      order.consumer.phone = @"+8615167186161";
      order.consumer.lastName = @"zhang";

      order.consumer.firstName = @"san";

      order.consumer.city = @"Manila";
      order.consumer.email = @"test@123.com";
      order.consumer.street = @"Privada Germa";
      order.consumer.zip = @"1106";
      order.consumer.country = @"US";
    }

    if ([_paymentMethod isEqualToString:@"klarna"]) {
      order.scheme = @"citconpay-klarna";
        order.payment.requestToken = self.requestTokenSwitcher.isOn;

      if (!order.consumer) {
        order.consumer = CPayConsumer.new;
      }
      order.consumer.reference = @"citcon-003";
      order.consumer.email = @"test@citcon.com";
      order.consumer.phone = @"+17162204669";
      order.consumer.lastName = @"zhang";
      order.consumer.firstName = @"san";

      // Note: payment.format is automatically set to "json" by
      // CPayKlarnaGateway

      CPayBillingAddr *billingAddress = CPayBillingAddr.new;
      billingAddress.street = @"2055 Gateway Place";
      billingAddress.street2 = @"Suite 500";
      billingAddress.city = @"San Jose";
      billingAddress.state = @"CA";
      billingAddress.zip = @"95110";
      billingAddress.country = order.transaction.country;
      order.payment.billingAddress = billingAddress;

      order.goods = CPayGoods.new;

      CPayProduct *good = CPayProduct.new;
      good.name = @"test";
      good.unitAmount = order.transaction.amount ;
      good.quantity = @1;
        good.totalAmount = order.transaction.amount ;

      order.goods.goods = @[ good ];
      
      // ========== Klarna Travel API Example ==========
      // Add travel data for flight, hotel, car rental, or trip bookings
      // This demonstrates how to use the new Travel API structures
      
        // flight
        CPayExtGatewayFlight *flight = CPayExtGatewayFlight.new;
        flight.pnr = @"Y2YWJD";
        flight.affiliateName = @"Booking.com";
        
        CPayExtGatewayFlightItinerary *flightItinerary = CPayExtGatewayFlightItinerary.new;
        flightItinerary.departure = @"AMS";
        flightItinerary.departureCity = @"Amsterdam";
        flightItinerary.arrival = @"LHR";
        flightItinerary.arrivalCity = @"London";
        flightItinerary.carrier = @"KL";
        flightItinerary.segmentPrice = @2000;
        flightItinerary.departureDate = @"2025-12-25T08:00:00Z";
        flightItinerary.ticketDeliveryMethod = @"email";
        flightItinerary.ticketDeliveryRecipient = @"john.doe@email.com";
        flightItinerary.passengerId = @[@(1)];
        flightItinerary.clasName = @"business";
        flight.itinerary = @[flightItinerary];
        
        CPayExtGatewayFlightInsurance *flightInsurance = CPayExtGatewayFlightInsurance.new;
        flightInsurance.insuranceCompany = @"AON";
        flightInsurance.insuranceType = @"cancellation";
        flightInsurance.insurancePrice = @200;
        flight.insurance = @[flightInsurance];

        CPayExtGatewayFlightPassenger *flightPassenger = CPayExtGatewayFlightPassenger.new;
        flightPassenger.id = @1;
        flightPassenger.title = @"mr";
        flightPassenger.firstName = @"John";
        flightPassenger.lastName = @"Doe";
        flight.passengers = @[flightPassenger];

        
        // car
        CPayExtGatewayCar *car = CPayExtGatewayCar.new;
        car.pnr = @"3411qsxqed23123";
        car.affiliateName = @"hertz.com";
        
        CPayExtGatewayCarItinerary *carItinerary = CPayExtGatewayCarItinerary.new;
        carItinerary.rentalCompany = @"Hertz";
        carItinerary.driverId = @[@1];
        carItinerary.startTime = @"2022-08-20T16:45:00Z";
        carItinerary.endTime = @"2022-08-20T16:45:00Z";
        carItinerary.carPrice = @700;
        carItinerary.clasName = @"economy";

        carItinerary.pickUpLocation = CPayExtGatewayCarLocation.new;
        carItinerary.pickUpLocation.streetAddress = @"Aankomstpassage Amsterdam (Schiphol)";
        carItinerary.pickUpLocation.postalCode = @"1118 AA";
        carItinerary.pickUpLocation.city = @"Schiphol";
        carItinerary.pickUpLocation.country = @"NL";

        carItinerary.dropOffLocation = CPayExtGatewayCarLocation.new;
        carItinerary.dropOffLocation.streetAddress = @"Aankomstpassage Amsterdam (Schiphol)";
        carItinerary.dropOffLocation.postalCode = @"1118 AA";
        carItinerary.dropOffLocation.city = @"Schiphol";
        carItinerary.dropOffLocation.country = @"NL";
        
        car.carRentalItinerary = @[carItinerary];
        
        CPayExtGatewayCarInsurance *carInsurance = CPayExtGatewayCarInsurance.new;
        carInsurance.insuranceCompany = @"AON";
        carInsurance.insuranceType = @"cancellation";
        carInsurance.insurancePrice = @2000;
        
        car.insurance = @[carInsurance];
        
        CPayExtGatewayCarDriver *carDriver = CPayExtGatewayCarDriver.new;
        carDriver.id = @1;
        carDriver.title = @"mr";
        carDriver.firstName = @"Jane";
        carDriver.lastName = @"Doe";
        
        car.drivers = @[carDriver];
        
        
        // hotel
        CPayExtGatewayHotel *hotel = CPayExtGatewayHotel.new;
        hotel.pnr = @"20qsx2121";
        
        CPayExtGatewayHotelItinerary *hotelItinerary = CPayExtGatewayHotelItinerary.new;
        hotelItinerary.hotelName = @"Hotel ltd.";
        hotelItinerary.startTime = @"2022-08-06T19:50:00Z";
        hotelItinerary.endTime = @"2022-08-20T22:00:00Z";
        hotelItinerary.numberOfRooms = @1;
        hotelItinerary.ticketDeliveryMethod = @"email";
        hotelItinerary.ticketDeliveryRecipient = @"john.doe@email.com";
        hotelItinerary.hotelPrice = @23050;
        hotelItinerary.clasName = @"Presidential Suite";
        hotelItinerary.passengerId = @[@1];
        
        hotelItinerary.address = CPayExtGatewayHotelAddress.new;
        hotelItinerary.address.streetAddress = @"New Burlington St 10";
        hotelItinerary.address.postalCode = @"W1B 1JA";
        hotelItinerary.address.city = @"London";
        hotelItinerary.address.country = @"GB";
        
        hotel.hotelItinerary = @[hotelItinerary];
        
        CPayExtGatewayHotelInsurance *hotelInsurance = CPayExtGatewayHotelInsurance.new;
        hotelInsurance.insuranceCompany = @"AON";
        hotelInsurance.insuranceType = @"cancellation";
        hotelInsurance.insurancePrice = @200;
        
        hotel.insurance = @[hotelInsurance];
        
        CPayExtGatewayHotelPassenger *hotelPassenger = CPayExtGatewayHotelPassenger.new;
        hotelPassenger.id = @1;
        hotelPassenger.title = @"mr";
        hotelPassenger.firstName = @"John";
        hotelPassenger.lastName = @"Doe";
        
        hotel.passengers = @[hotelPassenger];
        
        // trip
        CPayExtGatewayTrip *trip = CPayExtGatewayTrip.new;
        
        trip.affiliateName = @"travel.com";
        trip.minAge = @21;
        trip.maxAge = @60;
        
        trip.tripItinerary = CPayExtGatewayTripItinerary.new;
        trip.tripItinerary.initialCountry = @"France";
        trip.tripItinerary.initialCity = @"Calais";
        trip.tripItinerary.finalCountry = @"England";
        trip.tripItinerary.finalCity = @"Dover";
        trip.tripItinerary.startTime = @"2022-08-06T19:50:00Z";
        trip.tripItinerary.endTime = @"2022-08-15T19:50:00Z";
        
        CPayExtGatewayTripPassenger *tripPassenger1 = CPayExtGatewayTripPassenger.new;
        tripPassenger1.id = @1;
        tripPassenger1.firstName = @"John";
        tripPassenger1.lastName = @"Doe";
        tripPassenger1.birthDate = @"1980-05-10";
        tripPassenger1.email = @"johndoe@email.com";
        tripPassenger1.uniqueId = @"AYY12345";
        tripPassenger1.mainPassenger = @"true";
        
        trip.tripPassengers = @[tripPassenger1];
        
        CPayExtGatewayTripServices *service1 = CPayExtGatewayTripServices.new;
        service1.travelInsurance    = @"true";
        service1.hotel = @"true";
        service1.flight = @"true";
        service1.cancelationService = @"true";
        service1.sharedRoom = @"false";
        
        trip.services = @[service1];
        
        order.ext = CPayExt.new;
        order.ext.gateway = CPayExtGateway.new;
        order.ext.gateway.flight = @[flight];
        order.ext.gateway.car = @[car];
        order.ext.gateway.trip = @[trip];
        order.ext.gateway.hotel = @[hotel];
        
      
      // ========== End of Travel API Example ==========
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
        order.goods.goods = @[ good ];

        CPayShipping *shipping = CPayShipping.new;
        shipping.city = @"CA";
        shipping.zip = @"95134";
        shipping.country = @"US";
        order.goods.shipping = shipping;
      } else {
        order.transaction.vertical =
            @"Household goods, shoes, clothing, tickets";

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
        order.goods.goods = @[ good ];

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
    //        order.paypalClientId =
    //        @"Aevy5i-20TVIB6j6KyjbWoUuqopBtx0UKg8L6xlbHv3_ZP3ddoVXkAXSooCsg7HUWDOJgt4oJmh8l2Yg";
  }

  return order;
}

- (BOOL)isPPCPPayPal {
  return [_paymentMethod isEqualToString:@"paypal"] && _digitTitle &&
         [_digitTitle isEqualToString:@"PPCP PayPal"];
}

- (BOOL)isKlarna {
  return [_paymentMethod isEqualToString:@"klarna"];
}

- (BOOL)isCashApp {
  return [_paymentMethod isEqualToString:@"cashapppay"];
}
- (void)addCurrencyGesture {
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(onCurrencySelect)];
  [_txtCurrency addGestureRecognizer:tap];
}

- (void)addCountryGesture {
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(onCountrySelect)];
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
  [self requestCharge:[self createOrder]
           onComplete:^(NSString *_Nullable chargeToken) {
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

#pragma mark - Klarna OSM

- (void)addKlarnaOSMView {
  // Check if Klarna OSM is available
  if (![CPayStyleManager hasKlarnaOSM]) {
    NSLog(@"⚠️ Klarna OSM not available");
    return;
  }

  NSLog(@"✅ Klarna OSM available, creating OSM view");

  // Create Klarna OSM view with full parameters
  BOOL success = [CPayStyleManager
      buildKlarnaOSMViewWithClientId:
          @"klarna_test_client_"
          @"WklYWkN3Q20jRnl6WVVuU252b2ZkaGVIYU0vZTdlN3ksZTJiYmY5OGYtNzE3ZC00Mjd"
          @"lLWE4OWMtOTdlY2FkNzgwYmQ3LDEsTDB6TzY5VVZESDBpaVJTclg2bStXVElmdGZBdE"
          @"JsWlZ4UEhUM2FmY1g5ST0"
      placementKey:@"credit-promotion-badge"
      locale:@"en-US"
      purchaseAmount:@([_txtAmount.text intValue])
      region:@"NA"
      environment:@"playground"
      theme:@"dark"
      onHeightChanged:^(CGFloat height) {
        NSLog(@"📏 Klarna OSM height changed: %.2f", height);
        dispatch_async(dispatch_get_main_queue(), ^{
          [self updateKlarnaOSMHeight:height];
        });
      }
      completion:^(UIView *_Nullable osmView, NSError *_Nullable error) {
        if (error) {
          NSLog(@"❌ Failed to create Klarna OSM view: %@",
                error.localizedDescription);
          return;
        }

        if (osmView) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [self displayKlarnaOSMView:osmView];
          });
        }
      }];

  if (success) {
    NSLog(@"✅ Klarna OSM view creation initiated (will auto-render)");
  } else {
    NSLog(@"❌ Failed to initiate Klarna OSM view creation");
  }
}

- (void)displayKlarnaOSMView:(UIView *)osmView {
  NSLog(@"🎨 Displaying Klarna OSM view");

  self.klarnaOSMView = osmView;
  self.klarnaOSMView.backgroundColor = [UIColor redColor];
  osmView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:osmView];

  // Create height constraint with initial value
  self.klarnaOSMHeightConstraint =
      [osmView.heightAnchor constraintEqualToConstant:100];

  [NSLayoutConstraint activateConstraints:@[
    // Position below the confirm button
    [osmView.topAnchor constraintEqualToAnchor:self.confirmBtn.bottomAnchor
                                      constant:200],
    [osmView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor
                                          constant:16],
    [osmView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor
                                           constant:-16],
    self.klarnaOSMHeightConstraint
  ]];

  NSLog(@"✅ Klarna OSM view displayed");
}

- (void)updateKlarnaOSMHeight:(CGFloat)height {
  if (self.klarnaOSMHeightConstraint) {
    NSLog(@"📏 Updating Klarna OSM height to: %.2f", height);
    self.klarnaOSMHeightConstraint.constant = height;
    [UIView animateWithDuration:0.3
                     animations:^{
                       [self.view layoutIfNeeded];
                     }];
  }
}

@end
