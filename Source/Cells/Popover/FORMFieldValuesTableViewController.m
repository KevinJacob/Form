#import "FORMFieldValuesTableViewController.h"

#import "FORMFieldValue.h"
#import "FORMFields.h"
#import "FORMFieldValuesTableViewHeader.h"
#import "FORMFieldValueCell.h"
#import "UIColor+Hex.h"


static const CGFloat FORMFieldValueMargin = 10.0f;


@interface FORMFieldValuesTableViewController ()

@property (nonatomic) NSArray *values;

@end

@implementation FORMFieldValuesTableViewController

#pragma mark - Getters

- (FORMFieldValuesTableViewHeader *)headerView {
	if (_headerView) return _headerView;

    _headerView = [[FORMFieldValuesTableViewHeader alloc] initWithFrame:self.tableView.frame];
    _headerView.field = self.field;
    _headerView.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [_headerView labelHeight])];
        view.backgroundColor = [UIColor colorFromHex:@"1A242F"];
        view;
    });
    
	return _headerView;
}

#pragma mark - Setters

- (void)setField:(FORMFields *)field {
    _field = field;

    self.values = [NSArray arrayWithArray:field.values];
    [self.tableView reloadData];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.bounces = NO;
    
    self.clearsSelectionOnViewWillAppear = NO;

    self.tableView.rowHeight = FORMFieldValuesCellHeight;
    
    [self.tableView registerClass:[FORMFieldValueCell class] forCellReuseIdentifier:FORMFieldValueCellIdentifer];
    [self.tableView registerClass:[FORMFieldValuesTableViewHeader class] forHeaderFooterViewReuseIdentifier:FORMFieldValuesTableViewHeaderIdentifier];
}



-(void)viewWillAppear:(BOOL)animated
{
    if(!self.fieldValue)
    {
        FORMFieldValue *fieldValue = [[FORMFieldValue alloc] init];
        fieldValue.value = @"";
        self.fieldValue = fieldValue;
    }
    
    self.dropdownExposed = YES;
    [self.tableView reloadData];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView reloadData];
    }];
}



-(void)viewWillDisappear:(BOOL)animated
{
    self.dropdownExposed = NO;
    if(!self.dismissedbyButton)
    {
        [self cancelValue];
    }
}


#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    [self.headerView setField:self.field];
    
    return ([self getHeightForTextView:self.field.title withWidth:self.tableView.frame.size.width] +
            [self getHeightForTextView:self.field.info withWidth:self.tableView.frame.size.width] +
            (FORMFieldValueMargin * 2));
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FORMFieldValuesCellHeight)];
    footerView.backgroundColor = [UIColor colorFromHex:@"1A242F"];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelValue) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancel.frame = CGRectMake(0, 0, 100, 35);
    self.cancelButton = cancel;
    [footerView addSubview:cancel];
    
    UIButton *clear = [UIButton buttonWithType:UIButtonTypeCustom];
    [clear setTitle:@"Clear" forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clearValue) forControlEvents:UIControlEventTouchUpInside];
    [clear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clear.frame = CGRectMake(self.view.frame.size.width/2 - 50, 0, 100, 35);
    self.clearButton = clear;
    [footerView addSubview:clear];
    
    UIButton *select = [UIButton buttonWithType:UIButtonTypeCustom];
    [select setTitle:@"Confirm" forState:UIControlStateNormal];
    [select addTarget:self action:@selector(selectValue) forControlEvents:UIControlEventTouchUpInside];
    [select setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    select.frame = CGRectMake(self.view.frame.size.width - 100, 0, 100, 35);
    self.selectButton = select;
    [footerView addSubview:select];
    
    return footerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FORMFieldValuesCellHeight;
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FORMFieldValueCell *cell = [tableView dequeueReusableCellWithIdentifier:FORMFieldValueCellIdentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FORMFieldValue *fieldValue = self.values[indexPath.row];
    if([fieldValue.valueID isEqualToString:self.field.valueID])
    {
        self.selectedCell = cell;
        fieldValue.selected = YES;
        self.selectedCell.selectedButton.frame = CGRectMake(self.tableView.frame.size.width - 40, 7, 30, 30);
    }
    else
    {
        fieldValue.selected = NO;
    }
    cell.fieldValue = fieldValue;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectedCell)
    {
        self.selectedCell.selectedButton.hidden = YES;
        self.fieldValue.selected = NO;
        
        if(self.selectedCell != (FORMFieldValueCell *)[self.tableView cellForRowAtIndexPath:indexPath])
        {
            self.selectedCell = (FORMFieldValueCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            self.selectedCell.selectedButton.frame = CGRectMake(self.tableView.frame.size.width - 40, 7, 30, 30);
            self.selectedCell.selectedButton.hidden = NO;
            
            self.fieldValue = self.values[indexPath.row];
            self.fieldValue.selected = YES;
        }
        else
        {
            self.selectedCell = nil;
            
            FORMFieldValue *fieldValue = [[FORMFieldValue alloc] init];
            fieldValue.value = @"";
            self.fieldValue = fieldValue;
        }
    }
    else
    {
        self.selectedCell = (FORMFieldValueCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        self.selectedCell.selectedButton.frame = CGRectMake(self.tableView.frame.size.width - 40, 7, 30, 30);
        self.selectedCell.selectedButton.hidden = NO;
        
        self.fieldValue = self.values[indexPath.row];
        self.fieldValue.selected = YES;
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FORMFieldValue *fieldValue = self.values[indexPath.row];
    
    return ([self getHeightForTextView:fieldValue.title withWidth:self.tableView.frame.size.width] +
            [self getHeightForTextView:fieldValue.info withWidth:self.tableView.frame.size.width] +
            (FORMFieldValueMargin * 2));
    
}


#pragma mark - Getters

- (CGFloat)getHeightForTextView:(NSString *)myTextView withWidth:(CGFloat)width
{
    NSString *textToMeasure;
    
    if(myTextView.length > 0)
    {
        textToMeasure = myTextView;
    }
    else
    {
        return 0;
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textToMeasure attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]}];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(width*0.95, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGFloat textViewHeight = rect.size.height;
    
    return textViewHeight;
}



-(FORMFieldValue *)fieldWithValue:(NSString *)value
{
    for(FORMFieldValue *field in self.field.values)
    {
        if([field.title isEqualToString:value])
        {
            return field;
        }
    }
    return nil;
}


#pragma mark - Actions


-(void)cancelValue
{
    self.fieldValue.selected = NO;
    if(self.field.value)
    {
        FORMFieldValue *fieldValue = [self fieldWithValue:self.field.value];
        fieldValue.selected = YES;
    }
    self.dismissedbyButton = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)clearValue
{
    if(self.selectedCell)
    {
        self.selectedCell.selectedButton.hidden = YES;
        self.fieldValue.selected = NO;
    }
    
    FORMFieldValue *fieldValue = [[FORMFieldValue alloc] init];
    fieldValue.value = @"";
    self.fieldValue = fieldValue;
}


-(void)selectValue
{
    if ([self.delegate respondsToSelector:@selector(fieldValuesTableViewController:didSelectedValue:)]) {
        [self.delegate fieldValuesTableViewController:self
                                     didSelectedValue:self.fieldValue];
    }
    self.dismissedbyButton = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
