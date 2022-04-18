//
//  BaseViewController.h
//  CPayDemoOC
//
//  Created by long.zhao on 3/1/22.
//

#import <UIKit/UIKit.h>
#import <CPaySDK/CPaySDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) NSArray *pickerData;

- (void)initPickerView;
- (void)showPicker;
- (void)dismissPicker;
- (void)setNavTitle:(NSString *)title;
- (void)confirmCharge:(CPayRequest *)order;

@end

NS_ASSUME_NONNULL_END
