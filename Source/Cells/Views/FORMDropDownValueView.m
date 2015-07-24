//
//  FORMDropDownValueView.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-23.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMDropDownValueView.h"

@implementation FORMDropDownValueView


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Set Up
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    
    self.editable = NO;
    self.textContainerInset = UIEdgeInsetsMake(12, 5, 10, 25);
    self.scrollEnabled = NO;
    self.showsVerticalScrollIndicator   = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapAction)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    return self;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Actions
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)titleLabelTapAction
{
    if ([self.valueDelegate respondsToSelector:@selector(titleLabelPressed:)])
    {
        [self.valueDelegate titleLabelPressed:self];
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - UIGestureRecognizerDelegate
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


@end
