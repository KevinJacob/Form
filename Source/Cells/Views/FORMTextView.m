//
//  FORMTextView.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-22.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMTextView.h"
#import "FORMTextViewCell.h"
#import "FORMTextViewTypeManager.h"


static const CGFloat FORMTextViewClearButtonWidth = 30.0f;
static const CGFloat FORMTextViewClearButtonHeight = 20.0f;

static UIColor *activeBackgroundColor;
static UIColor *activeBorderColor;
static UIColor *inactiveBackgroundColor;
static UIColor *inactiveBorderColor;

static UIColor *enabledBackgroundColor;
static UIColor *enabledBorderColor;
static UIColor *enabledTextColor;
static UIColor *disabledBackgroundColor;
static UIColor *disabledBorderColor;
static UIColor *disabledTextColor;

static UIColor *validBackgroundColor;
static UIColor *validBorderColor;
static UIColor *invalidBackgroundColor;
static UIColor *invalidBorderColor;

static BOOL enabledProperty;


@interface FORMTextView () <UITextViewDelegate>

@property (nonatomic, getter = isModified) BOOL         modified;
@property (nonatomic, weak) IBOutlet UIButton           *clearButton;

@end


@implementation FORMTextView

@synthesize rawText = _rawText;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Set Up
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.delegate = self;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSString *bundlePath = [[[NSBundle bundleForClass:self.class] resourcePath] stringByAppendingPathComponent:@"Form.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];
    
    UITraitCollection *trait = [UITraitCollection traitCollectionWithDisplayScale:2.0];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setImage:[UIImage imageNamed:@"forms_clear"
                                     inBundle:bundle
                compatibleWithTraitCollection:trait] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.frame = CGRectMake(self.frame.size.width - FORMTextViewClearButtonWidth, 12, FORMTextViewClearButtonWidth, FORMTextViewClearButtonHeight);
    self.clearButton.hidden = YES;
    
    [self addSubview:self.clearButton];
    
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.clearButton.frame = CGRectMake(self.frame.size.width - FORMTextViewClearButtonWidth, 12, FORMTextViewClearButtonWidth, FORMTextViewClearButtonHeight);
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Setters
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSRange)currentRange
{
    NSInteger startOffset = [self offsetFromPosition:self.beginningOfDocument
                                          toPosition:self.selectedTextRange.start];
    NSInteger endOffset = [self offsetFromPosition:self.beginningOfDocument
                                        toPosition:self.selectedTextRange.end];
    NSRange range = NSMakeRange(startOffset, endOffset-startOffset);
    
    return range;
}



- (void)setText:(NSString *)text
{
    UITextRange *textRange = self.selectedTextRange;
    NSString *newRawText = [self.formatter formatString:text
                                                reverse:YES];
    NSRange range = [self currentRange];
    
    BOOL didAddText  = (newRawText.length > self.rawText.length);
    BOOL didFormat   = (text.length > super.text.length);
    BOOL cursorAtEnd = (newRawText.length == range.location);
    
    if ((didAddText && didFormat) || (didAddText && cursorAtEnd))
    {
        self.selectedTextRange = textRange;
        [super setText:text];
    }
    else
    {
        [super setText:text];
        self.selectedTextRange = textRange;
    }
}



- (void)setRawText:(NSString *)rawText
{
    BOOL shouldFormat = (self.formatter && (rawText.length >= _rawText.length ||
                                            ![rawText isEqualToString:_rawText]));
    
    if (shouldFormat)
    {
        self.text = [self.formatter formatString:rawText reverse:NO];
    }
    else
    {
        self.text = rawText;
    }
    
    _rawText = rawText;
}



- (void)setTypeString:(NSString *)typeString
{
    _typeString = typeString;
    
    FORMTextViewType type;
    if ([typeString isEqualToString:@"name"]) {
        type = FORMTextViewTypeName;
    } else if ([typeString isEqualToString:@"username"]) {
        type = FORMTextViewTypeUsername;
    } else if ([typeString isEqualToString:@"phone"]) {
        type = FORMTextViewTypePhoneNumber;
    } else if ([typeString isEqualToString:@"number"]) {
        type = FORMTextViewTypeNumber;
    } else if ([typeString isEqualToString:@"float"]) {
        type = FORMTextViewTypeFloat;
    } else if ([typeString isEqualToString:@"address"]) {
        type = FORMTextViewTypeAddress;
    } else if ([typeString isEqualToString:@"email"]) {
        type = FORMTextViewTypeEmail;
    } else if ([typeString isEqualToString:@"select"]) {
        type = FORMTextViewTypeSelect;
    } else if ([typeString isEqualToString:@"text"]) {
        type = FORMTextViewTypeDefault;
    } else if ([typeString isEqualToString:@"password"]) {
        type = FORMTextViewTypePassword;
    } else if (!typeString.length) {
        type = FORMTextViewTypeDefault;
    } else {
        type = FORMTextViewTypeUnknown;
    }
    
    self.type = type;
}



- (void)setInputTypeString:(NSString *)inputTypeString
{
    _inputTypeString = inputTypeString;
    
    FORMTextViewInputType inputType;
    if ([inputTypeString isEqualToString:@"name"]) {
        inputType = FORMTextViewInputTypeName;
    } else if ([inputTypeString isEqualToString:@"username"]) {
        inputType = FORMTextViewInputTypeUsername;
    } else if ([inputTypeString isEqualToString:@"phone"]) {
        inputType = FORMTextViewInputTypePhoneNumber;
    } else if ([inputTypeString isEqualToString:@"number"]) {
        inputType = FORMTextViewInputTypeNumber;
    } else if ([inputTypeString isEqualToString:@"float"]) {
        inputType = FORMTextViewInputTypeFloat;
    } else if ([inputTypeString isEqualToString:@"address"]) {
        inputType = FORMTextViewInputTypeAddress;
    } else if ([inputTypeString isEqualToString:@"email"]) {
        inputType = FORMTextViewInputTypeEmail;
    } else if ([inputTypeString isEqualToString:@"text"]) {
        inputType = FORMTextViewInputTypeDefault;
    } else if ([inputTypeString isEqualToString:@"password"]) {
        inputType = FORMTextViewInputTypePassword;
    } else if (!inputTypeString.length) {
        inputType = FORMTextViewInputTypeDefault;
    } else {
        inputType = FORMTextViewInputTypeUnknown;
    }
    
    self.inputType = inputType;
}



- (void)setInputType:(FORMTextViewInputType)inputType
{
    _inputType = inputType;
    
    FORMTextViewTypeManager *typeManager = [FORMTextViewTypeManager new];
    [typeManager setUpType:inputType forTextView:self];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Getters
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSString *)rawText
{
    if (self.formatter)
    {
        return [self.formatter formatString:_rawText reverse:YES];
    }
    
    return _rawText;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - UITextViewDelegate
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (BOOL)textViewShouldBeginEditing:(FORMTextView *)textView
{
    self.clearButton.hidden = NO;
    BOOL selectable = (textView.type == FORMTextViewTypeSelect);
    
    if (selectable && [self.textViewDelegate respondsToSelector:@selector(textFormViewDidBeginEditing:)])
    {
        [self.textViewDelegate textFormViewDidBeginEditing:self];
    }
    
    return !selectable;
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.active = YES;
    self.modified = NO;
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.clearButton.hidden = YES;
    self.active = NO;
    if ([self.textViewDelegate respondsToSelector:@selector(textFormViewDidEndEditing:)])
    {
        [self.textViewDelegate textFormViewDidEndEditing:self];
    }
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(self.maxLength)
    {
        if((textView.text.length + text.length) > [self.maxLength integerValue])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}



-(void)textViewDidChange:(UITextView *)textView
{
    if (!self.isValid)
    {
        self.valid = YES;
    }
    
    self.modified = YES;
    self.rawText = self.text;
    
    if ([self.textViewDelegate respondsToSelector:@selector(textFormView:didUpdateWithText:)])
    {
        [self.textViewDelegate textFormView:self
                          didUpdateWithText:self.rawText];
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - UIResponder Overwritables
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (BOOL)becomeFirstResponder
{
    if ([self.textViewDelegate respondsToSelector:@selector(textFormViewDidBeginEditing:)])
    {
        [self.textViewDelegate textFormViewDidBeginEditing:self];
    }
    
    return [super becomeFirstResponder];
}



- (BOOL)canBecomeFirstResponder
{
    BOOL isTextView = (self.type != FORMTextViewTypeSelect);
    
    return (isTextView && enabledProperty) ?: [super canBecomeFirstResponder];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Actions
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)clearButtonAction
{
    self.rawText = nil;
    
    if ([self.textViewDelegate respondsToSelector:@selector(textFormView:didUpdateWithText:)])
    {
        [self.textViewDelegate textFormView:self
                            didUpdateWithText:self.rawText];
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Appearance
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)setActive:(BOOL)active
{
    _active = active;
    
    if (active)
    {
        self.backgroundColor = activeBackgroundColor;
        self.layer.borderColor = activeBorderColor.CGColor;
    }
    else
    {
        self.backgroundColor = inactiveBackgroundColor;
        self.layer.borderColor = inactiveBorderColor.CGColor;
    }
}



- (void)setEnabled:(BOOL)enabled
{
    self.userInteractionEnabled = enabled;
    
    if (enabled)
    {
        self.backgroundColor = enabledBackgroundColor;
        self.layer.borderColor = enabledBorderColor.CGColor;
        self.textColor = enabledTextColor;
    }
    else
    {
        self.backgroundColor = disabledBackgroundColor;
        self.layer.borderColor = disabledBorderColor.CGColor;
        self.textColor = disabledTextColor;
    }
}



- (void)setValid:(BOOL)valid
{
    _valid = valid;
    
    if (!self.userInteractionEnabled) return;
    
    if (valid)
    {
        self.backgroundColor = validBackgroundColor;
        self.layer.borderColor = validBorderColor.CGColor;
    }
    else
    {
        self.backgroundColor = invalidBackgroundColor;
        self.layer.borderColor = invalidBorderColor.CGColor;
    }
}



- (void)setCustomFont:(UIFont *)font
{
    self.font = font;
}



- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}



- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}



- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}



- (void)setActiveBackgroundColor:(UIColor *)color
{
    activeBackgroundColor = color;
}



- (void)setActiveBorderColor:(UIColor *)color
{
    activeBorderColor = color;
}



- (void)setInactiveBackgroundColor:(UIColor *)color
{
    inactiveBackgroundColor = color;
}



- (void)setInactiveBorderColor:(UIColor *)color
{
    inactiveBorderColor = color;
}



- (void)setEnabledBackgroundColor:(UIColor *)color
{
    enabledBackgroundColor = color;
}



- (void)setEnabledBorderColor:(UIColor *)color
{
    enabledBorderColor = color;
}



- (void)setEnabledTextColor:(UIColor *)color
{
    enabledTextColor = color;
}



- (void)setDisabledBackgroundColor:(UIColor *)color
{
    disabledBackgroundColor = color;
}



- (void)setDisabledBorderColor:(UIColor *)color
{
    disabledBorderColor = color;
}



- (void)setDisabledTextColor:(UIColor *)color
{
    disabledTextColor = color;
}



- (void)setValidBackgroundColor:(UIColor *)color
{
    validBackgroundColor = color;
}



- (void)setValidBorderColor:(UIColor *)color
{
    validBorderColor = color;
}



- (void)setInvalidBackgroundColor:(UIColor *)color
{
    invalidBackgroundColor = color;
}



- (void)setInvalidBorderColor:(UIColor *)color
{
    invalidBorderColor = color;
}


@end
