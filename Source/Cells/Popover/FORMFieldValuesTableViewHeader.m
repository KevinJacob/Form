#import "FORMFieldValuesTableViewHeader.h"

#import "FORMFieldValueCell.h"

#import "UIColor+Hex.h"

@interface FORMFieldValuesTableViewHeader ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *infoLabel;

@end

@implementation FORMFieldValuesTableViewHeader

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorFromHex:@"1A242F"];
        view;
    });
    [self addSubview:self.titleLabel];
    [self addSubview:self.infoLabel];

    return self;
}

#pragma mark - Getters

- (CGRect)titleLabelFrame {
    return CGRectMake(0.0f, FORMTitleLabelY, FORMFieldValuesHeaderWidth, FORMLabelHeight);
}

- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;

    _titleLabel = [[UILabel alloc] initWithFrame:[self titleLabelFrame]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = self.field.value;

    return _titleLabel;
}

- (CGRect)infoLabelFrame
{
    CGFloat y = CGRectGetMaxY(self.titleLabel.frame);

    return CGRectMake(0.0f, y, FORMFieldValuesHeaderWidth, FORMLabelHeight * 1.1);
}

- (UILabel *)infoLabel {
    if (_infoLabel) return _infoLabel;

    _infoLabel = [[UILabel alloc] initWithFrame:[self infoLabelFrame]];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.numberOfLines = 0;
    _infoLabel.text = self.field.info;

    return _infoLabel;
}

- (CGFloat)labelHeight
{
    CGFloat height = 0.0f;
    height += self.titleLabel.frame.origin.y * 2;
    height += [self getHeightForTextView:self.titleLabel.text withWidth:self.frame.size.width];
    height += self.infoLabel.frame.size.height;

    return height;
}

- (CGFloat)getHeightForTextView:(NSString *)myTextView withWidth:(CGFloat)width
{
    NSString *textToMeasure;
    
    if(myTextView.length > 0)
    {
        textToMeasure = myTextView;
    }
    else
    {
        textToMeasure = @" ";
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textToMeasure attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]}];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(width*0.95, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGFloat textViewHeight = rect.size.height;
    
    return textViewHeight;
}

#pragma mark - Setters

- (void)setField:(FORMFields *)field {
    _field = field;

    self.titleLabel.text = field.title;
    self.infoLabel.text = field.info;

}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    self.titleLabel.font = titleLabelFont;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor {
    self.titleLabel.textColor = titleLabelTextColor;
}

- (void)setInfoLabelFont:(UIFont *)infoLabelFont {
    self.infoLabel.font = infoLabelFont;
}

- (void)setInfoLabelTextColor:(UIColor *)infoLabelTextColor {
    self.infoLabel.textColor = infoLabelTextColor;
}

#pragma marks - Private methods

- (void)updateLabelFrames:(CGFloat)width
{
    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.width = width;
    self.titleLabel.frame = titleFrame;
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.infoLabel sizeToFit];
    CGRect infoFrame = self.infoLabel.frame;
    infoFrame.origin.y = [self infoLabelFrame].origin.y;
    infoFrame.size.width = width;
    self.infoLabel.frame = infoFrame;
    //self.infoLabel.textAlignment = NSTextAlignmentCenter;
}

@end
