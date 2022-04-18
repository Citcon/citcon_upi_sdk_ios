//
//  BaseViewController.m
//  CPayDemoOC
//
//  Created by long.zhao on 3/1/22.
//

#import "BaseViewController.h"
#import "LoadingView.h"
#import "AppDefines.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initPickerView];
    [self initTouch];
}

#pragma mark - initialize

- (void)initTouch {
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBgTap:)];
    [self.view addGestureRecognizer:bgTap];
}

- (void)initPickerView {
    // create picker
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/3)];
    [_picker setBackgroundColor:[UIColor systemGrayColor]];
    [_picker setDataSource:self];
    [_picker setDelegate:self];
    [self.view addSubview:_picker];
}

- (void)showPicker {
    self.picker.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.picker.frame = CGRectMake(0, self.view.frame.size.height*.67, self.view.frame.size.width, self.view.frame.size.height/3);
    } completion:^(BOOL finished) {
        [self.picker reloadAllComponents];
    }];
}

- (void)dismissPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.picker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/3);
    } completion:^(BOOL finished) {
        self.picker.alpha = 0;
    }];
}

- (void)setNavTitle:(NSString *)title {
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = title;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - picker delegate & datasource

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *_d = self.pickerData[row];
    if (_d) self.currentTextField.text = _d;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - ui event

- (void)onBgTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
    [self dismissPicker];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - utils

- (void)confirmCharge:(CPayRequest *)order {
    [LoadingView show: self];
    [[CPayManager sharedInst] requestOrder:order callback:^(CPayResult * _Nullable resp) {
        [LoadingView dismiss];
        
        NSLog(@"Result status:(%@) code:(%@) message:(%@)", resp.status, resp.data.code, resp.data.message);
        if ([resp.status isEqualToString:@"success"]) {
            NSLog(@"Txn Id: %@", resp.data.id);
            NSLog(@"Ref Id: %@", resp.data.reference);
            NSLog(@"Amount: %ld", (long)resp.data.amount);
            NSLog(@"Currency: %@", resp.data.currency);
            NSLog(@"PaymentMethod: %@", resp.data.payment.method);
            NSLog(@"AutoCapture: %@", resp.data.autoCapture ? @"true" : @"false");
            NSLog(@"Txn status: %@", resp.data.status);
            NSLog(@"TimeCreated: %ld", (long)resp.data.timeCreated);
            NSLog(@"ChargeToken: %@", resp.data.chargeToken);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[AppDefines sharedInst].ns_pay_completed object:resp];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
