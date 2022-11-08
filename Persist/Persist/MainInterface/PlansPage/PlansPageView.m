//
//  PlansView.m
//  Persist
//
//  Created by 张博添 on 2022/1/17.
//

#import "PlansPageView.h"
#import "LoginOrRegisterModel.h"
#import "DateCollectionViewCell.h"
#import <Masonry.h>
#import "CircleView.h"
//#import "HistoryTableViewCell.h"
#import "PlansTableViewCell.h"
#import "Manager.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height
//#define selfViewWidth 340
//#define selfViewHeight 500

static const float navigationBarHeight = 50.0;
//static const float titleFontSize = 23;

@interface PlansPageView ()
<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, PlansTableViewCellDelegate>

@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) UICollectionView *dateCollectionView;

@property (nonatomic, copy) NSDate *today;
@property (nonatomic, assign) NSInteger todayDay;
@property (nonatomic, assign) NSUInteger numberOfDaysThisMonth;
@property (nonatomic, assign) NSUInteger numberOfDaysLastMonth;
@property (nonatomic, assign) NSUInteger numberOfDaysNextMonth;

@property (nonatomic, copy) NSDate *lastMonth1st;

@property (nonatomic, assign) NSInteger lastMonth1stWeekDay;

@property (nonatomic, copy) NSArray *weekdayArray;

@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) CircleView *myCircleView;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UIView *runningInfoView;

@property (nonatomic, strong) UILabel *exerciseTimeTitleLabel;
@property (nonatomic, strong) UILabel *targetTimeLabel;
@property (nonatomic, strong) UILabel *doneTimeLabel;

@property (nonatomic, strong) UIButton *changeTargetButton;

@property (nonatomic, strong) UITableView *mainTableView;

//@property (nonatomic, strong) NSMutableArray *runWhenDataArray;
//@property (nonatomic, strong) NSMutableArray *runTimeDataArray;
//@property (nonatomic, strong) NSMutableArray *distanceDataArray;

@property (nonatomic, strong) NSMutableArray *planIdArray;
@property (nonatomic, strong) NSMutableArray *planTitleArray;
@property (nonatomic, strong) NSMutableArray *planDetailArray;
@property (nonatomic, strong) NSMutableArray *planDoneArray;
@property (nonatomic, strong) NSMutableArray *planTypeArray;
@property (nonatomic, strong) NSMutableArray *planTimeArray;

@property (nonatomic, assign) int numberOfAllDayDone;

@property (nonatomic, strong) NSArray *typeTitleArray;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, assign) float timeDone;
@property (nonatomic, assign) float targetTime;

@end

@implementation PlansPageView

- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:CGRectMake(0, 0, 340, 500)];
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
//    _runWhenDataArray = [[NSMutableArray alloc] init];
//    _runTimeDataArray = [[NSMutableArray alloc] init];
//    _distanceDataArray = [[NSMutableArray alloc] init];
    _planIdArray = [[NSMutableArray alloc] init];
    _planDoneArray = [[NSMutableArray alloc] init];
    _planTitleArray = [[NSMutableArray alloc] init];
    _planDetailArray = [[NSMutableArray alloc] init];
    _planTypeArray = [[NSMutableArray alloc] init];
    _planTimeArray = [[NSMutableArray alloc] init];
    
    _typeTitleArray = @[@"work", @"study", @"life", @"meal", @"rest", @"shopping", @"sport", @"travel"];
    
    [self buildUI];
//    [self networkGetData];
    return self;
}

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

- (void)buildUI {
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, self.statusBarHeight)];
    _statusBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_statusBarView];
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, selfViewWidth, navigationBarHeight)];
    _navigationBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_navigationBarView];
    
    _headImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _headImageButton.frame = CGRectMake(10, 5, navigationBarHeight - 10, navigationBarHeight - 10);
    _headImageButton.layer.masksToBounds = YES;
    _headImageButton.layer.borderWidth = 0;
    _headImageButton.layer.cornerRadius = (navigationBarHeight - 10) / 2;
    [_headImageButton addTarget:self action:@selector(pressHeadImageButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *headImage = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
    [_headImageButton setBackgroundImage:headImage forState:UIControlStateNormal];
    
    [_navigationBarView addSubview:_headImageButton];
    
    [self buildDateCollectionView];
//    [self buildRunningInfoView];
    
    [self buildMainTableView];
}

- (void)pressHeadImageButton {
    [self.delegate openDrawerView];
}

- (void)buildDateCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置每个item的大小
    layout.itemSize = CGSizeMake(selfViewWidth / 7, 72);
    _dateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight, selfViewWidth, 72) collectionViewLayout:layout];
    _dateCollectionView.delegate = self;
    _dateCollectionView.dataSource = self;
    _dateCollectionView.showsHorizontalScrollIndicator = NO;
    [_dateCollectionView registerClass:[DateCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    _dateCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_dateCollectionView];
    
#pragma mark 建立各个日期
    _today = [NSDate date];
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    //获取不同时间字段的信息
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_today];
    //这个月多少天
    _numberOfDaysThisMonth = range.length;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents *compToday = [gregorian components:unitFlags fromDate: _today];
    _todayDay = compToday.day;
    
    NSDateComponents *adjustMonthComps = [[NSDateComponents alloc] init];
    [adjustMonthComps setMonth:-1];
    NSDate *lastMonthDate = [calendar dateByAddingComponents:adjustMonthComps toDate:_today options:0];
    NSDateComponents *compLastMonth = [gregorian components:unitFlags fromDate: lastMonthDate];
    compLastMonth.day = 1;
    //上个月第一天
    _lastMonth1st = [gregorian dateFromComponents:compLastMonth];
//    NSLog(@"%@", lastMonth1st);
    NSDateComponents *compLastMonth1st = [gregorian components:unitFlags fromDate:_lastMonth1st];
    _lastMonth1stWeekDay = compLastMonth1st.weekday - 1;
//    NSLog(@"%ld", _lastMonth1stWeekDay);
    range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonthDate];
    //上个月多少天
    _numberOfDaysLastMonth = range.length;
    
    [adjustMonthComps setMonth:1];
    NSDate *nextMonthDate = [calendar dateByAddingComponents:adjustMonthComps toDate:_today options:0];
    range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nextMonthDate];
    //下个月多少天
    _numberOfDaysNextMonth = range.length;
    
    _weekdayArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    
    [_dateCollectionView setContentOffset:CGPointMake(selfViewWidth / 7 * (_numberOfDaysLastMonth + _todayDay - 1), 0)];
    _selectedIndex = _numberOfDaysLastMonth + _todayDay - 1;
    _selectedView = [[UIView alloc] initWithFrame:CGRectMake((selfViewWidth / 7) * _selectedIndex + selfViewWidth / 21, 18 + 36 + 5, selfViewWidth / 21, 8)];
    [_selectedView setBackgroundColor:[UIColor blackColor]];
    _selectedView.layer.masksToBounds = YES;
    _selectedView.layer.cornerRadius = 4;
    [_dateCollectionView addSubview:_selectedView];
}
#pragma mark - 建立tableView
- (void)buildMainTableView {
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight + 75, selfViewWidth, selfViewHeight - (self.statusBarHeight + navigationBarHeight + 75)) style:UITableViewStylePlain];
    
    [self addSubview:_mainTableView];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.sectionHeaderHeight = 0;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    [_mainTableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"normal"];
    [_mainTableView registerClass:[PlansTableViewCell class] forCellReuseIdentifier:@"normal"];
}


#pragma mark - 建立当日计划View
- (UIView *)runningInfoView {
    if (_runningInfoView) {
        return _runningInfoView;
    }
    _runningInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewWidth * 0.3 + 40)];
//    _runningInfoView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self addSubview:_runningInfoView];
    _runningInfoView.backgroundColor = [UIColor whiteColor];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(2, 1, selfViewWidth - 4, selfViewWidth * 0.3 + 38);
    layer.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.99 alpha:1].CGColor;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowRadius = 1;
    layer.shadowOpacity = 0.7;
    layer.cornerRadius = 18;
    [_runningInfoView.layer addSublayer:layer];
    
    _myCircleView = [[CircleView alloc] initWithFrame:CGRectMake(selfViewWidth * 0.7 - 30, 0, selfViewWidth * 0.3, selfViewWidth * 0.3)];
    [_runningInfoView addSubview:_myCircleView];
    [_myCircleView changeProgress:0];
    
    _progressLabel = [[UILabel alloc] init];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.frame = CGRectMake(0, 0, _myCircleView.frame.size.width - 30, _progressLabel.font.lineHeight);
    _progressLabel.text = [NSString stringWithFormat:@"%.2f%c", 0.0, '%'];
    _progressLabel.adjustsFontSizeToFitWidth = YES;
    [_runningInfoView addSubview:_progressLabel];
    _progressLabel.center = _myCircleView.center;
    
    _exerciseTimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, selfViewWidth * 0.7 - 90, selfViewWidth * 0.15)];
    _exerciseTimeTitleLabel.text = @"运动时间";
    _exerciseTimeTitleLabel.font = [UIFont systemFontOfSize:16 / _exerciseTimeTitleLabel.font.lineHeight * _exerciseTimeTitleLabel.frame.size.height * 0.7];
    _exerciseTimeTitleLabel.adjustsFontSizeToFitWidth = YES;
    [_runningInfoView addSubview:_exerciseTimeTitleLabel];
    
    _doneTimeLabel = [[UILabel alloc] init];
    [_runningInfoView addSubview:_doneTimeLabel];
    _doneTimeLabel.font = _exerciseTimeTitleLabel.font;
    _doneTimeLabel.text = @"0";
    [_doneTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_exerciseTimeTitleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_exerciseTimeTitleLabel.mas_left);
    }];
    
    _targetTimeLabel = [[UILabel alloc] init];
    [_runningInfoView addSubview:_targetTimeLabel];
    _targetTimeLabel.font = [UIFont systemFontOfSize:_exerciseTimeTitleLabel.font.pointSize * 0.7];
    _targetTimeLabel.text = [NSString stringWithFormat:@"/%dmin", 30];
    _targetTimeLabel.textColor = [UIColor grayColor];
    [_targetTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_doneTimeLabel.mas_right);
        make.bottom.mas_equalTo(_doneTimeLabel.mas_bottom);
    }];
    
    _changeTargetButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [_runningInfoView addSubview:_changeTargetButton];
    _changeTargetButton.frame = CGRectMake(selfViewWidth * 0.75 - 30, selfViewWidth * 0.3 + 5, selfViewWidth * 0.2, 30);
    _changeTargetButton.layer.masksToBounds = YES;
    _changeTargetButton.layer.cornerRadius = 15;
    _changeTargetButton.layer.borderWidth = 0;
//    _changeTargetButton.layer.borderColor = [UIColor systemGreenColor].CGColor;
    _changeTargetButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_changeTargetButton setBackgroundColor:[UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1]];
    [_changeTargetButton setTintColor:[UIColor whiteColor]];
    [_changeTargetButton setTitle:@"调整目标" forState:UIControlStateNormal];
    [_changeTargetButton addTarget:self action:@selector(pressChange) forControlEvents:UIControlEventTouchUpInside];
    
    
    return _runningInfoView;
}

#pragma mark - 运动记录标题
- (UIView *)titleView {
    if (_titleView) {
        return _titleView;
    }
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 40)];
    _titleView.backgroundColor = [UIColor whiteColor];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(selfViewWidth * 0.25, 2, selfViewWidth *0.5, 36);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowRadius = 1;
    layer.shadowOpacity = 0.7;
    layer.cornerRadius = 18;
    [_titleView.layer addSublayer:layer];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(selfViewWidth * 0.25, 2, selfViewWidth *0.5, 36)];
    backView.backgroundColor = [UIColor whiteColor];
    [_titleView addSubview:backView];
    
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 18;
    backView.layer.borderWidth = 0.5;
    backView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth * 0.5, 36)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"今日计划"];
    [backView addSubview:titleLabel];
    
    return _titleView;
}

#pragma mark - tableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
//    return _runWhenDataArray.count;
    return _planTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return (selfViewWidth * 0.3 + 40);
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return selfViewHeight / 8;
    
    return (selfViewHeight / 14 > 60 ? selfViewHeight / 14 : 60);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.titleView;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.runningInfoView;
    } else {
        return nil;
    }
}

#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    HistoryTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"normal" forIndexPath:indexPath];
//
//    cell.runTimeLabel.text = [_runTimeDataArray objectAtIndex:indexPath.row];
//    cell.runWhenLabel.text = [_runWhenDataArray objectAtIndex:indexPath.row];
//    cell.distanceLabel.text = [_distanceDataArray objectAtIndex:indexPath.row];
//
//    return cell;
    PlansTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"normal" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    
    if ([[self.planDoneArray objectAtIndex:indexPath.row] isEqualToString:@"Done"]) {
        [cell.iconButton setBackgroundImage:[UIImage imageNamed:@"Done.png"] forState:UIControlStateNormal];
        
        NSString *text = [_planTitleArray objectAtIndex:indexPath.row];
        NSUInteger length = [text length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, length)];
        [cell.titleLabel setAttributedText:attri];
        
    } else {
        [cell.iconButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [_planTypeArray objectAtIndex:indexPath.row]]] forState:UIControlStateNormal];
        cell.titleLabel.attributedText = nil;
        cell.titleLabel.text = [_planTitleArray objectAtIndex:indexPath.row];
    }
    
    cell.detailLabel.text = [_planDetailArray objectAtIndex:indexPath.row];
//    if (![[_planTimeArray objectAtIndex:indexPath.row] isEqualToString:@"AllDay"]) {
        cell.timeLabel.text = [_planTimeArray objectAtIndex:indexPath.row];
//    } else {
//        cell.timeLabel.text = @"全天";
//    }
    
    cell.delegate = self;
    
    return cell;
}


#pragma mark - collectionViewDelegate/DataSource
//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DateCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        NSInteger index = indexPath.row;
        cell.weekdayLabel.text = [_weekdayArray objectAtIndex:(index + _lastMonth1stWeekDay) % 7];
        cell.weekdayLabel.textColor = [UIColor grayColor];
        //调节选中字体大小
        if (index == _selectedIndex) {
            cell.dayLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:22];
        } else {
            cell.dayLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:18];
        }
    } else if (indexPath.section == 1) {
        NSInteger index = indexPath.row + _numberOfDaysLastMonth;
        if (indexPath.row + 1 == _todayDay) {
            cell.weekdayLabel.text = @"今日";
            cell.weekdayLabel.textColor = [UIColor blackColor];
        } else {
            cell.weekdayLabel.text = [_weekdayArray objectAtIndex:(index + _lastMonth1stWeekDay) % 7];
            cell.weekdayLabel.textColor = [UIColor grayColor];
        }
        //调节选中字体大小
        if (index == _selectedIndex) {
            cell.dayLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:22];
        } else {
            cell.dayLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:18];
        }
        
    } else {
        
        NSInteger index = indexPath.row + _numberOfDaysLastMonth + _numberOfDaysThisMonth;
        cell.weekdayLabel.text = [_weekdayArray objectAtIndex:(index + _lastMonth1stWeekDay) % 7];
        cell.weekdayLabel.textColor = [UIColor grayColor];
        //调节选中字体大小
        if (index == _selectedIndex) {
            cell.dayLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:22];
        } else {
            cell.dayLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:18];
        }
    }
    
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//    cell.weekdayLabel.text = @"今天";
    
    return cell;
}

//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _numberOfDaysLastMonth;
    } else if (section == 1) {
        return _numberOfDaysThisMonth;
    } else {
        return _numberOfDaysNextMonth;
    }
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _selectedIndex = indexPath.row;
    } else if (indexPath.section == 1) {
        _selectedIndex = indexPath.row + _numberOfDaysLastMonth;
    } else {
        _selectedIndex = indexPath.row + _numberOfDaysLastMonth + _numberOfDaysThisMonth;
    }
    [self networkGetData];
    [UIView animateWithDuration:0.3 animations:^{
        [self.selectedView setFrame:CGRectMake((selfViewWidth / 7) * self.selectedIndex + selfViewWidth / 21, 18 + 36 + 5, selfViewWidth / 21, 8)];
    } completion:^(BOOL finished) {
        [self.dateCollectionView reloadData];
    }];
    
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _dateCollectionView) {//单个日期滑动
        if (_dateCollectionView.contentOffset.x -  (int)(_dateCollectionView.contentOffset.x / (selfViewWidth / 7)) * (selfViewWidth / 7) > selfViewWidth / 14) {
            [_dateCollectionView setContentOffset:CGPointMake((int)(_dateCollectionView.contentOffset.x / (selfViewWidth / 7) + 1) * (selfViewWidth / 7), 0) animated:YES];
        } else {
            [_dateCollectionView setContentOffset:CGPointMake((int)(_dateCollectionView.contentOffset.x / (selfViewWidth / 7)) * (selfViewWidth / 7), 0) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _dateCollectionView && !decelerate) {//单个日期滑动
        if (_dateCollectionView.contentOffset.x -  (int)(_dateCollectionView.contentOffset.x / (selfViewWidth / 7)) * (selfViewWidth / 7) > selfViewWidth / 14) {
            [_dateCollectionView setContentOffset:CGPointMake((int)(_dateCollectionView.contentOffset.x / (selfViewWidth / 7) + 1) * (selfViewWidth / 7), 0) animated:YES];
        } else {
            [_dateCollectionView setContentOffset:CGPointMake((int)(_dateCollectionView.contentOffset.x / (selfViewWidth / 7)) * (selfViewWidth / 7), 0) animated:YES];
        }
    }
}

- (void)updateHeadImage {
    UIImage *headImage = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
    [_headImageButton setBackgroundImage:headImage forState:UIControlStateNormal];
}

- (void)updateDate {
    _today = [NSDate date];
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    //获取不同时间字段的信息
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_today];
    //这个月多少天
    _numberOfDaysThisMonth = range.length;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents *compToday = [gregorian components:unitFlags fromDate: _today];
    _todayDay = compToday.day;
    
    NSDateComponents *adjustMonthComps = [[NSDateComponents alloc] init];
    [adjustMonthComps setMonth:-1];
    NSDate *lastMonthDate = [calendar dateByAddingComponents:adjustMonthComps toDate:_today options:0];
    NSDateComponents *compLastMonth = [gregorian components:unitFlags fromDate: lastMonthDate];
    compLastMonth.day = 1;
    //上个月第一天
    _lastMonth1st = [gregorian dateFromComponents:compLastMonth];
//    NSLog(@"%@", lastMonth1st);
    NSDateComponents *compLastMonth1st = [gregorian components:unitFlags fromDate:_lastMonth1st];
    _lastMonth1stWeekDay = compLastMonth1st.weekday - 1;
//    NSLog(@"%ld", _lastMonth1stWeekDay);
    range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonthDate];
    //上个月多少天
    _numberOfDaysLastMonth = range.length;
    
    [adjustMonthComps setMonth:1];
    NSDate *nextMonthDate = [calendar dateByAddingComponents:adjustMonthComps toDate:_today options:0];
    range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nextMonthDate];
    //下个月多少天
    _numberOfDaysNextMonth = range.length;
    
    [_dateCollectionView setContentOffset:CGPointMake(selfViewWidth / 7 * (_numberOfDaysLastMonth + _todayDay - 1), 0)];
    _selectedIndex = _numberOfDaysLastMonth + _todayDay - 1;
    [_selectedView setFrame:CGRectMake((selfViewWidth / 7) * _selectedIndex + selfViewWidth / 21, 18 + 36 + 5, selfViewWidth / 21, 8)];
//    [_dateCollectionView addSubview:_selectedView];
    [_dateCollectionView reloadData];
    [self networkGetData];
}

- (void)networkGetData {
    [self.planIdArray removeAllObjects];
    [self.planDoneArray removeAllObjects];
    [self.planDetailArray removeAllObjects];
    [self.planTypeArray removeAllObjects];
    [self.planTitleArray removeAllObjects];
    [self.planTimeArray removeAllObjects];
    self.numberOfAllDayDone = 0;
    [self.mainTableView reloadData];
    
    [_myCircleView changeProgress:0];
#pragma mark 取消交互
    self.dateCollectionView.userInteractionEnabled = NO;
    self.changeTargetButton.userInteractionEnabled = NO;
    
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *adjustMonthComps = [[NSDateComponents alloc] init];
    [adjustMonthComps setDay:_selectedIndex];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *lastMonthDate = [calendar dateByAddingComponents:adjustMonthComps toDate:_lastMonth1st options:0];
    NSDateComponents *comp = [gregorian components:unitFlags fromDate: lastMonthDate];
    //上个月第一天
    NSDate *day = [gregorian dateFromComponents:comp];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //设置自定义的格式模版
    [df setDateFormat:@"yyyy-MM-dd"];
    _dateString = [df stringFromDate:day];
//    NSLog(@"%@", _dateString);
#pragma mark 获取运动时长
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    [[Manager sharedManager] NetworkGetDaySumTimeAt:_dateString finished:^(RunningDataModelFirst *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.doneTimeLabel.text = [model data];
            self.timeDone = [model data].floatValue;
            dispatch_group_leave(group);
        });
    } error:^(NSError *error) {

    }];
     
//离线
//    dispatch_group_enter(group);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.timeDone = rand() % 40;
//            self.doneTimeLabel.text = [NSString stringWithFormat:@"%.1f", self.timeDone];
//            dispatch_group_leave(group);
//        });
//    });

#pragma mark 获取目标
    
    dispatch_group_enter(group);
    [[Manager sharedManager] NetworkGetRunTargetAt:_dateString finished:^(RunningDataModelFirst *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.targetTimeLabel.text = [NSString stringWithFormat:@"/%@min", [model data]];
            self.originalTarget = [model data];
            self.targetTime = [model data].floatValue;
            dispatch_group_leave(group);
        });
    } error:^(NSError *error) {

    }];
    
//    dispatch_group_enter(group);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(2);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.targetTime = rand() % 40 + 5;
//            self.targetTimeLabel.text = [NSString stringWithFormat:@"/%.0fmin", self.targetTime];
//            self.originalTarget = [NSString stringWithFormat:@"%.0f", self.targetTime];
//            dispatch_group_leave(group);
//        });
//    });
    
#pragma mark - 两个更新完毕
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"%@, %@", self.doneTimeLabel.text, self.targetTimeLabel.text);
        NSLog(@"%f %f", self.timeDone, self.targetTime);
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%c", (self.timeDone > self.targetTime ? 100 : (self.timeDone / self.targetTime) * 100), '%'];
        [self.myCircleView changeProgress:self.timeDone > self.targetTime ? 1 : (self.timeDone / self.targetTime)];
#pragma mark 激活交互
        self.dateCollectionView.userInteractionEnabled = YES;
        self.changeTargetButton.userInteractionEnabled = YES;
    });
#pragma mark 运动记录
    
//    [[Manager sharedManager] NetworkGetRunHistoryAt:dateString finished:^(RunningModelSecond *model) {
//
//        NSArray *array = [model data];
//        for (RunningDataModel *model in array) {
//            [self.runWhenDataArray addObject:[model runWhen]];
//            [self.runTimeDataArray addObject:[NSString stringWithFormat:@"%@min", [model runTime]]];
//            [self.distanceDataArray addObject:[NSString stringWithFormat:@"%@km", [model distance]]];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//        });
//
//    }error:^(NSError *error) {
//
//    }];
    //离线
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [self.runWhenDataArray removeAllObjects];
        [self.runTimeDataArray removeAllObjects];
        [self.distanceDataArray removeAllObjects];
        [self.runWhenDataArray addObject:@"2022-3-14 16:56:00"];[self.runWhenDataArray addObject:@"2022-3-14 20:00:00"];
        [self.runTimeDataArray addObject:[NSString stringWithFormat:@"%.1fmin", (float)(rand() % 150)]];
        [self.runTimeDataArray addObject:[NSString stringWithFormat:@"%.1fmin", (float)(rand() % 150)]];
        [self.distanceDataArray addObject:[NSString stringWithFormat:@"%.2fkm", (float)(rand() % 15)]];
        [self.distanceDataArray addObject:[NSString stringWithFormat:@"%.2fkm", (float)(rand() % 16)]];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.mainTableView reloadData];
        });
    });
     */
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [self.planDoneArray removeAllObjects];
        [self.planDetailArray removeAllObjects];
        [self.planTypeArray removeAllObjects];
        [self.planTitleArray removeAllObjects];
        [self.planTimeArray removeAllObjects];
        
        [self.planTitleArray addObject:@"学习"];
        [self.planTitleArray addObject:@"玩耍"];
        [self.planTitleArray addObject:@"去食堂"];
        [self.planTitleArray addObject:@"打球"];
        
        [self.planDetailArray addObject:@"复习大物，写hh项目"];
        [self.planDetailArray addObject:@"玩游戏就要笑"];
        [self.planDetailArray addObject:@"吃饭饭"];
        [self.planDetailArray addObject:@"玩球就要笑"];
        
        [self.planTypeArray addObject:@"study"];
        [self.planTypeArray addObject:@"work"];
        [self.planTypeArray addObject:@"meal"];
        [self.planTypeArray addObject:@"sport"];
        
        [self.planTimeArray addObject:@"AllDay"];
        [self.planTimeArray addObject:@"AllDay"];
        [self.planTimeArray addObject:@"AllDay"];
        [self.planTimeArray addObject:@"14:00-16:00"];
        
        [self.planDoneArray addObject:@"Undone"];
        [self.planDoneArray addObject:@"Undone"];
        [self.planDoneArray addObject:@"Undone"];
        [self.planDoneArray addObject:@"Done"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.mainTableView reloadData];
        });
    });
    */
    [self getPlans];
}

- (void)getPlans {
    
    [[Manager sharedManager] NetworkGetDailyTargetListWithDay:_dateString succeed:^(TargetModel *targetModel) {
        [self.planIdArray removeAllObjects];
        [self.planDoneArray removeAllObjects];
        [self.planDetailArray removeAllObjects];
        [self.planTypeArray removeAllObjects];
        [self.planTitleArray removeAllObjects];
        [self.planTimeArray removeAllObjects];
        self.numberOfAllDayDone = 0;
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSArray *targetArray = [targetModel data];
        for (DataModel *model in targetArray) {
//            NSLog(@"%d", [model done]);
            if (![model done]) {
                [self.planIdArray addObject:[model targetUid]];
//                [self.planIdArray addObject:@"noid"];
                [self.planDetailArray addObject:[model remark]];
                [self.planTypeArray addObject:[self.typeTitleArray objectAtIndex:[model type]]];
                [self.planTitleArray addObject:[model headLine]];
                [self.planDoneArray addObject:@"Undone"];
                if (![model wholeDay]) {
//                    NSDate *startDate = [df dateFromString:[model beganTime]];
//                    NSDate *endDate = [df dateFromString:[model endTime]];
                    self.today = [NSDate date];
                    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                    //获取不同时间字段的信息
                    
                    NSDateComponents *startComp = [gregorian components:unitFlags fromDate:[df dateFromString:[model beganTime]]];
                    NSDateComponents *endComp = [gregorian components:unitFlags fromDate:[df dateFromString:[model endTime]]];
                    NSDateComponents *todayComp = [gregorian components:unitFlags fromDate:[NSDate date]];
                    
                    if ((startComp.year == endComp.year) && (startComp.month == endComp.month) && (startComp.day == endComp.day)) {
//                        NSLog(@"%@", [NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld", startComp.hour, startComp.minute, endComp.hour, endComp.minute]);
                        [self.planTimeArray addObject:[NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld", startComp.hour, startComp.minute, endComp.hour, endComp.minute]];
                    } else {
//                        NSLog(@"%@", [NSString stringWithFormat:@"%ld.%02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day]);
                        if ((startComp.year == endComp.year) && (startComp.year == todayComp.year)) {
                            [self.planTimeArray addObject:[NSString stringWithFormat:@"%02ld.%02ld-%02ld.%02ld", startComp.month, startComp.day, endComp.month, endComp.day]];
                        } else {
                            [self.planTimeArray addObject:[NSString stringWithFormat:@"%ld%.02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day]];
                        }
                    }
                    
                } else {
                    [self.planTimeArray addObject:@"全天"];
                }
            }
        }
        for (DataModel *model in targetArray) {
            if ([model done]) {
                [self.planIdArray addObject:[model targetUid]];
//                [self.planIdArray addObject:@"noid"];
                [self.planDoneArray addObject:@"Done"];
                [self.planDetailArray addObject:[model remark]];
                [self.planTypeArray addObject:[self.typeTitleArray objectAtIndex:[model type]]];
                [self.planTitleArray addObject:[model headLine]];
                if (![model wholeDay]) {
//                    NSDate *startDate = [df dateFromString:[model beganTime]];
//                    NSDate *endDate = [df dateFromString:[model endTime]];
                    
                    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                    //获取不同时间字段的信息
                    
//                    NSLog(@"%@", [model beganTime]);
                    
                    NSDateComponents *startComp = [gregorian components:unitFlags fromDate:[df dateFromString:[model beganTime]]];
                    NSDateComponents *endComp = [gregorian components:unitFlags fromDate:[df dateFromString:[model endTime]]];
                    NSDateComponents *todayComp = [gregorian components:unitFlags fromDate:[NSDate date]];
                    
                    if ((startComp.year == endComp.year) && (startComp.month == endComp.month) && (startComp.day == endComp.day)) {
                        [self.planTimeArray addObject:[NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld", startComp.hour, startComp.minute, endComp.hour, endComp.minute]];
                    } else {
//                        NSLog(@"%@", [NSString stringWithFormat:@"%ld.%02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day]);
                        if ((startComp.year == endComp.year) && (startComp.year == todayComp.year)) {
                            [self.planTimeArray addObject:[NSString stringWithFormat:@"%02ld.%02ld-%02ld.%02ld", startComp.month, startComp.day, endComp.month, endComp.day]];
                        } else {
                            [self.planTimeArray addObject:[NSString stringWithFormat:@"%ld%.02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day]];
                        }
                    }
                } else {
                    [self.planTimeArray addObject:@"全天"];
                }
                self.numberOfAllDayDone++;
            }
        }
        
        [[Manager sharedManager] NetworkGetAllTargetInDay:self.dateString succeed:^(TargetModel *targetModel) {
            
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSArray *targetArray = [targetModel data];
//            NSLog(@"%@", targetArray);
            for (DataModel *model in targetArray) {
//                NSLog(@"%d", [model done]);
                if (![model done]) {
                    [self.planIdArray insertObject:[model targetUid] atIndex:self.planIdArray.count - self.numberOfAllDayDone];
                    [self.planDetailArray insertObject:[model remark] atIndex:self.planDetailArray.count - self.numberOfAllDayDone];
                    [self.planTypeArray insertObject:[self.typeTitleArray objectAtIndex:[model type]] atIndex:self.planTypeArray.count - self.numberOfAllDayDone];
                    [self.planTitleArray insertObject:[model headLine] atIndex:self.planTitleArray.count - self.numberOfAllDayDone];
                    [self.planDoneArray insertObject:@"Undone" atIndex:self.planDoneArray.count - self.numberOfAllDayDone];
                    if (![model wholeDay]) {
    //                    NSDate *startDate = [df dateFromString:[model beganTime]];
    //                    NSDate *endDate = [df dateFromString:[model endTime]];
                        self.today = [NSDate date];
                        NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                        //获取不同时间字段的信息
                        
                        NSDateComponents *startComp = [gregorian components:unitFlags fromDate:[df dateFromString:[model beganTime]]];
                        NSDateComponents *endComp = [gregorian components:unitFlags fromDate:[df dateFromString:[model endTime]]];
                        NSDateComponents *todayComp = [gregorian components:unitFlags fromDate:[NSDate date]];
                        
                        if ((startComp.year == endComp.year) && (startComp.month == endComp.month) && (startComp.day == endComp.day)) {
    //                        NSLog(@"%@", [NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld", startComp.hour, startComp.minute, endComp.hour, endComp.minute]);
                            if ((startComp.hour == endComp.hour) && (startComp.minute == endComp.minute)) {
//                                [self.planTimeArray insertObject:[NSString stringWithFormat:@"%02ld.%02ld", startComp.month, startComp.day] atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                                [self.planTimeArray insertObject:@"" atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                            } else {
                                [self.planTimeArray insertObject:[NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld", startComp.hour, startComp.minute, endComp.hour, endComp.minute] atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                            }
                            
                        } else {
    //                        NSLog(@"%@", [NSString stringWithFormat:@"%ld.%02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day]);
                            if ((startComp.year == endComp.year) && (startComp.year == todayComp.year)) {
                                [self.planTimeArray insertObject:[NSString stringWithFormat:@"%02ld.%02ld-%02ld.%02ld", startComp.month, startComp.day, endComp.month, endComp.day] atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                            } else {
                                [self.planTimeArray insertObject:[NSString stringWithFormat:@"%ld%.02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day] atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                            }
                        }
                        
                    } else {
                        [self.planTimeArray insertObject:@"AllDay" atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                    }
                }
            }
            for (DataModel *model in targetArray) {
                if ([model done]) {
                    [self.planIdArray addObject:[model targetUid]];
                    [self.planDoneArray addObject:@"Done"];
                    [self.planDetailArray addObject:[model remark]];
                    [self.planTypeArray addObject:[self.typeTitleArray objectAtIndex:[model type]]];
                    [self.planTitleArray addObject:[model headLine]];
                    if (![model wholeDay]) {
    //                    NSDate *startDate = [df dateFromString:[model beganTime]];
    //                    NSDate *endDate = [df dateFromString:[model endTime]];
                        
                        NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                        //获取不同时间字段的信息
                        
    //                    NSLog(@"%@", [model beganTime]);
                        
                        NSDateComponents *startComp = [gregorian components:unitFlags fromDate:[df dateFromString:[model beganTime]]];
                        NSDateComponents *endComp = [gregorian components:unitFlags fromDate:[df dateFromString:[model endTime]]];
                        NSDateComponents *todayComp = [gregorian components:unitFlags fromDate:[NSDate date]];
                        
                        if ((startComp.year == endComp.year) && (startComp.month == endComp.month) && (startComp.day == endComp.day)) {
                            if ((startComp.hour == endComp.hour) && (startComp.minute == endComp.minute)) {
                                [self.planTimeArray addObject:@""];
                            } else {
                                [self.planTimeArray addObject:[NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld", startComp.hour, startComp.minute, endComp.hour, endComp.minute]];
                            }
                            
                        } else {
    //                        NSLog(@"%@", [NSString stringWithFormat:@"%ld.%02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day]);
                            if ((startComp.year == endComp.year) && (startComp.year == todayComp.year)) {
                                [self.planTimeArray addObject:[NSString stringWithFormat:@"%02ld.%02ld-%02ld.%02ld", startComp.month, startComp.day, endComp.month, endComp.day]];
                            } else {
                                [self.planTimeArray addObject:[NSString stringWithFormat:@"%ld%.02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day]];
                            }
                        }
                        
                    } else {
                        [self.planTimeArray addObject:@"AllDay"];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", self.planIdArray);
                [self.mainTableView reloadData];
            });
            
        } error:^(NSError *error) {
        
        }];
        
    } error:^(NSError *error) {
            
    }];
}

- (void)pressChange {
    [self.delegate presentChangeTargetPage];
}

- (void)pressIcon:(NSInteger)index {
//    NSLog(@"%ld", index);
//    NSLog(@"%@", [_planIdArray objectAtIndex:index]);
    if ([[self.planTimeArray objectAtIndex:index] isEqualToString:@"全天"]) {
        [[Manager sharedManager] NetworkChangeDailyTargetIsDoneWithTargetId:[_planIdArray objectAtIndex:index] andDay:_dateString finished:^(TargetModel *model) {
            
            [self getPlans];
            
        } error:^(NSError *error) {
                    
        }];
    } else {
        [[Manager sharedManager] NetworkChangeTargetIsDoneWithTargetId:[_planIdArray objectAtIndex:index] finished:^(TargetModel *model) {
            
            [self getPlans];
            
        } error:^(NSError *error) {
            
        }];
    }
}

@end
