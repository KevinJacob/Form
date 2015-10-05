//
//  FormTextViewCell.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-22.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMTextViewCell.h"

#import "UIView+FrameUtils.h"
#import "FORMTooltipView.h"


static NSString * const FORMHideTooltips = @"FORMHideTooltips";
static NSString * const FORMResignFirstResponderNotification = @"FORMResignFirstResponderNotification";
static NSString * const FORMDismissTooltipNotification = @"FORMDismissTooltipNotification";
static NSString * const FORMTextFieldCellIdentifier = @"FORMTextFieldCellIdentifier";


static const CGFloat FORMTooltipViewMinimumWidth = 90.0f;
static const CGFloat FORMTooltipViewHeight = 44.0f;
static const NSInteger FORMTooltipNumberOfLines = 4;

static const CGFloat FORMTextViewTopMargin = 30.0f;
static const CGFloat FORMTextViewMargin = 10.0f;

static const CGFloat FORMTextViewInsideMargin = 12.0f;


@interface FORMTextViewCell () <FORMTextViewDelegate>

@property (nonatomic) FORMFields                *formField;

@property (nonatomic) FORMTextView              *textView;
@property (nonatomic) UIPopoverController       *popoverController;
@property (nonatomic) UILabel                   *tooltipLabel;
@property (nonatomic) FORMTooltipView           *tooltipView;
@property (nonatomic) BOOL                      showTooltips;

@end


@implementation FORMTextViewCell


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Set Up
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.textView = [[FORMTextView alloc] initWithFrame:[self textViewFrame]];
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 5, 10, 25);
    self.textView.textViewDelegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.showsVerticalScrollIndicator   = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.contentInset = UIEdgeInsetsZero;
    
    [self.contentView addSubview:self.textView];
    
    if ([self respondsToSelector:@selector(resignFirstResponder)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resignFirstResponder)
                                                     name:FORMResignFirstResponderNotification
                                                   object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissTooltip)
                                                 name:FORMDismissTooltipNotification
                                               object:nil];
    
    /*
     Commented out to avoid overriding SceneDocFormViewController tap gesture which dismisses keyboard
     
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapAction)];
    [self addGestureRecognizer:tapGestureRecognizer];
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTooltip:)
                                                 name:FORMHideTooltips
                                               object:nil];
    
    return self;
}



- (void)dealloc
{
    if ([self respondsToSelector:@selector(dismissTooltip)])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:FORMResignFirstResponderNotification
                                                      object:nil];
    }
    
    if ([self respondsToSelector:@selector(showTooltip:)])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:FORMHideTooltips
                                                      object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FORMDismissTooltipNotification
                                                  object:nil];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Getters
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


- (CGRect)labelFrameUsingString:(NSString *)string
{
    NSArray *components = [string componentsSeparatedByString:@"\n"];
    
    CGFloat width;
    
    if (components.count > 1)
    {
        NSString *longestLine;
        for (NSString *line in components)
        {
            if (longestLine)
            {
                if (line.length > longestLine.length)
                {
                    longestLine = line;
                }
            }
            else
            {
                longestLine = line;
            }
        }
        width = 8.0f * longestLine.length;
    }
    else
    {
        width = 8.0f * string.length;
    }
    
    if (width < FORMTooltipViewMinimumWidth) width = FORMTooltipViewMinimumWidth;
    
    CGFloat height = FORMTooltipViewHeight;
    height += 11.0f * components.count;
    
    return CGRectMake(0, 0, width, height);
}



- (CGRect)tooltipViewFrame
{
    CGRect frame = [self labelFrameUsingString:self.field.info];
    
    frame.size.height += [FORMTooltipView arrowHeight];
    frame.origin.x = self.textView.frame.origin.x;
    frame.origin.y = self.textView.frame.origin.y;
    
    frame.origin.x += self.textView.frame.size.width / 2 - frame.size.width / 2;
    
    if ([self.field.sectionPosition isEqualToNumber:@0]) {
        self.tooltipView.arrowDirection = UIPopoverArrowDirectionUp;
        frame.origin.y += self.textView.frame.size.height / 2;
    } else {
        self.tooltipView.arrowDirection = UIPopoverArrowDirectionDown;
        frame.origin.y -= self.textView.frame.size.height / 2;
        frame.origin.y -= frame.size.height;
    }
    
    frame.origin.y += [FORMTooltipView arrowHeight];
    
    return frame;
}



- (FORMTooltipView *)tooltipView
{
    if (_tooltipView) return _tooltipView;
    
    _tooltipView = [FORMTooltipView new];
    [_tooltipView addSubview:self.tooltipLabel];
    
    return _tooltipView;
}



- (CGRect)tooltipLabelFrame
{
    CGRect frame = [self labelFrameUsingString:self.field.info];
    
    if (self.tooltipView.arrowDirection == UIPopoverArrowDirectionUp) {
        frame.origin.y += [FORMTooltipView arrowHeight];
    }
    
    return frame;
}



- (UILabel *)tooltipLabel
{
    if (_tooltipLabel) return _tooltipLabel;
    
    _tooltipLabel = [[UILabel alloc] initWithFrame:[self labelFrameUsingString:@""]];
    
    _tooltipLabel.textAlignment = NSTextAlignmentCenter;
    _tooltipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _tooltipLabel.numberOfLines = FORMTooltipNumberOfLines;
    
    return _tooltipLabel;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Layout
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textView.frame = [self textViewFrame];
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 5, 10, 25);
    
    [self validate];
}



- (CGRect)textViewFrame
{
    CGFloat marginX = FORMTextViewMargin;
    CGFloat marginTop = FORMTextViewTopMargin;
    
    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = [self getHeightForTextView:self.textView]  + (FORMTextViewInsideMargin * 2);
    CGRect  frame  = CGRectMake(marginX, self.frame.size.height - height - marginTop, width, height);
    
    return frame;
}



- (CGFloat)getHeightForTextView:(UITextView *)myTextView
{
    NSString *textToMeasure;
    
    if(myTextView.text.length > 0)
    {
        textToMeasure = myTextView.text;
    }
    else
    {
        textToMeasure = @" ";
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textToMeasure attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(myTextView.frame.size.width*0.95, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGFloat textViewHeight = rect.size.height;
    
    return textViewHeight;
}



- (void)showTooltip
{
    if (self.field.info && self.showTooltips)
    {
        self.tooltipView.alpha = 0.0f;
        [self.contentView addSubview:self.tooltipView];
        self.tooltipView.frame = [self tooltipViewFrame];
        self.tooltipLabel.frame = [self tooltipLabelFrame];
        [self.superview bringSubviewToFront:self];
        
        CGRect tooltipViewFrame = self.tooltipView.frame;
        
        if (self.tooltipView.frame.origin.x < 0)
        {
            self.tooltipView.arrowOffset = tooltipViewFrame.origin.x;
            tooltipViewFrame.origin.x = 0;
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.field.info];
        NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
        paragrahStyle.alignment = NSTextAlignmentCenter;
        paragrahStyle.lineSpacing = 8;
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragrahStyle
                                 range:NSMakeRange(0, self.field.info.length)];
        
        self.tooltipLabel.attributedText = attributedString;
        
        CGFloat windowWidth = self.window.frame.size.width;
        BOOL isOutOfBounds = ((tooltipViewFrame.size.width + self.frame.origin.x) > windowWidth);
        if (isOutOfBounds)
        {
            tooltipViewFrame.origin.x = windowWidth;
            tooltipViewFrame.origin.x -= tooltipViewFrame.size.width;
            tooltipViewFrame.origin.x -= self.frame.origin.x;
            
            self.tooltipView.arrowOffset = tooltipViewFrame.size.width / 2;
            self.tooltipView.arrowOffset -= self.textView.frame.size.width / 2;
            self.tooltipView.arrowOffset -= 39.0f;
        }
        
        self.tooltipView.frame = tooltipViewFrame;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.tooltipView.alpha = 1.0f;
        }];
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Actions
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)cellTapAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FORMDismissTooltipNotification object:nil];
    
    BOOL shouldDisplayTooltip = (self.field.type == FORMFieldTypeMultilineText &&
                                 self.field.info);
    if (shouldDisplayTooltip)
    {
        [self showTooltip];
    }
}



- (void)focusAction
{
    [self.textView becomeFirstResponder];
}



- (void)clearAction
{
    self.field.value = nil;
    
    CGFloat initalHeight = self.textView.frame.size.height;
    self.textView.frame = [self textViewFrame];
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 5, 10, 25);
    CGFloat newHeight = self.textView.frame.size.height;
    
    if(initalHeight != newHeight && initalHeight != 1)
    {
        self.formField.size = CGSizeMake( self.formField.size.width , self.textView.frame.size.height + FORMFieldCellMarginTop + FORMFieldCellMarginBottom);
        [self.delegate reloadCollectionView];
    }
    
    [self updateWithField:self.field];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMTextViewDelegate
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)textFormViewDidBeginEditing:(FORMTextView *)textView
{
    [self.formTextViewCellDelegate beganEditing:self];
    //[self performSelector:@selector(showTooltip) withObject:nil afterDelay:0.1f];
}



- (void)textFormViewDidEndEditing:(FORMTextView *)textView
{
    [self validate];
    
    if (self.showTooltips)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FORMDismissTooltipNotification
                                                            object:nil];
    }
}



- (void)textFormView:(FORMTextView *)textView didUpdateWithText:(NSString *)text
{
    self.field.value = text;
    [self validate];
    
    CGFloat initalHeight = self.textView.frame.size.height;
    self.textView.frame = [self textViewFrame];
    [self sizeToFit];
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 5, 10, 25);
    CGFloat newHeight = self.textView.frame.size.height;
    self.formField.size = CGSizeMake( self.formField.size.width , self.textView.frame.size.height + FORMFieldCellMarginTop + FORMFieldCellMarginBottom);
    
    if(initalHeight != newHeight && initalHeight != 1)
    {
        [self.delegate reloadCollectionView];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)])
    {
        [self.delegate fieldCell:self
                updatedWithField:self.field];
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Styling
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)setTooltipLabelFont:(UIFont *)tooltipLabelFont
{
    self.tooltipLabel.font = tooltipLabelFont;
}



- (void)setTooltipLabelTextColor:(UIColor *)tooltipLabelTextColor
{
    self.tooltipLabel.textColor = tooltipLabelTextColor;
}



- (void)setTooltipBackgroundColor:(UIColor *)tooltipBackgroundColor
{
    [FORMTooltipView setTintColor:tooltipBackgroundColor];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Notifications
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)dismissTooltip
{
    if (self.field.info)
    {
        [self.tooltipView removeFromSuperview];
    }
}



- (void)showTooltip:(NSNotification *)notification
{
    self.showTooltips = [notification.object boolValue];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Private headers
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    
    return [super resignFirstResponder];
}



- (BOOL)becomeFirstResponder
{
    [self.textView becomeFirstResponder];
    
    return [super becomeFirstResponder];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Private methods
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSString *)rawTextForField:(FORMFields *)field
{
    NSString *rawText = field.value;
    
    if (field.value) {
        switch (field.type) {
            case FORMFieldTypeNumber:{
                if ([field.value isKindOfClass:[NSNumber class]]) {
                    NSNumber *value = field.value;
                    rawText = [value stringValue];
                }
            } break;
            case FORMFieldTypeFloat: {
                NSNumber *value = field.value;
                
                if ([field.value isKindOfClass:[NSString class]]) {
                    NSMutableString *fieldValue = [field.value mutableCopy];
                    [fieldValue replaceOccurrencesOfString:@","
                                                withString:@"."
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, [fieldValue length])];
                    NSNumberFormatter *formatter = [NSNumberFormatter new];
                    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
                    value = [formatter numberFromString:fieldValue];
                }
                
                rawText = [NSString stringWithFormat:@"%.2f", [value doubleValue]];
            } break;
            default: break;
        }
    }
    
    return rawText;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - UIMenuController addition
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(scanBarcode:))
    {
        return YES;
    }
    
    return [super canPerformAction:action withSender:sender];
}



- (void)scanBarcode:(id)sender
{
    if ([self.formTextViewCellDelegate respondsToSelector:@selector(scanBarcodeOperationTextView:)])
    {
        [self.formTextViewCellDelegate scanBarcodeOperationTextView:self];
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMBaseFormFieldCell
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textView.userInteractionEnabled       = !disabled;
}



- (void)updateWithField:(FORMFields *)field
{
    [super updateWithField:field];
    
    self.formField = field;
    
    self.textView.rawText                      = [self rawTextForField:field];
    self.textView.hidden                       = (field.sectionSeparator);
    self.textView.userInteractionEnabled       = !field.disabled;
    self.textView.maxLength                    = field.validation.maximumLength;
    [self.textView setEnabled:!field.disabled];
    [self validate];
    
    CGFloat initalHeight = self.textView.frame.size.height;
    self.textView.frame = [self textViewFrame];
    [self sizeToFit];
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 5, 10, 25);
    CGFloat newHeight = self.textView.frame.size.height;
    self.formField.size = CGSizeMake( self.formField.size.width , self.textView.frame.size.height + FORMFieldCellMarginTop + FORMFieldCellMarginBottom);
    
    if(initalHeight != newHeight && initalHeight != 1)
    {
        [self.delegate reloadCollectionView];
    }
}



- (void)validate {
    BOOL validation = ([self.field validate] == FORMValidationResultTypeValid);
    [self.textView setValid:validation];
}


@end