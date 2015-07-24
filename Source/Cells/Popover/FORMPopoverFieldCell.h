#import "FORMBaseFieldCell.h"
#import "FORMDropDownValueView.h"
#import "FORMFieldValuesTableViewController.h"

@interface FORMPopoverFieldCell : FORMBaseFieldCell

@property (nonatomic) FORMDropDownValueView *valueView;
@property (nonatomic) UIPopoverController *popoverController;
@property (nonatomic) UIImageView *iconImageView;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize NS_DESIGNATED_INITIALIZER;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(FORMFields *)field;

@end