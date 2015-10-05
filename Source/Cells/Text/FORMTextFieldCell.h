@import UIKit;

#import "FORMBaseFieldCell.h"

static NSString * const FORMResignFirstResponderNotification = @"FORMResignFirstResponderNotification";
static NSString * const FORMDismissTooltipNotification = @"FORMDismissTooltipNotification";
static NSString * const FORMTextFieldCellIdentifier = @"FORMTextFieldCellIdentifier";
static NSString * const FORMCountFieldCellIdentifier = @"FORMCountFieldCellIdentifier";

@protocol FORMTextFieldCellDelegate <NSObject>
@optional
- (void)scanBarcodeOperationTextField:(id)sender;
- (void)beganEditing:(id)sender;

@end


@interface FORMTextFieldCell : FORMBaseFieldCell

@property (nonatomic, weak) id <FORMTextFieldCellDelegate> formTextFieldCellDelegate;

- (void)textFormField:(FORMTextField *)textField didUpdateWithText:(NSString *)text;

- (void)setTooltipLabelFont:(UIFont *)tooltipLabelFont UI_APPEARANCE_SELECTOR;
- (void)setTooltipLabelTextColor:(UIColor *)tooltipLabelTextColor UI_APPEARANCE_SELECTOR;
- (void)setTooltipBackgroundColor:(UIColor *)tooltipBackgroundColor UI_APPEARANCE_SELECTOR;

@end
