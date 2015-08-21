#import "FORMDateFieldCell.h"
#import "FORMTextFieldCell.h"
#import "FORMTextViewCell.h"
#import "NSDate+dateToText.h"
#import "RMDateSelectionViewController.h"

static const CGSize FORMDatePopoverSize = { 320.0f, 284.0f };

@interface FORMDateFieldCell () <FORMTextFieldDelegate>

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


#pragma mark - Actions


- (void)openDateSelectionController
{
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller)
    {
        switch (self.field.type) {
            case FORMFieldTypeDate:
                self.field.value = [((UIDatePicker *)controller.contentView).date displayDate];
                break;
            case FORMFieldTypeDateTime:
                self.field.value = [((UIDatePicker *)controller.contentView).date displayDateTime];
                break;
            case FORMFieldTypeTime:
                self.field.value = [((UIDatePicker *)controller.contentView).date displayTime];
                break;
            default:
                break;
        }
        
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
    
    [self.dropdownDelegate presentDropdown:self.dateController fromRect:self.frame];
}



#pragma mark - FORMBaseFormFieldCell

- (void)updateWithField:(FORMFields *)field {
    [super updateWithField:field];

    if (field.value) {
        self.valueView.text = field.value;
    } else {
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


#pragma mark - Private methods

- (BOOL)becomeFirstResponder {
    [self titleLabelPressed:self.valueView];
    
    return [super becomeFirstResponder];
}


#pragma mark - FORMTitleLabelDelegate

- (void)titleLabelPressed:(FORMDropDownValueView *)titleLabel {
    [[NSNotificationCenter defaultCenter] postNotificationName:FORMResignFirstResponderNotification object:nil];
    
    [self updateContentViewController:self.dateController withField:self.field];
    
    [self openDateSelectionController];
}


@end
