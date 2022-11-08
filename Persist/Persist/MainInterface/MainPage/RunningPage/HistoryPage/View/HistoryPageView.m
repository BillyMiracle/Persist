//
//  HistoryPageView.m
//  Persist
//
//  Created by 张博添 on 2022/3/29.
//

#import "HistoryPageView.h"
#import "HistoryTableViewCell.h"
#import "Manager.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 50.0;

@interface HistoryPageView()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *runWhenDataArray;
@property (nonatomic, strong) NSMutableArray *runTimeDataArray;
@property (nonatomic, strong) NSMutableArray *distanceDataArray;

@end

@implementation HistoryPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    _runWhenDataArray = [[NSMutableArray alloc] init];
    _runTimeDataArray = [[NSMutableArray alloc] init];
    _distanceDataArray = [[NSMutableArray alloc] init];
    
    [self buildUI];
    [self getData];
    return self;
}

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

- (void)buildUI {
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight + self.statusBarHeight, selfViewWidth, selfViewHeight - navigationBarHeight - self.statusBarHeight)style:UITableViewStyleGrouped];
    _mainTableView.sectionHeaderHeight = 0;
    _mainTableView.sectionFooterHeight = 0;
    [self addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, self.statusBarHeight)];
    _statusBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_statusBarView];
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, selfViewWidth, navigationBarHeight)];
    _navigationBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_navigationBarView];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_navigationBarView addSubview:_backButton];
    _backButton.frame = CGRectMake(10, 10, navigationBarHeight - 20, navigationBarHeight - 20);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(navigationBarHeight, 0, selfViewWidth - 2 * navigationBarHeight, navigationBarHeight)];
    [_navigationBarView addSubview:_titleLabel];
    _titleLabel.text = @"跑步详情记录";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16 * (_titleLabel.frame.size.height - 18) / _titleLabel.font.lineHeight];

}
#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _distanceDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return selfViewHeight / 8;
}

#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [[HistoryTableViewCell alloc] init];
    
    cell.distanceLabel.text = [_distanceDataArray objectAtIndex:indexPath.row];
    cell.runTimeLabel.text = [_runTimeDataArray objectAtIndex:indexPath.row];
    cell.runWhenLabel.text = [_runWhenDataArray objectAtIndex:indexPath.row];
    
    return cell;
}
#pragma mark DidSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
#pragma mark 返回
- (void)pressBackButton {
    [self.delegate goBack];
}

- (void)getData {
    [[Manager sharedManager] NetworkGetAllRunHistoryFinished:^(RunningModelSecond *model) {
        NSArray *array = [model data];
        for (RunningDataModel *model in array) {

            [self.runWhenDataArray insertObject:[model runWhen] atIndex:0];
            [self.runTimeDataArray insertObject:[NSString stringWithFormat:@"%@min", [model runTime]] atIndex:0];
            [self.distanceDataArray insertObject:[NSString stringWithFormat:@"%@km", [model distance]] atIndex:0];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        });

    } error:^(NSError *error) {

    }];
//离线
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        [self.runWhenDataArray removeAllObjects];
//        [self.runTimeDataArray removeAllObjects];
//        [self.distanceDataArray removeAllObjects];
//        [self.runWhenDataArray addObject:@"2022-3-14 16:56:00"];[self.runWhenDataArray addObject:@"2022-3-14 20:00:00"];
//        [self.runTimeDataArray addObject:[NSString stringWithFormat:@"%.1fmin", (float)(rand() % 150)]];
//        [self.runTimeDataArray addObject:[NSString stringWithFormat:@"%.1fmin", (float)(rand() % 150)]];
//        [self.distanceDataArray addObject:[NSString stringWithFormat:@"%.2fkm", (float)(rand() % 15)]];
//        [self.distanceDataArray addObject:[NSString stringWithFormat:@"%.2fkm", (float)(rand() % 16)]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//    //            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.mainTableView reloadData];
//        });
//    });
    
}

@end
