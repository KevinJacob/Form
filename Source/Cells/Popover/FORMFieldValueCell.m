#import "FORMFieldValueCell.h"

#import "FORMFieldValue.h"

@implementation FORMFieldValueCell

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    
    
    self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.detailTextLabel.numberOfLines = 0;

    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.backgroundColor = [UIColor whiteColor];
    self.separatorInset = UIEdgeInsetsZero;

    UIView *selectedBackgroundView = [UIView new];
    self.selectedBackgroundView = selectedBackgroundView;
    self.separatorInset = UIEdgeInsetsZero;

    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setImage:[UIImage imageNamed:@"checkmarkCircleIcon"] forState:UIControlStateNormal];
    selectedButton.frame = CGRectMake(self.frame.size.width - 40, 7, 30, 30);
    selectedButton.hidden = YES;
    self.selectedButton = selectedButton;
    [self.contentView addSubview:selectedButton];
    
    return self;
}


#pragma mark - Setters

- (void)setFieldValue:(FORMFieldValue *)fieldValue {
    _fieldValue = fieldValue;

    self.textLabel.text = fieldValue.title;
    self.selectedButton.hidden = !fieldValue.selected;

    if (fieldValue.info) {
        self.detailTextLabel.text = fieldValue.info;
    }
    else
    {
       self.detailTextLabel.text = nil;
    }
}

#pragma mark - Overwritables

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

#pragma mark - Styling

- (void)setTextLabelFont:(UIFont *)font {
    self.textLabel.font = font;
}

- (void)setTextLabelColor:(UIColor *)textColor {
    self.textLabel.textColor = textColor;
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.textLabel.highlightedTextColor = highlightedTextColor;
}

- (void)setDetailTextLabelFont:(UIFont *)font {
    self.detailTextLabel.font = font;
}

- (void)setDetailTextLabelColor:(UIColor *)textColor {
    self.detailTextLabel.textColor = textColor;
}

- (void)setDetailTextLabelHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.detailTextLabel.highlightedTextColor = highlightedTextColor;
}

- (void)setSelectedBackgroundViewColor:(UIColor *)backgroundColor {
    self.selectedBackgroundView.backgroundColor = backgroundColor;
}

- (void)setSelectedBackgroundFontColor:(UIColor *)fontColor {
    self.textLabel.highlightedTextColor = fontColor;
}

@end
