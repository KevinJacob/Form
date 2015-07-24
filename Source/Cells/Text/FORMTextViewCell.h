//
//  FormTextViewCell.h
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-22.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMBaseFieldCell.h"


static NSString * const FORMTextViewCellIdentifier = @"FORMTextViewCellIdentifier";


@interface FORMTextViewCell : FORMBaseFieldCell <UITextViewDelegate>

- (void)setTooltipLabelFont:(UIFont *)tooltipLabelFont UI_APPEARANCE_SELECTOR;
- (void)setTooltipLabelTextColor:(UIColor *)tooltipLabelTextColor UI_APPEARANCE_SELECTOR;
- (void)setTooltipBackgroundColor:(UIColor *)tooltipBackgroundColor UI_APPEARANCE_SELECTOR;

@end
