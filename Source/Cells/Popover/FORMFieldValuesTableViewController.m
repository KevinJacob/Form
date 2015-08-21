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

    _headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:FORMFieldValuesTableViewHeaderIdentifier];

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

    //self.tableView.bounces = NO;
    
    if(!self.fieldValue)
    {
        FORMFieldValue *fieldValue = [[FORMFieldValue alloc] init];
        fieldValue.value = @"";
        self.fieldValue = fieldValue;
    }
    
    self.clearsSelectionOnViewWillAppear = NO;

    self.tableView.rowHeight = FORMFieldValuesCellHeight;
    
    [self.tableView registerClass:[FORMFieldValueCell class] forCellReuseIdentifier:FORMFieldValueCellIdentifer];
    [self.tableView registerClass:[FORMFieldValuesTableViewHeader class] forHeaderFooterViewReuseIdentifier:FORMFieldValuesTableViewHeaderIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView reloadData];
    }];
}


#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView.field = self.field;
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger headerHeight;
    if (self.customHeight > 0.0f) {
        headerHeight = self.customHeight;
    } else {
        [self.headerView setField:self.field];
        headerHeight = [self.headerView labelHeight];
    }

    return headerHeight;
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
    cell.fieldValue = fieldValue;

    if ([self.field.value isKindOfClass:[FORMFieldValue class]]) {

        [tableView selectRowAtIndexPath:indexPath
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectedCell)
    {
        self.selectedCell.clearButton.hidden = YES;
        
        if(self.selectedCell != (FORMFieldValueCell *)[self.tableView cellForRowAtIndexPath:indexPath])
        {
            self.selectedCell = (FORMFieldValueCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            self.selectedCell.clearButton.frame = CGRectMake(self.tableView.frame.size.width - 40, 7, 30, 30);
            self.selectedCell.clearButton.hidden = NO;
            
            self.fieldValue = self.values[indexPath.row];
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
        self.selectedCell.clearButton.frame = CGRectMake(self.tableView.frame.size.width - 40, 7, 30, 30);
        self.selectedCell.clearButton.hidden = NO;
        
        self.fieldValue = self.values[indexPath.row];
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FORMFieldValue *fieldValue = self.values[indexPath.row];
    
    return ([self getHeightForTextView:fieldValue.title withWidth:self.tableView.frame.size.width] + (FORMFieldValueMargin * 2));
    
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
        textToMeasure = @" ";
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textToMeasure attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]}];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(width*0.95, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGFloat textViewHeight = rect.size.height;
    
    return textViewHeight;
}


#pragma mark - Actions


-(void)cancelValue
{
    if(self.selectedCell)
    {
        self.selectedCell.clearButton.hidden = YES;
    }
    
    if(self.fieldValue)
    {
        FORMFieldValue *fieldValue = [[FORMFieldValue alloc] init];
        fieldValue.value = @"";
        self.fieldValue = fieldValue;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)clearValue
{
    if(self.selectedCell)
    {
        self.selectedCell.clearButton.hidden = YES;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
