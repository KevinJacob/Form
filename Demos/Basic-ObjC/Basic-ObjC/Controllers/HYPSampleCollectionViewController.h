@import UIKit;
@import Foundation;

#import "FORMViewController.h"
#import "FORMSignatureFieldCell.h"

@interface HYPSampleCollectionViewController : FORMViewController <SignatureFieldDelegate>

@property (atomic, assign) BOOL                     signaturePanelExposed;
@property (nonatomic, strong) SignatureView         *signatureView;

- (instancetype)initWithJSON:(NSArray *)JSON
            andInitialValues:(NSDictionary *)initialValues;

@end
