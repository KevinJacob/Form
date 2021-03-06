//
//  FORMLabelFieldCell.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-21.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMLabelFieldCell.h"


@implementation FORMLabelFieldCell


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Set Up
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    return self;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMBaseFormFieldCell
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)updateFieldWithDisabled:(BOOL)disabled
{
}



- (void)updateWithField:(FORMFields *)field
{
    [super updateWithField:field];
    
    self.hidden                                 = (field.sectionSeparator);
}


@end
