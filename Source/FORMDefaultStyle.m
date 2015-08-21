#import "FORMDefaultStyle.h"

#import "FORMTextField.h"
#import "FORMBackgroundView.h"
#import "FORMSeparatorView.h"
#import "FORMFieldValueLabel.h"
#import "FORMFieldValueCell.h"
#import "FORMGroupHeaderView.h"
#import "FORMFieldValuesTableViewHeader.h"
#import "FORMTextFieldCell.h"
#import "FORMTextViewCell.h"
#import "FORMSignatureFieldCell.h"
#import "FORMThumbnailViewCell.h"
#import "FORMButtonFieldCell.h"
#import "FORMBaseFieldCell.h"

#import "UIColor+Hex.h"


@implementation FORMDefaultStyle

+ (void)applyStyle {
    [[FORMTextField appearance] setTextColor:[UIColor redColor]];
    [[FORMTextField appearance] setBackgroundColor:[UIColor yellowColor]];

    [[FORMBaseFieldCell appearance] setHeadingLabelFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]];
    [[FORMBaseFieldCell appearance] setHeadingLabelTextColor:[UIColor blackColor]];

    [[FORMBackgroundView appearance] setBackgroundColor:[UIColor clearColor]];

    [[FORMSeparatorView appearance] setBackgroundColor:[UIColor colorFromHex:@"C6C6C6"]];

    [[FORMButtonFieldCell appearance] setBackgroundColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMButtonFieldCell appearance] setTitleLabelFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0]];
    [[FORMButtonFieldCell appearance] setBorderWidth:1.0f];
    [[FORMButtonFieldCell appearance] setCornerRadius:5.0f];
    [[FORMButtonFieldCell appearance] setHighlightedTitleColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMButtonFieldCell appearance] setBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMButtonFieldCell appearance] setHighlightedBackgroundColor:[UIColor whiteColor]];
    [[FORMButtonFieldCell appearance] setTitleColor:[UIColor whiteColor]];

    [[FORMFieldValueCell appearance] setTextLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
    [[FORMFieldValueCell appearance] setTextLabelColor:[UIColor blackColor]];
    [[FORMFieldValueCell appearance] setDetailTextLabelHighlightedTextColor:[UIColor blackColor]];
    [[FORMFieldValueCell appearance] setDetailTextLabelFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14.0]];
    [[FORMFieldValueCell appearance] setDetailTextLabelColor:[UIColor blackColor]];
    [[FORMFieldValueCell appearance] setDetailTextLabelHighlightedTextColor:[UIColor blackColor]];
    [[FORMFieldValueCell appearance] setSelectedBackgroundViewColor:[UIColor whiteColor]];
    [[FORMFieldValueCell appearance] setSelectedBackgroundFontColor:[UIColor blackColor]];

    [[FORMTextField appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [[FORMTextField appearance] setTextColor:[UIColor blackColor]];
    [[FORMTextField appearance] setTintColor:[UIColor blackColor]];
    [[FORMTextField appearance] setBorderWidth:1.0f];
    [[FORMTextField appearance] setBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextField appearance] setCornerRadius:5.0f];
    [[FORMTextField appearance] setActiveBackgroundColor:[UIColor whiteColor]];
    [[FORMTextField appearance] setActiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextField appearance] setInactiveBackgroundColor:[UIColor whiteColor]];
    [[FORMTextField appearance] setInactiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextField appearance] setEnabledBackgroundColor:[UIColor whiteColor]];
    [[FORMTextField appearance] setEnabledBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextField appearance] setEnabledTextColor:[UIColor blackColor]];
    [[FORMTextField appearance] setDisabledBackgroundColor:[UIColor colorFromHex:@"F5F5F8"]];
    [[FORMTextField appearance] setDisabledBorderColor:[UIColor colorFromHex:@"DEDEDE"]];
    [[FORMTextField appearance] setDisabledTextColor:[UIColor blackColor]];
    [[FORMTextField appearance] setValidBackgroundColor:[UIColor whiteColor]];
    [[FORMTextField appearance] setValidBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextField appearance] setInvalidBackgroundColor:[UIColor colorFromHex:@"FFD7D7"]];
    [[FORMTextField appearance] setInvalidBorderColor:[UIColor colorFromHex:@"EC3031"]];
    
    [[FORMTextView appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [[FORMTextView appearance] setTextColor:[UIColor blackColor]];
    [[FORMTextView appearance] setTintColor:[UIColor blackColor]];
    [[FORMTextView appearance] setBorderWidth:1.0f];
    [[FORMTextView appearance] setBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextView appearance] setCornerRadius:5.0f];
    [[FORMTextView appearance] setActiveBackgroundColor:[UIColor whiteColor]];
    [[FORMTextView appearance] setActiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextView appearance] setInactiveBackgroundColor:[UIColor whiteColor]];
    [[FORMTextView appearance] setInactiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextView appearance] setEnabledBackgroundColor:[UIColor whiteColor]];
    [[FORMTextView appearance] setEnabledBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextView appearance] setEnabledTextColor:[UIColor blackColor]];
    [[FORMTextView appearance] setDisabledBackgroundColor:[UIColor colorFromHex:@"F5F5F8"]];
    [[FORMTextView appearance] setDisabledBorderColor:[UIColor colorFromHex:@"DEDEDE"]];
    [[FORMTextView appearance] setDisabledTextColor:[UIColor blackColor]];
    [[FORMTextView appearance] setValidBackgroundColor:[UIColor whiteColor]];
    [[FORMTextView appearance] setValidBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMTextView appearance] setInvalidBackgroundColor:[UIColor colorFromHex:@"FFD7D7"]];
    [[FORMTextView appearance] setInvalidBorderColor:[UIColor colorFromHex:@"EC3031"]];

    [[FORMSignatureFieldCell appearance] setActiveBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMSignatureFieldCell appearance] setActiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMSignatureFieldCell appearance] setInactiveBackgroundColor:[UIColor whiteColor]];
    [[FORMSignatureFieldCell appearance] setInactiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMSignatureFieldCell appearance] setEnabledBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMSignatureFieldCell appearance] setEnabledBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMSignatureFieldCell appearance] setDisabledBackgroundColor:[UIColor colorFromHex:@"F5F5F8"]];
    [[FORMSignatureFieldCell appearance] setDisabledBorderColor:[UIColor colorFromHex:@"DEDEDE"]];
    [[FORMSignatureFieldCell appearance] setValidBackgroundColor:[UIColor whiteColor]];
    [[FORMSignatureFieldCell appearance] setValidBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMSignatureFieldCell appearance] setInvalidBackgroundColor:[UIColor colorFromHex:@"FFD7D7"]];
    [[FORMSignatureFieldCell appearance] setInvalidBorderColor:[UIColor colorFromHex:@"EC3031"]];
    
    [[FORMThumbnailViewCell appearance] setActiveBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMThumbnailViewCell appearance] setActiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMThumbnailViewCell appearance] setInactiveBackgroundColor:[UIColor whiteColor]];
    [[FORMThumbnailViewCell appearance] setInactiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMThumbnailViewCell appearance] setEnabledBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMThumbnailViewCell appearance] setEnabledBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMThumbnailViewCell appearance] setDisabledBackgroundColor:[UIColor colorFromHex:@"F5F5F8"]];
    [[FORMThumbnailViewCell appearance] setDisabledBorderColor:[UIColor colorFromHex:@"DEDEDE"]];
    [[FORMThumbnailViewCell appearance] setValidBackgroundColor:[UIColor whiteColor]];
    [[FORMThumbnailViewCell appearance] setValidBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMThumbnailViewCell appearance] setInvalidBackgroundColor:[UIColor colorFromHex:@"FFD7D7"]];
    [[FORMThumbnailViewCell appearance] setInvalidBorderColor:[UIColor colorFromHex:@"EC3031"]];
    
    [[FORMFieldValueLabel appearance] setCustomFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [[FORMFieldValueLabel appearance] setTextColor:[UIColor blackColor]];
    [[FORMFieldValueLabel appearance] setBorderWidth:1.0f];
    [[FORMFieldValueLabel appearance] setBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMFieldValueLabel appearance] setCornerRadius:5.0f];
    [[FORMFieldValueLabel appearance] setActiveBackgroundColor:[UIColor colorFromHex:@"E5F4F5"]];
    [[FORMFieldValueLabel appearance] setActiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMFieldValueLabel appearance] setInactiveBackgroundColor:[UIColor whiteColor]];
    [[FORMFieldValueLabel appearance] setInactiveBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMFieldValueLabel appearance] setEnabledBackgroundColor:[UIColor whiteColor]];
    [[FORMFieldValueLabel appearance] setEnabledBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMFieldValueLabel appearance] setEnabledTextColor:[UIColor blackColor]];
    [[FORMFieldValueLabel appearance] setDisabledBackgroundColor:[UIColor colorFromHex:@"F5F5F8"]];
    [[FORMFieldValueLabel appearance] setDisabledBorderColor:[UIColor colorFromHex:@"DEDEDE"]];
    [[FORMFieldValueLabel appearance] setDisabledTextColor:[UIColor grayColor]];
    [[FORMFieldValueLabel appearance] setValidBackgroundColor:[UIColor whiteColor]];
    [[FORMFieldValueLabel appearance] setValidBorderColor:[UIColor colorFromHex:@"1A242F"]];
    [[FORMFieldValueLabel appearance] setInvalidBackgroundColor:[UIColor colorFromHex:@"FFD7D7"]];
    [[FORMFieldValueLabel appearance] setInvalidBorderColor:[UIColor colorFromHex:@"EC3031"]];

    [[FORMGroupHeaderView appearance] setHeaderLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
    [[FORMGroupHeaderView appearance] setHeaderLabelTextColor:[UIColor whiteColor]];
    [[FORMGroupHeaderView appearance] setHeaderBackgroundColor:[UIColor colorFromHex:@"1A242F"]];

    [[FORMFieldValuesTableViewHeader appearance] setTitleLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
    [[FORMFieldValuesTableViewHeader appearance] setTitleLabelTextColor:[UIColor whiteColor]];
    [[FORMFieldValuesTableViewHeader appearance] setInfoLabelFont:[UIFont fontWithName:@"AvenirNext-UltraLight" size:17.0]];
    [[FORMFieldValuesTableViewHeader appearance] setInfoLabelTextColor:[UIColor whiteColor]];

    [[FORMTextFieldCell appearance] setTooltipLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]];
    [[FORMTextFieldCell appearance] setTooltipLabelTextColor:[UIColor blackColor]];
    [[FORMTextFieldCell appearance] setTooltipBackgroundColor:[UIColor colorFromHex:@"E5F4F5"]];
    
    [[FORMTextViewCell appearance] setTooltipLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]];
    [[FORMTextViewCell appearance] setTooltipLabelTextColor:[UIColor blackColor]];
    [[FORMTextViewCell appearance] setTooltipBackgroundColor:[UIColor colorFromHex:@"E5F4F5"]];
}

@end
