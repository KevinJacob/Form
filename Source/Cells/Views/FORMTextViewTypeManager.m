//
//  FORMTextViewTypeManager.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-22.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMTextViewTypeManager.h"

@implementation FORMTextViewTypeManager


- (void)setUpType:(FORMTextViewInputType)type forTextView:(UITextView *)textView
{
    switch (type)
    {
        case FORMTextViewInputTypeDefault     : [self setupDefaultTextView:textView]; break;
        case FORMTextViewInputTypeName        : [self setupNameTextView:textView]; break;
        case FORMTextViewInputTypeUsername    : [self setupUsernameTextView:textView]; break;
        case FORMTextViewInputTypePhoneNumber : [self setupPhoneNumberTextView:textView]; break;
        case FORMTextViewInputTypeNumber      : [self setupNumberTextView:textView]; break;
        case FORMTextViewInputTypeFloat       : [self setupNumberTextView:textView]; break;
        case FORMTextViewInputTypeAddress     : [self setupAddressTextView:textView]; break;
        case FORMTextViewInputTypeEmail       : [self setupEmailTextView:textView]; break;
        case FORMTextViewInputTypePassword    : [self setupPasswordTextView:textView]; break;
            
        case FORMTextViewInputTypeUnknown:
            abort();
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMTextViewType
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)setupDefaultTextView:(UITextView *)textView
{
    textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    textView.autocorrectionType = UITextAutocorrectionTypeDefault;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.secureTextEntry = NO;
}



- (void)setupNameTextView:(UITextView *)textView
{
    textView.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.secureTextEntry = NO;
}



- (void)setupUsernameTextView:(UITextView *)textView
{
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.keyboardType = UIKeyboardTypeNamePhonePad;
    textView.secureTextEntry = NO;
}



- (void)setupPhoneNumberTextView:(UITextView *)textView
{
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.keyboardType = UIKeyboardTypePhonePad;
    textView.secureTextEntry = NO;
}



- (void)setupNumberTextView:(UITextView *)textView
{
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.keyboardType = UIKeyboardTypeNumberPad;
    textView.secureTextEntry = NO;
}



- (void)setupAddressTextView:(UITextView *)textView
{
    textView.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textView.autocorrectionType = UITextAutocorrectionTypeDefault;
    textView.keyboardType = UIKeyboardTypeASCIICapable;
    textView.secureTextEntry = NO;
}



- (void)setupEmailTextView:(UITextView *)textView
{
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.keyboardType = UIKeyboardTypeEmailAddress;
    textView.secureTextEntry = NO;
}



- (void)setupPasswordTextView:(UITextView *)textView
{
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.keyboardType = UIKeyboardTypeASCIICapable;
    textView.secureTextEntry = YES;
}


@end
