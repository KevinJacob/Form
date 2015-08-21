//
//  FORMThumbnailViewCell.h
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-08-04.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMBaseFieldCell.h"
#import "FormField.h"


@protocol ImageFieldDelegate;


@interface FORMThumbnailViewCell : FORMBaseFieldCell


@property (nonatomic, weak) id <ImageFieldDelegate>             imageDelegate;
@property (nonatomic) FormField                                 *formfield;

@property (nonatomic, assign) BOOL                              imageAdded;
@property (nonatomic, strong) UIImageView                       *thumbnailImageView;


- (void)setActiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setActiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setEnabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setValidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setValidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;


@end


@protocol ImageFieldDelegate <NSObject>

@optional

@end