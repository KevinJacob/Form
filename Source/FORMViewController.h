@import UIKit;

#import "FORMDataSource.h"
#import "FORMSignatureFieldCell.h"
#import "FORMSelectFieldCell.h"
#import "FORMTextFieldCell.h"
#import "FORMTextViewCell.h"

@interface FORMViewController : UICollectionViewController <SignatureFieldDelegate, DropdownDelegate, FORMTextFieldCellDelegate, FORMTextViewCellDelegate>

@property (nonatomic, readonly) FORMDataSource *dataSource;
@property (nonatomic, copy) id JSON;
@property (nonatomic) FORMLayout *layout;


- (instancetype)initWithJSON:(id)JSON
            andInitialValues:(NSDictionary *)initialValues
                    disabled:(BOOL)disabled;

@end
