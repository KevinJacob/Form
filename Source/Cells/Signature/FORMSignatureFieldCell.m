//
//  FORMSignatureFieldCell.m
//  Basic-ObjC
//
//  Created by Kevin Jacob on 2015-07-08.
//  Copyright (c) 2015 Hyper. All rights reserved.
//

#import "FORMSignatureFieldCell.h"


static const CGFloat FORMSignatureFieldTopMargin = 30.0f;
static const CGFloat FORMSignatureFieldMargin = 10.0f;


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
                                                                          FORMSignatureFieldTopMargin,
                                                                          self.frame.size.width - (FORMSignatureFieldMargin * 2),
                                                                          self.frame.size.height - (FORMSignatureFieldMargin * 3) - FORMSignatureFieldTopMargin)];
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


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Layout
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - SignatureViewDelegate
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-(void)signatureViewDidEnd:(BOOL)save
{
    if(save)
    {
        self.signatureImage.image = [self.signatureView signatureImage];
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
}


@end
