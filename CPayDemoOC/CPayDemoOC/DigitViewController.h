//
//  DigitViewController.h
//  CPayDemoOC
//
//  Created by long.zhao on 3/13/22.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DigitViewController : BaseViewController

- (void)setDigitTitle:(NSString *)title;
- (void)setPaymentMethod:(NSString *)payment;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

NS_ASSUME_NONNULL_END
