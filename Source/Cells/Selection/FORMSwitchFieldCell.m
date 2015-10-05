//
// FORMSwitchFieldCell.m
// SceneDoc
//
// Created by Kevin Jacob on 2015-09-02.
// Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMSwitchFieldCell.h"


static const CGFloat FORMSwitchFieldMargin = 10.0f;


@implementation FORMSwitchFieldCell


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Set Up
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentView.clipsToBounds = NO;

    UILabel *subtext = [[UILabel alloc] init];
    subtext.lineBreakMode = NSLineBreakByWordWrapping;
    subtext.numberOfLines = 0;
    [subtext setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:12.0]];
    self.subLabel = subtext;

    UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake (self.frame.size.width - 60 - FORMSwitchFieldMargin,
                                                                        FORMSwitchFieldMargin,
                                                                        60,
                                                                        60)];

    [switchButton addTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventValueChanged];
    self.switchButton = switchButton;

    [self.contentView addSubview:self.switchButton];
    [self.contentView addSubview:self.subLabel];

    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat height = [self getHeightForText:self.subLabel.text withWidth:self.headingLabel.frame.size.width withFont:[UIFont fontWithName:@"AvenirNext-Regular" size:12.0]];
    self.subLabel.frame = CGRectMake(15, self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + 10, self.headingLabel.frame.size.width, height);
    
    self.switchButton.frame = CGRectMake (self.frame.size.width - 60 - FORMSwitchFieldMargin,
                                          FORMSwitchFieldMargin,
                                          60,
                                          60);
}



- (void)prepareForReuse
{
    self.subLabel.text = nil;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Actions
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)accessoryButtonTapped:(id)sender
{
    NSString *valStr;

    if ([sender isOn])
    {
        valStr = @"YES";
    }
    else
    {
        valStr = @"NO";
    }

    self.field.value = valStr;

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)])
    {
        [self.delegate fieldCell:self
                updatedWithField:self.field];
    }
}



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMBaseFormFieldCell
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.alpha                                  = disabled ? 0.5f : 1.0f;
    self.switchButton.userInteractionEnabled    = disabled ? NO : YES;
}



- (void)updateWithField:(FORMFields *)field
{
    [super updateWithField:field];

    self.hidden                                 = (field.sectionSeparator);
    self.alpha                                  = field.disabled ? 0.5f : 1.0f;
    self.switchButton.userInteractionEnabled    = field.disabled ? NO : YES;

    if (field.info)
    {
        self.subLabel.text = field.info;
    }

    if ([field.value isEqualToString:@"YES"])
    {
        [self.switchButton setOn:YES];
    }
    else
    {
        [self.switchButton setOn:NO];
    }
}



@end