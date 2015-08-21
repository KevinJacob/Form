//
//  FORMThumbnailViewCell.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-08-04.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMThumbnailViewCell.h"
#import "GBDeviceInfo.h"


static const CGFloat FORMThumbFieldTopMargin = 30.0f;
static const CGFloat FORMThumbFieldMargin = 10.0f;

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


@implementation FORMThumbnailViewCell


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
    
    
    CGFloat devicePPI = [GBDeviceInfo deviceInfo].displayInfo.pixelsPerInch;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat deviceWidth = screenBounds.size.width * screenScale;
    double inchPercentageofWidth = ((devicePPI/deviceWidth)*100);
    
    UIImageView *thumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(FORMThumbFieldMargin,
                                                                            self.frame.size.height - 195 - FORMThumbFieldTopMargin,
                                                                            (((inchPercentageofWidth/100) * deviceWidth) - (FORMThumbFieldMargin * 2)),
                                                                            195)];
    thumbImage.layer.borderWidth = 1.0f;
    thumbImage.layer.borderColor = [UIColor blackColor].CGColor;
    [thumbImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [thumbImage setContentMode:UIViewContentModeScaleToFill];
    thumbImage.layer.cornerRadius = 5.0f;
    thumbImage.backgroundColor = [UIColor lightGrayColor];
    self.thumbnailImageView = thumbImage;
    self.thumbnailImageView.contentMode = UIViewContentModeCenter;
    [self.thumbnailImageView setClipsToBounds:YES];
    
    [self.contentView addSubview:self.thumbnailImageView];
    
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat devicePPI = [GBDeviceInfo deviceInfo].displayInfo.pixelsPerInch;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat deviceWidth = screenBounds.size.width * screenScale;
    double inchPercentageofWidth = ((devicePPI/deviceWidth)*100);
    
    self.thumbnailImageView.frame = CGRectMake(FORMThumbFieldMargin,
                                               self.frame.size.height - 195 - FORMThumbFieldTopMargin,
                                               (((inchPercentageofWidth/100) * deviceWidth) - (FORMThumbFieldMargin * 2)),
                                               195);
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMBaseFormFieldCell
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
        self.thumbnailImageView.backgroundColor = activeBackgroundColor;
        self.thumbnailImageView.layer.borderColor = activeBorderColor.CGColor;
    }
    else
    {
        self.thumbnailImageView.backgroundColor = inactiveBackgroundColor;
        self.thumbnailImageView.layer.borderColor = inactiveBorderColor.CGColor;
    }
}



- (void)setEnabled:(BOOL)enabled
{
    if(enabled)
    {
        self.thumbnailImageView.backgroundColor = enabledBackgroundColor;
        self.thumbnailImageView.layer.borderColor = enabledBorderColor.CGColor;
    }
    else
    {
        self.thumbnailImageView.backgroundColor = disabledBackgroundColor;
        self.thumbnailImageView.layer.borderColor = disabledBorderColor.CGColor;
    }
}



- (void)setValid:(BOOL)valid
{
    if (valid)
    {
        self.thumbnailImageView.backgroundColor = validBackgroundColor;
        self.thumbnailImageView.layer.borderColor = validBorderColor.CGColor;
    }
    else
    {
        self.thumbnailImageView.backgroundColor = invalidBackgroundColor;
        self.thumbnailImageView.layer.borderColor = invalidBorderColor.CGColor;
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
