//
//  FORMSignatureFieldCell.h
//  Basic-ObjC
//
//  Created by Kevin Jacob on 2015-07-08.
//  Copyright (c) 2015 Hyper. All rights reserved.
//

#import "FORMBaseFieldCell.h"

#import "FORMFields.h"
#import "SignatureView.h"

static NSString * const FORMSignatureFieldCellIdentifier = @"FORMSignatureFieldCellIdentifier";

@protocol SignatureFieldDelegate;

@interface FORMSignatureFieldCell : FORMBaseFieldCell <SignatureViewDelegate>

@property (nonatomic, weak) id <SignatureFieldDelegate>         sigDelegate;

@property (nonatomic, strong) SignatureView                     *signatureView;
@property (nonatomic, strong) UIImageView                       *signatureImage;

@end


@protocol SignatureFieldDelegate <NSObject>

//- (void)signatureViewDidStart:(SignatureView*)signatureCell;
- (void)signatureViewClosed;
//- (NSString*)signatureFolderForSignatureView:(SignatureView *)signatureCell;

@end