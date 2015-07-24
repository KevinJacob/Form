//
//  FORMTextView.h
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-22.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FORMInputValidator.h"
#import "FORMFormatter.h"


typedef NS_ENUM(NSInteger, FORMTextViewType)
{
    FORMTextViewTypeDefault = 0,
    FORMTextViewTypeName,
    FORMTextViewTypeUsername,
    FORMTextViewTypePhoneNumber,
    FORMTextViewTypeNumber,
    FORMTextViewTypeFloat,
    FORMTextViewTypeAddress,
    FORMTextViewTypeEmail,
    FORMTextViewTypePassword,
    FORMTextViewTypeSelect,
    FORMTextViewTypeUnknown
};

typedef NS_ENUM(NSInteger, FORMTextViewInputType)
{
    FORMTextViewInputTypeDefault = 0,
    FORMTextViewInputTypeName,
    FORMTextViewInputTypeUsername,
    FORMTextViewInputTypePhoneNumber,
    FORMTextViewInputTypeNumber,
    FORMTextViewInputTypeFloat,
    FORMTextViewInputTypeAddress,
    FORMTextViewInputTypeEmail,
    FORMTextViewInputTypePassword,
    FORMTextViewInputTypeUnknown
};


@protocol FORMTextViewDelegate;


@interface FORMTextView : UITextView


@property (nonatomic, copy) NSString                        *rawText;

@property (nonatomic) FORMInputValidator                    *inputValidator;
@property (nonatomic) FORMFormatter                         *formatter;

@property (nonatomic, copy) NSString                        *typeString;
@property (nonatomic) FORMTextViewType                      type;
@property (nonatomic, copy) NSString                        *inputTypeString;
@property (nonatomic) FORMTextViewInputType                 inputType;
@property (nonatomic, copy) NSString                        *info;

@property (nonatomic, getter = isValid)    BOOL             valid;
@property (nonatomic, getter = isActive)   BOOL             active;

@property (nonatomic, weak) id <FORMTextViewDelegate>      textViewDelegate;


- (void)setActive:(BOOL)active;
- (void)setEnabled:(BOOL)enabled;
- (void)setValid:(BOOL)valid;

- (void)setCustomFont:(UIFont *)font  UI_APPEARANCE_SELECTOR;
- (void)setBorderWidth:(CGFloat)borderWidth UI_APPEARANCE_SELECTOR;
- (void)setBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setCornerRadius:(CGFloat)cornerRadius UI_APPEARANCE_SELECTOR;

- (void)setActiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setActiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setEnabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;

- (void)setValidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setValidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;


@end

@protocol FORMTextViewDelegate <NSObject>

@optional

- (void)textFormViewDidBeginEditing:(FORMTextView *)textView;
- (void)textFormViewDidEndEditing:(FORMTextView *)textView;
- (void)textFormView:(FORMTextView *)textView didUpdateWithText:(NSString *)text;

@end
