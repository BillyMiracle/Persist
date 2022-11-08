//
//  PlansView.m
//  Persist
//
//  Created by 张博添 on 2022/3/30.
//

#import "PlansView.h"
#import "PlansPageFunctionCollectionViewCell.h"
#import "CustomTextView.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

@interface PlansView()
<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, assign) NSInteger selectedIndex;//选中的数字
@property (nonatomic, copy) NSArray *nameArray;
@property (nonatomic, copy) NSArray *iconNameArray;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) CustomTextView *remarkTextView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, assign) NSInteger typeIndex;

@property (nonatomic, strong) UIDatePicker *firstTimePicker;
@property (nonatomic, strong) UIDatePicker *secondTimePicker;
@property (nonatomic, strong) UIView *lineView;

#pragma mark 数据
@property (nonatomic, strong) NSString *startDate;//开始日期
@property (nonatomic, strong) NSString *endDate;//截止日期
@property (nonatomic, assign) NSInteger typeNum;//计划类型
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *remark;//备注
@property (nonatomic, assign) NSInteger timeType;//时间类型

@end

@implementation PlansView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelButton.frame = CGRectMake(20, 10, 50, 30);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(pressCancel) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_confirmButton];
    _confirmButton.frame = CGRectMake(selfViewHeight / 26, selfViewHeight * 13 / 15 - selfViewHeight / 13, selfViewWidth - (selfViewHeight / 13), selfViewHeight / 13);
    [self setConfirmButtonOff];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton.layer setMasksToBounds:YES];
    _confirmButton.layer.cornerRadius = selfViewHeight / 26;
    _confirmButton.layer.borderWidth = 0;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:23];
    
    [_confirmButton addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置每个item的大小
    layout.itemSize = CGSizeMake(selfViewWidth / 5.3, selfViewWidth / 5.3);
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, selfViewWidth, selfViewWidth / 5.3) collectionViewLayout:layout];
    _mainCollectionView.backgroundColor = [UIColor whiteColor];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    [_mainCollectionView registerClass:[PlansPageFunctionCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    _nameArray = @[@"工作", @"学习", @"生活", @"饮食", @"休闲", @"购物", @"运动", @"出行"];
    _iconNameArray = @[@"work.png", @"study.png", @"life.png", @"meal.png", @"rest.png", @"shopping.png", @"sport.png", @"travel.png"];
    [self addSubview:_mainCollectionView];
    _selectedIndex = 0;
    
    _titleTextField = [[UITextField alloc] init];
    _titleTextField.placeholder = @"请输入标题";
    _titleTextField.borderStyle = UITextBorderStyleRoundedRect;
    _titleTextField.layer.masksToBounds = YES;
    _titleTextField.layer.cornerRadius = 2;
    _titleTextField.layer.borderWidth = 1;
    _titleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _titleTextField.frame = CGRectMake(selfViewWidth / 26, selfViewWidth / 5.3 + 60, selfViewWidth * 12 / 13, _titleTextField.font.lineHeight + 30);
    [self addSubview:_titleTextField];
    _titleTextField.delegate = self;
    
    _remarkTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(selfViewWidth / 26, 100 + selfViewWidth / 5.3 + _titleTextField.font.lineHeight, selfViewWidth * 12 / 13, selfViewHeight / 8)];
    [self addSubview:_remarkTextView];
    _remarkTextView.layer.masksToBounds = YES;
    _remarkTextView.layer.cornerRadius = 2;
    _remarkTextView.layer.borderWidth = 1;
    _remarkTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_remarkTextView setPlaceholder:@"请输入备注"];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(selfViewWidth / 4, _remarkTextView.frame.origin.y + _remarkTextView.frame.size.height + 5, selfViewWidth / 2, 40)];
    [self addSubview:_segmentedControl];
    [_segmentedControl insertSegmentWithTitle:@"全天" atIndex:0 animated:NO];
    [_segmentedControl insertSegmentWithTitle:@"时段" atIndex:1 animated:NO];
    [_segmentedControl insertSegmentWithTitle:@"周期" atIndex:2 animated:NO];
    [_segmentedControl addTarget:self action:@selector(changeSegmentedControl) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl setSelectedSegmentIndex:0];
    _typeIndex = 0;
    
    _firstTimePicker = [[UIDatePicker alloc] init];
    _firstTimePicker.datePickerMode = UIDatePickerModeTime;
    _firstTimePicker.minimumDate = [NSDate date];
    _firstTimePicker.preferredDatePickerStyle = UIDatePickerStyleCompact;
    _firstTimePicker.frame = CGRectMake(selfViewWidth / 2 - 110, _segmentedControl.frame.origin.y + 5 + _segmentedControl.frame.size.height, 100, 80);
    [self addSubview:_firstTimePicker];
    [_firstTimePicker addTarget:self action:@selector(changeFirstTime) forControlEvents:UIControlEventValueChanged];
    
    _secondTimePicker = [[UIDatePicker alloc] init];
    _secondTimePicker.datePickerMode = UIDatePickerModeTime;
    _secondTimePicker.minimumDate = [NSDate date];
    _secondTimePicker.preferredDatePickerStyle = UIDatePickerStyleCompact;
    _secondTimePicker.frame = CGRectMake(selfViewWidth / 2 + 10, _firstTimePicker.frame.origin.y, 100, 80);
    [self addSubview:_secondTimePicker];
    [_secondTimePicker addTarget:self action:@selector(changeSecondTime) forControlEvents:UIControlEventValueChanged];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 4)];
    _lineView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_lineView];
    _lineView.center = CGPointMake(selfViewWidth / 2, _firstTimePicker.frame.origin.y + 40);
    
    [self changeToAlldayMode];
    
    return self;
}

- (void)pressCancel {
    [self.delegate cancel];
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlansPageFunctionCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[_iconNameArray objectAtIndex:indexPath.row]];
    
    if (_selectedIndex == indexPath.row) {
        cell.coverView.hidden = YES;
        cell.selectedIconView.hidden = NO;
    } else {
        cell.coverView.hidden = NO;
        cell.selectedIconView.hidden = YES;
    }
    
    return cell;
}

//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedIndex = indexPath.row;
    [_mainCollectionView reloadData];
    
}

#pragma mark - 关闭确认按钮
- (void)setConfirmButtonOff {
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:0.7];
    [_confirmButton setTintColor:[UIColor darkGrayColor]];
    _confirmButton.userInteractionEnabled = NO;
}

#pragma mark - 激活确认按钮
- (void)setConfirmButtonOn {
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [_confirmButton setTintColor:[UIColor blackColor]];
    _confirmButton.userInteractionEnabled = YES;
}


#pragma mark - 点击确认按钮
- (void)pressConfirm {
    NSLog(@"%@ %@", _firstTimePicker.date, _secondTimePicker.date);
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _startDate = [df stringFromDate:_firstTimePicker.date];
    _endDate = [df stringFromDate:_secondTimePicker.date];
    
    NSLog(@"%@ %@", _startDate, _endDate);
    
    
    _title = _titleTextField.text;
    _remark = _remarkTextView.text;
    _typeNum = _selectedIndex;
    _timeType = _segmentedControl.selectedSegmentIndex;
    
    
    [self.delegate confirmWithStartDate:_startDate andEndDate:_endDate andTitle:_title andRemark:_remark andTimeType:_timeType andType:_typeNum];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_titleTextField resignFirstResponder];
    [_remarkTextView resignFirstResponder];
}

- (void)changeSegmentedControl {
    _typeIndex = _segmentedControl.selectedSegmentIndex;
    _firstTimePicker.date = [NSDate date];
    _secondTimePicker.date = [NSDate date];
    if (_typeIndex == 0) {
        NSLog(@"1");
        [self changeToAlldayMode];
    } else if (_typeIndex == 1) {
        NSLog(@"2");
        [self changeToTimeSelectMode];
    } else if (_typeIndex == 2) {
        NSLog(@"3");
        [self changeToDateSelectMode];
    }
}

- (void)changeToTimeSelectMode {
    
    _firstTimePicker.hidden = NO;
    _secondTimePicker.hidden = NO;
    _lineView.hidden = NO;
    
    _firstTimePicker.datePickerMode = UIDatePickerModeTime;
    _secondTimePicker.datePickerMode = UIDatePickerModeTime;
    
}

- (void)changeToAlldayMode {
    
    _firstTimePicker.hidden = YES;
    _secondTimePicker.hidden = YES;
    _lineView.hidden = YES;
    
}

- (void)changeToDateSelectMode {
    
    _firstTimePicker.hidden = NO;
    _secondTimePicker.hidden = NO;
    _lineView.hidden = NO;
    
    _firstTimePicker.datePickerMode = UIDatePickerModeDate;
    _secondTimePicker.datePickerMode = UIDatePickerModeDate;
}

- (void)changeFirstTime {
    _secondTimePicker.minimumDate = _firstTimePicker.date;
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.year = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    _secondTimePicker.maximumDate = [calendar dateByAddingComponents:comp toDate:_firstTimePicker.date options:0];
}

- (void)changeSecondTime {
    _firstTimePicker.maximumDate = _secondTimePicker.date;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if ([_titleTextField.text isEqualToString:@""]) {
        [self setConfirmButtonOff];
    } else {
        [self setConfirmButtonOn];
    }
}


@end
