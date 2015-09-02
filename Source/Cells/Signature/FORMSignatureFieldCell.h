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
@property (nonatomic, strong) NSString                          *fileName;

@property (nonatomic, strong) SignatureView                     *signatureView;
@property (nonatomic, strong) UIImageView                       *signatureImage;


- (void)setActiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setActiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setEnabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setValidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setValidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setCornerRadius:(CGFloat)cornerRadius UI_APPEARANCE_SELECTOR;

@end


@protocol SignatureFieldDelegate <NSObject>

@optional
- (void)signatureViewClosed;
- (NSString *)pathForSignatureFolder;

@end