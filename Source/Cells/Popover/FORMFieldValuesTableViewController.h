@import UIKit;

#import "FORMFieldValuesTableViewHeader.h"
#import "FORMFieldValueCell.h"
#import "FORMFieldValue.h"

@class FORMFieldValue;
@class FORMFields;

@protocol FORMFieldValuesTableViewControllerDelegate;

static const CGFloat FORMFieldValuesCellHeight = 44.0f;

@interface FORMFieldValuesTableViewController : UITableViewController

@property (nonatomic, weak) FORMFields *field;
@property (nonatomic) FORMFieldValuesTableViewHeader *headerView;
@property (nonatomic) CGFloat customHeight;
@property (nonatomic, weak) FORMFieldValue *fieldValue;
@property (nonatomic, weak) FORMFieldValueCell *selectedCell;

@property (nonatomic, weak) UIButton            *cancelButton;
@property (nonatomic, weak) UIButton            *clearButton;
@property (nonatomic, weak) UIButton            *selectButton;

@property (nonatomic, weak) id <FORMFieldValuesTableViewControllerDelegate> delegate;

@end



@protocol FORMFieldValuesTableViewControllerDelegate <NSObject>

- (void)fieldValuesTableViewController:(FORMFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(FORMFieldValue *)selectedValue;

@end
