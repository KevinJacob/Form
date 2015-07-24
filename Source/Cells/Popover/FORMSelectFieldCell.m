#import "FORMSelectFieldCell.h"

#import "FORMFieldValue.h"

static const NSInteger FORMSelectMaxItemCount = 6;

static const CGFloat FORMTextViewTopMargin = 30.0f;
static const CGFloat FORMTextViewMargin = 10.0f;

static const CGFloat FORMTextViewInsideMargin = 12.0f;

@interface FORMSelectFieldCell () <FORMTextFieldDelegate, FORMFieldValuesTableViewControllerDelegate, FORMTextViewDelegate>

@end

@implementation FORMSelectFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:[self popoverSize]];
    if (!self) return nil;

    NSString *bundlePath = [[[NSBundle bundleForClass:self.class] resourcePath] stringByAppendingPathComponent:@"Form.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];

    UITraitCollection *trait = [UITraitCollection traitCollectionWithDisplayScale:2.0];
    self.iconImageView.image = [UIImage imageNamed:@"forms_arrow_down"
                                          inBundle:bundle
                     compatibleWithTraitCollection:trait];
    
    return self;
}

#pragma mark - Layout

- (CGRect)textViewFrameWithText:(NSString *)string
{
    CGFloat marginX = FORMTextViewMargin;
    CGFloat marginTop = FORMTextViewTopMargin;
    
    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = [self getHeightForTextView:string withWidth:width] + (FORMTextViewInsideMargin * 2);
    CGRect  frame  = CGRectMake(marginX, marginTop, width, height);
    
    return frame;
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
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textToMeasure attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(width*0.95, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGFloat textViewHeight = rect.size.height;
    
    return textViewHeight;
}


#pragma mark - Getters

- (FORMFieldValuesTableViewController *)fieldValuesController {
    if (_fieldValuesController) return _fieldValuesController;

    _fieldValuesController = [FORMFieldValuesTableViewController new];
    _fieldValuesController.delegate = self;

    return _fieldValuesController;
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateWithField:(FORMFields *)field {
    [super updateWithField:field];

    if (field.value) {
        if ([field.value isKindOfClass:[FORMFieldValue class]]) {
            FORMFieldValue *fieldValue = (FORMFieldValue *)field.value;
            self.valueView.text = fieldValue.title;
        } else {
            self.valueView.text = nil;

            for (FORMFieldValue *fieldValue in field.values) {
                if ([fieldValue identifierIsEqualTo:field.value]) {
                    field.value = fieldValue;
                    self.valueView.text = fieldValue.title;
                    break;
                }
            }
        }
    } else {
        self.valueView.text = nil;
    }
}

#pragma mark - FORMPopoverFormFieldCell

- (void)updateContentViewController:(UIViewController *)contentViewController
                          withField:(FORMFields *)field {
    self.fieldValuesController.field = self.field;

    if (self.field.values.count <= FORMSelectMaxItemCount) {
        CGSize currentSize = [self popoverSize];
        CGFloat headerViewHeight = self.fieldValuesController.headerView.frame.size.height;
        CGFloat labelHeight = round(self.fieldValuesController.headerView.labelHeight);
        CGSize customSize = CGSizeMake(currentSize.width, (FORMFieldValuesCellHeight * self.field.values.count) + labelHeight + headerViewHeight + FORMTitleLabelY);

        self.fieldValuesController.preferredContentSize = customSize;
    }
}

#pragma mark - FORMFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(FORMFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(FORMFieldValue *)selectedValue {
    self.field.value = selectedValue;

    CGFloat initalHeight = self.valueView.frame.size.height;
    self.valueView.frame = [self textViewFrameWithText:selectedValue.title];
    self.valueView.textContainerInset = UIEdgeInsetsMake(12, 5, 10, 25);
    CGFloat newHeight = self.valueView.frame.size.height;
    
    if(initalHeight != newHeight && initalHeight != 1)
    {
        self.field.size = CGSizeMake( self.field.size.width , self.valueView.frame.size.height + FORMFieldCellMarginTop + FORMFieldCellMarginBottom);
        [self.delegate reloadCollectionView];
    }
    
    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

#pragma mark  - Helper

- (CGSize)popoverSize
{
    CGFloat percentage;
    
    if (IS_IPAD())
    {
        percentage = 0.60;
    }
    else
    {
        percentage = 0.60;
    }
    
    CGSize thumbSize = CGSizeMake ([UIScreen mainScreen].bounds.size.width*percentage,
                                   [UIScreen mainScreen].bounds.size.height*percentage);
    return (thumbSize);
}


@end
