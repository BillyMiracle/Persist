//
//  MainPageView.m
//  Persist
//
//  Created by 张博添 on 2022/1/4.
//

#import "MainPageView.h"
#import "LoginOrRegisterModel.h"
#import "MainPageSearchTableViewCell.h"
#import "MainPageInformationTableViewCell.h"
#import "MainPageFunctionCollectionViewCell.h"
#import "PlansTableViewCell.h"
#import "PlansTableViewCell.h"
#import "Manager.h"
#import "SDWebImage.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 50.0;

@interface MainPageView ()
<UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource,
PlansTableViewCellDelegate>

@property (nonatomic, assign, readonly) float statusBarHeight;

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *headImageButton;
@property (nonatomic, strong) UICollectionView *functionCollectionView;

@property (nonatomic, copy) NSArray *nameArray;
@property (nonatomic, copy) NSArray *iconNameArray;

@property (nonatomic, strong) NSMutableArray *planIdArray;
@property (nonatomic, strong) NSMutableArray *planTitleArray;
@property (nonatomic, strong) NSMutableArray *planDetailArray;
@property (nonatomic, strong) NSMutableArray *planDoneArray;
@property (nonatomic, strong) NSMutableArray *planTypeArray;
@property (nonatomic, strong) NSMutableArray *planTimeArray;

@property (nonatomic, assign) int numberOfAllDayDone;

@property (nonatomic, strong) NSArray *typeTitleArray;

@property (nonatomic, strong) NSString *dateString;

@end

@implementation MainPageView
    
- (instancetype)initWithFrame:(CGRect)frame {
    
//    NSLog(@"%@", [[LoginOrRegisterModel sharedModel] headImagePath]);
    
    _planIdArray = [[NSMutableArray alloc] init];
    _planDoneArray = [[NSMutableArray alloc] init];
    _planTitleArray = [[NSMutableArray alloc] init];
    _planDetailArray = [[NSMutableArray alloc] init];
    _planTypeArray = [[NSMutableArray alloc] init];
    _planTimeArray = [[NSMutableArray alloc] init];
    
    _typeTitleArray = @[@"work", @"study", @"life", @"meal", @"rest", @"shopping", @"sport", @"travel"];
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self buildUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"newTarget" object:nil];
    
    return self;
}

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

- (void)buildUI {
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight + self.statusBarHeight, selfViewWidth, selfViewHeight - navigationBarHeight - self.statusBarHeight) style:UITableViewStyleGrouped];
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
//    _mainTableView.backgroundColor = [UIColor whiteColor];
    
    [_mainTableView registerClass:[MainPageSearchTableViewCell class] forCellReuseIdentifier:@"search"];
    [_mainTableView registerClass:[MainPageInformationTableViewCell class] forCellReuseIdentifier:@"information"];
    [_mainTableView registerClass:[PlansTableViewCell class] forCellReuseIdentifier:@"plan"];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tip"];
    
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
    
//    [self reloadTargets];
}

- (void)pressHeadImageButton {
    [self.delegate openDrawerView];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
         MainPageSearchTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
        
        return cell;
        
    }  else if (indexPath.section == 1) {
        
        MainPageInformationTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"information" forIndexPath:indexPath];
        
        return cell;
    } else {
//        MainPageInformationTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"information" forIndexPath:indexPath];
//
//        return cell;
        
        if (_planIdArray.count == 0) {
            UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"tip" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"诶，你似乎还没有计划哦，快去创建一些呀～";
            return cell;
        }
        
        PlansTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"plan" forIndexPath:indexPath];
        
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
        if (![[_planTimeArray objectAtIndex:indexPath.row] isEqualToString:@"AllDay"]) {
            cell.timeLabel.text = [_planTimeArray objectAtIndex:indexPath.row];
        } else {
            cell.timeLabel.text = @"";
        }
        
        cell.delegate = self;
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return (_planIdArray.count < 1 ? 1 : _planIdArray.count);
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    } else if (indexPath.section == 1) {
        return 40;
    } else {
        return (selfViewHeight / 14 > 60 ? selfViewHeight / 14 : 60);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return selfViewWidth / 4;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - 功能条
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        if (!_functionCollectionView) {
            //创建一个layout布局类
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            //设置布局方向
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            //设置每个item的大小
            layout.itemSize = CGSizeMake(selfViewWidth / 4, selfViewWidth / 4);
            _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewWidth / 4) collectionViewLayout:layout];
            _functionCollectionView.backgroundColor = [UIColor whiteColor];
            _functionCollectionView.delegate = self;
            _functionCollectionView.dataSource = self;
            [_functionCollectionView registerClass:[MainPageFunctionCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
            _nameArray = @[@"计划", @"跑步", @"饮食工具", @"更多"];
            _iconNameArray = @[@"lesson.png", @"run.png", @"FoodTools.png", @"more.png"];
        }
        return _functionCollectionView;
        
    } else {
        return nil;
    }
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainPageFunctionCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[_iconNameArray objectAtIndex:indexPath.row]];
    
    return cell;
}

//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self.delegate presentPlanPage];
            
        } else if (indexPath.row == 1) {
            
            [self.delegate pushToRunningPage];
            
        } else if (indexPath.row == 2) {
            
            [self.delegate pushToFoodToolsPage];
            
        } else {
            
        }
    }
    
}

- (void)updateHeadImage {
//    NSLog(@"%@", [[LoginOrRegisterModel sharedModel] imageData]);
    UIImage *headImage = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
    [_headImageButton setBackgroundImage:headImage forState:UIControlStateNormal];
    [self reloadTargets];
}

- (void)reloadTargets {
//    [self.planIdArray removeAllObjects];
//    [self.planDoneArray removeAllObjects];
//    [self.planDetailArray removeAllObjects];
//    [self.planTypeArray removeAllObjects];
//    [self.planTitleArray removeAllObjects];
//    [self.planTimeArray removeAllObjects];
//    self.numberOfAllDayDone = 0;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.mainTableView reloadData];
//    });
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //设置自定义的格式模版
    [df setDateFormat:@"yyyy-MM-dd"];
    _dateString = [df stringFromDate:[NSDate date]];
    
    [[Manager sharedManager] NetworkGetDailyTargetListWithDay:_dateString succeed:^(TargetModel *targetModel) {
        [self.planIdArray removeAllObjects];
        [self.planDoneArray removeAllObjects];
        [self.planDetailArray removeAllObjects];
        [self.planTypeArray removeAllObjects];
        [self.planTitleArray removeAllObjects];
        [self.planTimeArray removeAllObjects];
        self.numberOfAllDayDone = 0;
        
        NSDateFormatter* df2 = [[NSDateFormatter alloc] init];
        [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
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
                    
                    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                    //获取不同时间字段的信息
                    
                    NSDateComponents *startComp = [gregorian components:unitFlags fromDate:[df2 dateFromString:[model beganTime]]];
                    NSDateComponents *endComp = [gregorian components:unitFlags fromDate:[df2 dateFromString:[model endTime]]];
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
        NSLog(@"%@", self.planIdArray);
        NSLog(@"%@", self.planTimeArray);
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
                    
                    NSDateComponents *startComp = [gregorian components:unitFlags fromDate:[df2 dateFromString:[model beganTime]]];
                    NSDateComponents *endComp = [gregorian components:unitFlags fromDate:[df2 dateFromString:[model endTime]]];
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
        NSLog(@"%@", self.planIdArray);
        NSLog(@"%@", self.planTimeArray);
        [[Manager sharedManager] NetworkGetAllTargetsSucceed:^(TargetModel *allTargetmodel) {
            
            NSDateFormatter* df3 = [[NSDateFormatter alloc] init];
            [df3 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSArray *targetArray = [allTargetmodel data];
//            NSLog(@"%@", allTargetmodel);
            
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
                        
                        NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                        //获取不同时间字段的信息
                        
                        NSDateComponents *startComp = [gregorian components:unitFlags fromDate:[df3 dateFromString:[model beganTime]]];
                        NSDateComponents *endComp = [gregorian components:unitFlags fromDate:[df3 dateFromString:[model endTime]]];
                        NSDateComponents *todayComp = [gregorian components:unitFlags fromDate:[NSDate date]];
                        
                        if ((startComp.year == endComp.year) && (startComp.month == endComp.month) && (startComp.day == endComp.day)) {
    //                        NSLog(@"%@", [NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld", startComp.hour, startComp.minute, endComp.hour, endComp.minute]);
                            [self.planTimeArray insertObject:[NSString stringWithFormat:@"%02ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day] atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                        } else {
    //                        NSLog(@"%@", [NSString stringWithFormat:@"%ld.%02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day]);
                            if ((startComp.year == endComp.year) && (startComp.year == todayComp.year)) {
                                [self.planTimeArray insertObject:[NSString stringWithFormat:@"%02ld.%02ld-%02ld.%02ld", startComp.month, startComp.day, endComp.month, endComp.day] atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                            } else {
                                [self.planTimeArray insertObject:[NSString stringWithFormat:@"%ld%.02ld.%02ld-%ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day, endComp.year, endComp.month, endComp.day] atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                            }
                        }
                        
                    } else {
                        [self.planTimeArray insertObject:@"全天" atIndex:self.planTimeArray.count - self.numberOfAllDayDone];
                    }
                }
            }
            NSLog(@"%@", self.planIdArray);
            NSLog(@"%@", self.planTimeArray);
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
                        
                        NSDateComponents *startComp = [gregorian components:unitFlags fromDate:[df3 dateFromString:[model beganTime]]];
                        NSDateComponents *endComp = [gregorian components:unitFlags fromDate:[df3 dateFromString:[model endTime]]];
                        NSDateComponents *todayComp = [gregorian components:unitFlags fromDate:[NSDate date]];
                        
                        if ((startComp.year == endComp.year) && (startComp.month == endComp.month) && (startComp.day == endComp.day)) {
                            [self.planTimeArray addObject:[NSString stringWithFormat:@"%02ld.%02ld.%02ld", startComp.year, startComp.month, startComp.day]];
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
            NSLog(@"%@", self.planIdArray);
            NSLog(@"%@", self.planTimeArray);
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"%@", self.planIdArray);
                [self.mainTableView reloadData];
            });
            
        } error:^(NSError *error) {
        
        }];
    } error:^(NSError *error) {
            
    }];
}

- (void)reload:(NSNotification *)noti {
    [self reloadTargets];
}

- (void)pressIcon:(NSInteger)index {
    NSLog(@"%ld", index);
//    NSLog(@"%@", _planIdArray);
//    NSLog(@"%@", _planTimeArray);
    if ([[self.planTimeArray objectAtIndex:index] isEqualToString:@"全天"]) {
        NSLog(@"%@ %@", [_planIdArray objectAtIndex:index], _dateString);
        [[Manager sharedManager] NetworkChangeDailyTargetIsDoneWithTargetId:[_planIdArray objectAtIndex:index] andDay:_dateString finished:^(TargetModel *model) {

            [self reloadTargets];
            
        } error:^(NSError *error) {
                    
        }];
    } else {
        [[Manager sharedManager] NetworkChangeTargetIsDoneWithTargetId:[_planIdArray objectAtIndex:index] finished:^(TargetModel *model) {
            
            [self reloadTargets];
            
        } error:^(NSError *error) {
            
        }];
    }
}

@end
