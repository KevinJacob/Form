#import "FORMSelectFieldCell.h"
#import "RMDateSelectionViewController.h"

static NSString * const FORMDateFormFieldCellIdentifier = @"FORMDateFormFieldCellIdentifier";

@interface FORMDateFieldCell : FORMSelectFieldCell

@property (nonatomic) RMDateSelectionViewController *dateController;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;

@end
