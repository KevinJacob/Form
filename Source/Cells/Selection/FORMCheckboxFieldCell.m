//
//  FORMCheckboxFieldCell.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-21.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMCheckboxFieldCell.h"


static const CGFloat FORMCheckboxFieldTopMargin = 30.0f;
static const CGFloat FORMCheckboxFieldMargin = 10.0f;


@implementation FORMCheckboxFieldCell


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Set Up
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    UIButton *checkbox = [[UIButton alloc]initWithFrame:CGRectMake (FORMCheckboxFieldMargin,
                                                                    self.frame.size.height - 45 - FORMCheckboxFieldTopMargin,
                                                                    45,
                                                                    45)];
    
    [checkbox setImage:[UIImage imageNamed:@"check-no"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"check-yes"] forState:UIControlStateHighlighted];
    [checkbox setImage:[UIImage imageNamed:@"check-yes"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(accessoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.check = checkbox;
    
    [self.contentView addSubview:self.check];
    
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.check.frame = CGRectMake (FORMCheckboxFieldMargin,
                                   self.frame.size.height - 45 - FORMCheckboxFieldTopMargin,
                                   45,
                                   45);
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Actions
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)accessoryButtonTapped
{
    NSString *valStr;
    
    if(self.check.isSelected)
    {
        [self.check setSelected:NO];
        valStr = @"";
    }
    else
    {
        [self.check setSelected:YES];
        valStr = @"Y";
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
    self.check.userInteractionEnabled           = disabled ? NO : YES;
}



- (void)updateWithField:(FORMFields *)field
{
    [super updateWithField:field];
    
    self.hidden                                 = (field.sectionSeparator);
    self.alpha                                  = field.disabled ? 0.5f : 1.0f;
    self.check.userInteractionEnabled           = field.disabled ? NO : YES;
    
    if([field.value isEqualToString:@"Y"])
    {
        [self.check setSelected:YES];
    }
    else
    {
        [self.check setSelected:NO];
    }
}


@end
