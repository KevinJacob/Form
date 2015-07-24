#import "FORMFieldValuesTableViewController.h"

#import "FORMFieldValue.h"
#import "FORMFields.h"
#import "FORMFieldValuesTableViewHeader.h"
#import "FORMFieldValueCell.h"


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
    self.headerView.field = field;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

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
    } else if (self.field.info) {
        [self.headerView setField:self.field];
        headerHeight = [self.headerView labelHeight];
    } else {
        headerHeight = FORMFieldValuesCellHeight;
    }

    return headerHeight;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FORMFieldValueCell *cell = [tableView dequeueReusableCellWithIdentifier:FORMFieldValueCellIdentifer];

    FORMFieldValue *fieldValue = self.values[indexPath.row];
    cell.fieldValue = fieldValue;

    if ([self.field.value isKindOfClass:[FORMFieldValue class]]) {
        FORMFieldValue *currentFieldValue = self.field.value;

        if ([currentFieldValue identifierIsEqualTo:fieldValue.valueID]) {
            [tableView selectRowAtIndexPath:indexPath
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        if ([fieldValue identifierIsEqualTo:self.field.value]) {
            [tableView selectRowAtIndexPath:indexPath
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FORMFieldValue *fieldValue = self.values[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(fieldValuesTableViewController:didSelectedValue:)]) {
        [self.delegate fieldValuesTableViewController:self
                                     didSelectedValue:fieldValue];
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

@end
