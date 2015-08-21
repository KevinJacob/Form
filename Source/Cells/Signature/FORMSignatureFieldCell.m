//
//  FORMSignatureFieldCell.m
//  Basic-ObjC
//
//  Created by Kevin Jacob on 2015-07-08.
//  Copyright (c) 2015 Hyper. All rights reserved.
//

#import "FORMSignatureFieldCell.h"

#import "RNDecryptor.h"
#import "RNEncryptor.h"


static const CGFloat FORMSignatureFieldTopMargin = 30.0f;
static const CGFloat FORMSignatureFieldMargin = 10.0f;

static UIColor *activeBackgroundColor;
static UIColor *activeBorderColor;
static UIColor *inactiveBackgroundColor;
static UIColor *inactiveBorderColor;

static UIColor *enabledBackgroundColor;
static UIColor *enabledBorderColor;
static UIColor *disabledBackgroundColor;
static UIColor *disabledBorderColor;

static UIColor *validBackgroundColor;
static UIColor *validBorderColor;
static UIColor *invalidBackgroundColor;
static UIColor *invalidBorderColor;


@implementation FORMSignatureFieldCell


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Set Up
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    SignatureView *newSignatureView = [[SignatureView alloc] initWithFrame:CGRectMake(self.frame.origin.x + (FORMSignatureFieldMargin * 2),
                                                                                      self.frame.origin.y + (FORMSignatureFieldMargin * 2),
                                                                                      self.frame.size.width - (FORMSignatureFieldMargin * 2),
                                                                                      self.frame.size.height - (FORMSignatureFieldMargin * 4))];
    [newSignatureView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [newSignatureView setContentMode:UIViewContentModeScaleToFill];
    newSignatureView.layer.cornerRadius = 5.0f;
    newSignatureView.delegate = self;
    [newSignatureView setLineWidth:2.0];
    self.signatureView = newSignatureView;
    
    
    UIImageView *sigImage = [[UIImageView alloc] initWithFrame:CGRectMake(FORMSignatureFieldMargin,
                                                                          self.frame.size.height - 195 - FORMSignatureFieldTopMargin,
                                                                          self.frame.size.width - (FORMSignatureFieldMargin * 2),
                                                                          195)];
    sigImage.layer.borderWidth = 1.0f;
    sigImage.layer.borderColor = [UIColor blackColor].CGColor;
    [sigImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [sigImage setContentMode:UIViewContentModeScaleToFill];
    sigImage.layer.cornerRadius = 5.0f;
    sigImage.image = [self.signatureView signatureImage];
    sigImage.backgroundColor = [UIColor whiteColor];
    self.signatureImage = sigImage;
    
    [self.contentView addSubview:self.signatureImage];
    
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.signatureImage.frame = CGRectMake(FORMSignatureFieldMargin,
                                           self.frame.size.height - 195 - FORMSignatureFieldTopMargin,
                                           self.frame.size.width - (FORMSignatureFieldMargin * 2),
                                           195);
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Signature Set/Get
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)setSignature:(NSString*)sigFilename
{
    NSData *encryptedSigImageData = [[NSFileManager defaultManager] contentsAtPath:[self sigPath:sigFilename]];
    NSError *error;
    NSData *sigImageData = [RNDecryptor decryptData:encryptedSigImageData
                                       withPassword:[Lockbox getUserFileEncryptionKeyforUsername:[[Prefs sharedInstance] getUserName]]
                                              error:&error];
    UIImage *sigImage = [UIImage imageWithData:sigImageData];
    
    if (sigImage)
    {
        self.signatureImage.image = sigImage;
    }
    
    [self layoutSubviews];
}



- (NSString *)sigPath:(NSString*)filename
{
    NSString *sigPath = [[_sigDelegate pathForSignatureFolder] stringByAppendingPathComponent:filename];
    return(sigPath);
}



- (void)saveSignatureFile
{
    NSData *data = UIImagePNGRepresentation(self.signatureImage.image);
    NSData *encryptedSignatureData = [RNEncryptor encryptData:data
                                                 withSettings:kRNCryptorAES256Settings
                                                     password:[Lockbox getUserFileEncryptionKeyforUsername:[[Prefs sharedInstance] getUserName]]
                                                        error:nil];
    NSError*error;
    if (![encryptedSignatureData writeToFile:[self sigPath:self.fileName] options:NSDataWritingFileProtectionComplete error:&error])
    {
        [ErrorDebugHelper logErrors:THIS_FILE thisMethod:THIS_METHOD error:error];
    }
}



- (void)deleteSignatureFile
{
    // Ensure the file exists.
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self sigPath:self.fileName]])
    {
        /// *DELETE* the actual png file.
        [[NSFileManager defaultManager] removeItemAtPath:[self sigPath:self.fileName] error:nil];
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - SignatureViewDelegate
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-(void)signatureViewDidEnd:(BOOL)save
{
    if(save)
    {
        self.signatureImage.image = [self.signatureView signatureImage];
        self.field.value = self.fileName;
        [self saveSignatureFile];
        
        if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)])
        {
            [self.delegate fieldCell:self
                    updatedWithField:self.field];
        }
    }
    else
    {
        [self.signatureView clear];
    }
    
    [self.sigDelegate signatureViewClosed];
    [self.signatureView removeFromSuperview];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMBaseFormFieldCell
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.alpha                                  = disabled ? 0.5f : 1.0f;
    self.signatureImage.userInteractionEnabled  = disabled ? NO : YES;
}



- (void)updateWithField:(FORMFields *)field
{
    [super updateWithField:field];
    
    self.hidden                                 = (field.sectionSeparator);
    self.alpha                                  = field.disabled ? 0.5f : 1.0f;
    self.signatureImage.userInteractionEnabled  = field.disabled ? NO : YES;
    
    if(field.value)
    {
        [self setSignature:self.field.value];
        self.fileName = self.field.value;
        self.signatureView.blank = NO;
    }
    else
    {
        NSUUID *UUID = [NSUUID UUID];
        NSString *signatureUUID = [UUID UUIDString];
        self.fileName = [signatureUUID stringByAppendingPathExtension:@"png"];
    }
}



-(void)validate
{
    BOOL validation = ([self.field validate] == FORMValidationResultTypeValid);
    [self setValid:validation];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Appearance
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)setActive:(BOOL)active
{
    if(active)
    {
        self.signatureImage.backgroundColor = activeBackgroundColor;
        self.signatureImage.layer.borderColor = activeBorderColor.CGColor;
    }
    else
    {
        self.signatureImage.backgroundColor = inactiveBackgroundColor;
        self.signatureImage.layer.borderColor = inactiveBorderColor.CGColor;
    }
}



- (void)setEnabled:(BOOL)enabled
{
    if(enabled)
    {
        self.signatureImage.backgroundColor = enabledBackgroundColor;
        self.signatureImage.layer.borderColor = enabledBorderColor.CGColor;
    }
    else
    {
        self.signatureImage.backgroundColor = disabledBackgroundColor;
        self.signatureImage.layer.borderColor = disabledBorderColor.CGColor;
    }
}



- (void)setValid:(BOOL)valid
{
    if (valid)
    {
        self.signatureImage.backgroundColor = validBackgroundColor;
        self.signatureImage.layer.borderColor = validBorderColor.CGColor;
    }
    else
    {
        self.signatureImage.backgroundColor = invalidBackgroundColor;
        self.signatureImage.layer.borderColor = invalidBorderColor.CGColor;
    }
}



- (void)setActiveBackgroundColor:(UIColor *)color
{
    activeBackgroundColor = color;
}



- (void)setActiveBorderColor:(UIColor *)color
{
    activeBorderColor = color;
}



- (void)setInactiveBackgroundColor:(UIColor *)color
{
    inactiveBackgroundColor = color;
}



- (void)setInactiveBorderColor:(UIColor *)color
{
    inactiveBorderColor = color;
}



- (void)setEnabledBackgroundColor:(UIColor *)color
{
    enabledBackgroundColor = color;
}



- (void)setEnabledBorderColor:(UIColor *)color
{
    enabledBorderColor = color;
}



- (void)setDisabledBackgroundColor:(UIColor *)color
{
    disabledBackgroundColor = color;
}



- (void)setDisabledBorderColor:(UIColor *)color
{
    disabledBorderColor = color;
}



- (void)setValidBackgroundColor:(UIColor *)color
{
    validBackgroundColor = color;
}



- (void)setValidBorderColor:(UIColor *)color
{
    validBorderColor = color;
}



- (void)setInvalidBackgroundColor:(UIColor *)color
{
    invalidBackgroundColor = color;
}



- (void)setInvalidBorderColor:(UIColor *)color
{
    invalidBorderColor = color;
}


@end