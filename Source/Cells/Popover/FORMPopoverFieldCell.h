#import "FORMBaseFieldCell.h"
#import "FORMDropDownValueView.h"
#import "FORMFieldValuesTableViewController.h"
#import "RMActionController.h"


@protocol DropdownDelegate;


@interface FORMPopoverFieldCell : FORMBaseFieldCell

@property (nonatomic, weak) id <DropdownDelegate>               dropdownDelegate;
@property (nonatomic) FORMDropDownValueView                     *valueView;
@property (nonatomic) UIPopoverController                       *popoverController;
@property (nonatomic) UIImageView                               *iconImageView;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize NS_DESIGNATED_INITIALIZER;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(FORMFields *)field;

@end

@protocol DropdownDelegate <NSObject>

@optional
- (void)presentDropdown:(UIViewController *)controller fromRect:(CGRect)rect;
- (void)dropdownClosed;

@end