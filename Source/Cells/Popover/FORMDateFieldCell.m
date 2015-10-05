#import "FORMDateFieldCell.h"
#import "FORMTextFieldCell.h"
#import "FORMTextViewCell.h"
#import "NSDate+dateToText.h"
#import "RMDateSelectionViewController.h"

static const CGSize FORMDatePopoverSize = { 320.0f, 284.0f };

@interface FORMDateFieldCell () <FORMTextFieldDelegate, FORMFieldValuesTableViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic) UIDatePicker *datePicker;

@end

@implementation FORMDateFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame contentViewController:self.dateController
                 andContentSize:FORMDatePopoverSize];
    if (!self) return nil;

    return self;
}

#pragma mark - Getters

- (CGRect)datePickerFrame {
    return CGRectMake(0.0f, 25.0f, FORMDatePopoverSize.width, 196);
}

- (UIDatePicker *)datePicker {
    if (_datePicker) return _datePicker;


    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    return _datePicker;
}

#pragma mark - Actions


- (void)openDateSelectionController
{
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller)
    {
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:00ZZZ"];
        
        NSString *dateSelected = [df stringFromDate:((UIDatePicker *)controller.contentView).date];
        self.field.value = dateSelected;
        
        [self updateWithField:self.field];
        [self validate];
        
        if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
            [self.delegate fieldCell:self updatedWithField:self.field];
        }
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller)
    {
        NSLog(@"Date selection was canceled");
    }];
    
    self.dateController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    self.dateController.title= [NSString stringWithFormat:@"%@", self.field.title];
    self.dateController.datePicker.date = [NSDate date];
    self.dateController.datePicker.minuteInterval = 1;
    self.dateController.disableBouncingEffects = YES;
    self.dateController.disableMotionEffects = YES;
    self.dateController.disableBlurEffects = YES;
    
    switch (self.field.type) {
        case FORMFieldTypeDate:
            self.dateController.datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        case FORMFieldTypeDateTime:
            self.dateController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        case FORMFieldTypeTime:
            self.dateController.datePicker.datePickerMode = UIDatePickerModeTime;
            break;
        default:
            break;
    }
    
    RMAction *nowAction = [RMAction actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:^(RMActionController *controller) {
        ((UIDatePicker *)controller.contentView).date = [NSDate date];
    }];
    nowAction.dismissesActionController = NO;
    [self.dateController addAction:nowAction];
    
    RMAction *clearAction = [RMAction actionWithTitle:@"Clear" style:RMActionStyleDestructive andHandler:^(RMActionController *controller) {
        self.field.value = @"";
        
        [self updateWithField:self.field];
        [self validate];
        
        if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
            [self.delegate fieldCell:self updatedWithField:self.field];
        }
    }];
    [self.dateController addAction:clearAction];
    
    [self.dropdownDelegate presentDropdown:self.dateController fromRect:self.frame  withCell:nil];
}


#pragma mark - Setters

- (void)setDate:(NSDate *)date {
    _date = date;
    
    if (_date) self.datePicker.date = _date;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    
    self.datePicker.minimumDate = _minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    
    self.datePicker.maximumDate = _maximumDate;
}

#pragma mark - Actions

- (void)dateChanged:(UIDatePicker *)datePicker {
    self.date = datePicker.date;
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateWithField:(FORMFields *)field {

    [super updateWithField:field];
    
    if (field.value)
    {
        NSDate *fullDateValue = [NSDate dateFromUTCdateString:field.value];
        
        if (field.type == FORMFieldTypeTime)
        {
            self.valueView.text = [fullDateValue displayTime];
        }
        else if (field.type == FORMFieldTypeDate)
        {
            self.valueView.text = [fullDateValue displayDate];
        }
        else if (field.type == FORMFieldTypeDateTime)
        {
            self.valueView.text = [fullDateValue displayDateTime];
        }
    }
    else
    {
        self.valueView.text = nil;
    }

    self.iconImageView.image = [self fieldIcon];
}


- (UIImage *)fieldIcon {
    NSString *bundlePath = [[[NSBundle bundleForClass:self.class] resourcePath] stringByAppendingPathComponent:@"Form.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];

    UITraitCollection *trait = [UITraitCollection traitCollectionWithDisplayScale:2.0];

    switch (self.field.type) {
        case FORMFieldTypeDate:
        case FORMFieldTypeDateTime:
            return [UIImage imageNamed:@"forms_calendar"
                                  inBundle:bundle
             compatibleWithTraitCollection:trait];
            break;
        case FORMFieldTypeTime:
            return [UIImage imageNamed:@"forms_clock"
                              inBundle:bundle
         compatibleWithTraitCollection:trait];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - FORMPopoverFormFieldCell

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(FORMFields *)field {
    self.fieldValuesController.field = self.field;
    
    contentViewController.preferredContentSize = FORMDatePopoverSize;

    if (self.field.value) {
        self.dateController.datePicker.date = [NSDate date];
    }

    if (self.field.minimumDate) {
        self.dateController.datePicker.minimumDate = self.field.minimumDate;
    }

    if (self.field.maximumDate) {
        self.dateController.datePicker.maximumDate = self.field.maximumDate;
    }
}


#pragma mark - FORMFieldValuesTableViewControllerDelegate
    
- (void)fieldValuesTableViewController:(FORMFieldValuesTableViewController *)fieldValuesTableViewController
                                                                            didSelectedValue:(FORMFieldValue *)selectedValue
{
    if ([selectedValue.value boolValue] == YES) {
        self.field.value = self.datePicker.date;
    } else {
        self.field.value = nil;
    }
    
    [self updateWithField:self.field];
    
    [self validate];
    
    [fieldValuesTableViewController dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}
    
    
#pragma mark - Private methods

- (BOOL)becomeFirstResponder {
    [self titleLabelPressed:self.valueView];
    
    return [super becomeFirstResponder];
}


- (void)titleLabelPressed:(FORMDropDownValueView *)titleLabel {
    [[NSNotificationCenter defaultCenter] postNotificationName:FORMResignFirstResponderNotification object:nil];
    
    [self updateContentViewController:self.dateController withField:self.field];
    
    [self openDateSelectionController];
}


@end

