//
//  FORMDropDownValueView.h
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-23.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMTextView.h"

@protocol FORMDropDownValueDelegate;


@interface FORMDropDownValueView : FORMTextView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <FORMDropDownValueDelegate> valueDelegate;

@end


@protocol FORMDropDownValueDelegate <NSObject>

@optional
- (void)titleLabelPressed:(FORMDropDownValueView *)valueView;

@end