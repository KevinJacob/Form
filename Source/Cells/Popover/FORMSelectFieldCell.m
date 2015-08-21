#import "FORMSelectFieldCell.h"
#import "FORMTextFieldCell.h"
#import "FORMFieldValue.h"

static const NSInteger FORMSelectMaxItemCount = 6;

static const CGFloat FORMTextViewTopMargin = 30.0f;
static const CGFloat FORMTextViewMargin = 10.0f;

static const CGFloat FORMTextViewInsideMargin = 12.0f;

@interface FORMSelectFieldCell () <FORMTextFieldDelegate, FORMFieldValuesTableViewControllerDelegate, FORMTextViewDelegate, UIPopoverPresentationControllerDelegate>

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
    CGRect  frame  = CGRectMake(marginX, self.frame.size.height - height - marginTop, width, height);
    
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
            self.valueView.text = field.value;

            /*
            for (FORMFieldValue *fieldValue in field.values) {
                if ([fieldValue identifierIsEqualTo:field.value]) {
                    field.value = fieldValue;
                    self.valueView.text = fieldValue.title;
                    break;
                }
            }
             */
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
        
        self.fieldValuesController.preferredContentSize = currentSize;
        [self.fieldValuesController.headerView updateLabelFrames:currentSize.width];
        
        if(self.fieldValuesController.selectedCell)
        {
            self.fieldValuesController.selectedCell.clearButton.frame = CGRectMake(currentSize.width - 40, 7, 30, 30);
        }
        
        self.fieldValuesController.cancelButton.frame = CGRectMake(0, 0, 100, 35);
        self.fieldValuesController.clearButton.frame = CGRectMake(currentSize.width/2 - 50, 0, 100, 35);
        self.fieldValuesController.selectButton.frame = CGRectMake(currentSize.width - 100, 0, 100, 35);
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
    CGSize thumbSize;
    
    if (IS_IPAD())
    {
        thumbSize = CGSizeMake ([UIScreen mainScreen].bounds.size.width*0.8,
                                self.fieldValuesController.tableView.contentSize.height);
    }
    else
    {
        thumbSize = CGSizeMake ([UIScreen mainScreen].bounds.size.width*0.95,
                                self.fieldValuesController.tableView.contentSize.height);
    }
    
    return (thumbSize);
}


#pragma mark - Private methods

- (BOOL)becomeFirstResponder {
    [self titleLabelPressed:self.valueView];
    
    return [super becomeFirstResponder];
}


#pragma mark - FORMTitleLabelDelegate

- (void)titleLabelPressed:(FORMDropDownValueView *)titleLabel {
    [[NSNotificationCenter defaultCenter] postNotificationName:FORMResignFirstResponderNotification object:nil];
    
    [self updateContentViewController:self.fieldValuesController withField:self.field];
    
    if(IS_IPAD())
    {
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.fieldValuesController];
        [self.popoverController setPopoverContentSize:self.fieldValuesController.tableView.contentSize animated:YES];
        
        if (!self.popoverController.isPopoverVisible) {
            [self.popoverController presentPopoverFromRect:self.bounds
                                                    inView:self
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];
        }
    }
    else
    {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.fieldValuesController];
        nav.modalPresentationStyle = UIModalPresentationPopover;
        [nav setNavigationBarHidden:YES];
        UIPopoverPresentationController *popover = nav.popoverPresentationController;
        popover.permittedArrowDirections = UIPopoverArrowDirectionDown | UIPopoverArrowDirectionUp;
        popover.delegate = self;
        popover.sourceView = self;
        
        [self.dropdownDelegate presentDropdown:nav fromRect:self.frame];
    }
}


#pragma mark - Popover Handling


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

-(void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    [self updateContentViewController:self.fieldValuesController withField:self.field];
}

@end
