//
//  LeftDrawerView.m
//  Persist
//
//  Created by 张博添 on 2022/1/18.
//

#import "LeftDrawerView.h"
#import <Masonry.h>
#import "LoginOrRegisterModel.h"
#import "LeftDrawerTableViewCell.h"
#import "CustomView.h"
#import <CoreMotion/CoreMotion.h>
#import "Manager.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 80.0;

@interface LeftDrawerView ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic, strong) UIButton *settingsButton;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *imageArray;

@property (nonatomic, strong) CMPedometer * pedometer;

@end

@implementation LeftDrawerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor redColor];
    _titleArray = @[@"我的等级", @"我的收藏", @"我的钱包", @"我的订单", @"我的购物车", @"百科知识", @"饮食工具", @"分类菜谱", @"我的目标", @"我的团队", @"身体测试", @"创作中心", @"关于我们"];
    
    _imageArray = @[[self scaleToSize:[UIImage imageNamed:@"guanfangbanben.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"xingzhuang-xingxing.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"qianbao.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"dingdan.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"gouwuchekong.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"baikezhishi.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"yinshi.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"caipu.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"mubiao.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"tuandui.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"shentijiance.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"chuangzuo.png"] size:CGSizeMake(30, 30)],
                    [self scaleToSize:[UIImage imageNamed:@"guanyu.png"] size:CGSizeMake(30, 30)]];
    
    [self buildUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage) name:@"changeHeadImage" object:nil];
    
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
    UITapGestureRecognizer *navigationBarViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNavigationBarView)];
    [_navigationBarView addGestureRecognizer:navigationBarViewTap];
#pragma mark 头像
    _headImageView = [[UIImageView alloc] init];
    [_navigationBarView addSubview:_headImageView];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = (navigationBarHeight - 20) / 2;
    [_headImageView setImage:[UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]]];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_navigationBarView.mas_top).offset(10);
        make.left.mas_equalTo(_navigationBarView.mas_left).offset(10);
        make.width.and.height.mas_equalTo(@(navigationBarHeight - 20));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    [_navigationBarView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:16 * (navigationBarHeight - 28) / (_nameLabel.font.lineHeight)];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.minimumScaleFactor = 0.5;
    [_nameLabel setText:[[LoginOrRegisterModel sharedModel] nickName]];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(7);
        make.top.mas_equalTo(_headImageView.mas_top).offset(5);
        make.bottom.mas_equalTo(_headImageView.mas_bottom).offset(5);
        make.right.mas_equalTo(_navigationBarView.mas_right).offset(-17);
    }];
    
    if (self.statusBarHeight == 20) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, selfViewHeight - 49, selfViewWidth, 49)];
    } else {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, selfViewHeight - 83, selfViewWidth, 83)];
    }
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    
    _helpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_bottomView addSubview:_helpButton];
    _helpButton.frame = CGRectMake(0, 0, selfViewWidth / 2, 49);
    
    [_helpButton setImage:[self scaleToSize:[UIImage imageNamed:@"kefu.png"] size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [_helpButton setTitle:@"帮助中心" forState:UIControlStateNormal];
    [_helpButton setTintColor:[UIColor blackColor]];
    
    _settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_bottomView addSubview:_settingsButton];
    _settingsButton.frame = CGRectMake(selfViewWidth / 2, 0, selfViewWidth / 2, 49);
    
    [_settingsButton setImage:[self scaleToSize:[UIImage imageNamed:@"shezhi.png"] size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [_settingsButton setTitle:@"设置" forState:UIControlStateNormal];
    [_settingsButton setTintColor:[UIColor blackColor]];
    [_settingsButton addTarget:self action:@selector(pressSettingsButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:view];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, navigationBarHeight - 0.5, selfViewWidth, 0.5)];
    view2.backgroundColor = [UIColor lightGrayColor];
    [_navigationBarView addSubview:view2];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight, selfViewWidth, selfViewHeight - (self.statusBarHeight + navigationBarHeight + _bottomView.bounds.size.height)) style:UITableViewStyleGrouped];
    [self addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    [_mainTableView registerClass:[LeftDrawerTableViewCell class] forCellReuseIdentifier:@"first"];
    [_mainTableView registerClass:[LeftDrawerTableViewCell class] forCellReuseIdentifier:@"normal"];
    _mainTableView.bounces = NO;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.sectionHeaderHeight = 0;
}

#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return selfViewWidth / 2;
    }
    return 55;
}

#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        LeftDrawerTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"first" forIndexPath:indexPath];
        
        CustomView *leftView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth / 2, selfViewWidth / 2)];
        [cell.contentView addSubview:leftView];
        leftView.titleLabel.text = @"今日运动";
        
        NSDate *today = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //设置自定义的格式模版
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [df stringFromDate:today];
//        NSLog(@"%@" , dateString);
        
        [[Manager sharedManager] NetworkGetSumRunningTime:dateString finished:^(RunningDataModelFirst *model) {
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                leftView.detailLabel.text = [NSString stringWithFormat:@"%@分钟", [model data]];
            });
            
        } error:^(NSError *error) {
            
        }];
        
        CustomView *rightView = [[CustomView alloc] initWithFrame:CGRectMake(selfViewWidth / 2, 0, selfViewWidth / 2, selfViewWidth / 2)];
        [cell.contentView addSubview:rightView];
        rightView.titleLabel.text = @"今日步数";
        
        NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        //获取当前日期
        
        //定义一个时间字段的旗标，指定会获取指定年、月、日、时、分、秒、星期的信息
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        //获取不同时间字段的信息
        NSDateComponents* comp = [gregorian components:unitFlags fromDate:today];
        NSDate* date2 = [gregorian dateFromComponents:comp];
#pragma mark 获取当日步数
        _pedometer = [[CMPedometer alloc] init];
        [_pedometer startPedometerUpdatesFromDate:date2 withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error = %@", error);
            } else {
                NSNumber *steps = pedometerData.numberOfSteps;
                NSNumber *distance = pedometerData.distance;
                NSDictionary *dic = @{@"steps":steps, @"distance":distance};
                dispatch_async(dispatch_get_main_queue(), ^(){
                    rightView.detailLabel.text = [NSString stringWithFormat:@"%@", [dic valueForKey:@"steps"]];
                });
                [self->_pedometer stopPedometerUpdates];
            }
        }];
        return cell;
    } else {
        LeftDrawerTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"normal" forIndexPath:indexPath];
        cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row - 1];
        cell.imageView.image = [_imageArray objectAtIndex:indexPath.row - 1];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
    } else if (indexPath.section == 0 && indexPath.row == 7) {
        [self.delegate presentFoodToolsPage];
    } else {
        
    }
}

- (void)tapNavigationBarView {
    [self.delegate presentPersonalHomePage];
}

- (void)pressSettingsButton {
    [self.delegate presentSettingsPage];
}

#pragma mark - 改变图像尺寸
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)updateSteps {
    [_mainTableView reloadData];
}

- (void)updateHeadImage {
    UIImage *headImage = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
    [_headImageView setImage:headImage];
}

@end
