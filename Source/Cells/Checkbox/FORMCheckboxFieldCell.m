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
    
    UIButton *checkbox = [[UIButton alloc]initWithFrame:CGRectMake (FORMCheckboxFieldMargin,
                                                                    FORMCheckboxFieldTopMargin,
                                                                    self.frame.size.height - FORMCheckboxFieldMargin - FORMCheckboxFieldTopMargin,
                                                                    self.frame.size.height - FORMCheckboxFieldMargin - FORMCheckboxFieldTopMargin)];
    
    [checkbox setImage:[UIImage imageNamed:@"check-no"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"check-yes"] forState:UIControlStateHighlighted];
    [checkbox setImage:[UIImage imageNamed:@"check-yes"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(accessoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:checkbox];
    
    self.check = checkbox;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    return self;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Actions
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)accessoryButtonTapped
{
    if(self.check.isSelected)
    {
        [self.check setSelected:NO];
    }
    else
    {
        [self.check setSelected:YES];
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
}


@end
