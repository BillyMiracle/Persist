//
//  RunningPageView.m
//  Persist
//
//  Created by 张博添 on 2022/2/20.
//

#import "RunningPageView.h"
#import "Manager.h"
#import <Masonry.h>

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

@interface RunningPageView()

@property (nonatomic, assign, readonly) float statusBarHeight;

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *targetButton;
@property (nonatomic, strong) UIView *outdoorInfoView;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIImageView *weatherImageView;
@property (nonatomic, strong) UILabel *airLevelTitleLabel;
@property (nonatomic, strong) UILabel *tempTitleLabel;
@property (nonatomic, strong) UILabel *airLevelLabel;
@property (nonatomic, strong) UILabel *tempLabel;

@property (nonatomic, strong) UILabel *totalDistanceLabel;

@end

static const float navigationBarHeight = 50.0;

@implementation RunningPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self buildUI];
    [self networkGetWeather];
//    [self networkGetDistance];
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
    [self addSubview:_statusBarView];
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, selfViewWidth, navigationBarHeight)];
    [self addSubview:_navigationBarView];
    
#pragma mark 左上角标题
    UILabel *titleLabel = [[UILabel alloc] init];
    [_navigationBarView addSubview:titleLabel];
    titleLabel.text = @"跑步";
    titleLabel.font = [UIFont systemFontOfSize:16 * (navigationBarHeight - 15) / titleLabel.font.lineHeight];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_navigationBarView.mas_left).offset(10);
        make.top.mas_equalTo(self->_navigationBarView.mas_top).offset(10);
        make.bottom.mas_equalTo(self->_navigationBarView.mas_bottom).offset(-10);
    }];
    
#pragma mark 叉号返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(selfViewWidth - navigationBarHeight, 10, navigationBarHeight - 20, navigationBarHeight - 20);
    backButton.layer.masksToBounds = YES;
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = [UIColor grayColor].CGColor;
    backButton.layer.cornerRadius = (navigationBarHeight - 20) / 2;
    [backButton setTintColor:[UIColor grayColor]];
    [backButton setImage:[self scaleToSize:[UIImage imageNamed:@"x.png"] size:CGSizeMake(navigationBarHeight - 23, navigationBarHeight - 23)] forState:UIControlStateNormal];
    [_navigationBarView addSubview:backButton];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 选择器
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(selfViewWidth / 2 - 60, selfViewHeight  * 0.7 - 40 - selfViewWidth / 8, 120, 40)];
    [self addSubview:_segmentedControl];
    [_segmentedControl insertSegmentWithTitle:@"户外跑" atIndex:0 animated:NO];
    [_segmentedControl insertSegmentWithTitle:@"跑步机" atIndex:1 animated:NO];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl addTarget:self action:@selector(segmentControlValueChange) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 开始跑步按钮
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _startButton.frame = CGRectMake(selfViewWidth / 8 * 3, selfViewHeight * 0.7 - 40, selfViewWidth / 4, selfViewWidth / 4);
    _startButton.titleLabel.font = [UIFont systemFontOfSize:16 * (selfViewWidth / 14 / _startButton.titleLabel.font.lineHeight)];
    [self addSubview:_startButton];
    _startButton.layer.masksToBounds = YES;
    _startButton.layer.cornerRadius = selfViewWidth / 8;
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton setBackgroundColor:[UIColor colorWithRed:0.6 green:0.9 blue:0.4 alpha:1]];
    [_startButton setTintColor:[UIColor whiteColor]];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(selfViewHeight * 0.23);
        make.width.mas_equalTo(selfViewWidth / 4);
        make.height.mas_equalTo(selfViewWidth / 4);
    }];
    [_startButton addTarget:self action:@selector(pressStart) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 目标按钮
    _targetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _targetButton.titleLabel.font = [UIFont systemFontOfSize:16 * (selfViewWidth / 18 / _targetButton.titleLabel.font.lineHeight)];
    [self addSubview:_targetButton];
    _targetButton.layer.masksToBounds = YES;
    _targetButton.layer.cornerRadius = selfViewWidth / 12;
    [_targetButton setTitle:@"目标" forState:UIControlStateNormal];
    [_targetButton setBackgroundColor:[UIColor lightGrayColor]];
    [_targetButton setTintColor:[UIColor whiteColor]];
    [_targetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(-(selfViewWidth / 4));
        make.centerY.mas_equalTo(self.mas_centerY).offset(selfViewHeight * 0.23);
        make.width.mas_equalTo(selfViewWidth / 6);
        make.height.mas_equalTo(selfViewWidth / 6);
    }];
    [_targetButton addTarget:self action:@selector(pressTargetButton) forControlEvents:UIControlEventTouchUpInside];
    [self creatOutdoorInfoView];
    [self creatTotalDistance];
}
#pragma mark 天气信息
- (void)creatOutdoorInfoView {
    _outdoorInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight, selfViewWidth, 60)];
    [self addSubview:_outdoorInfoView];
//    _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(selfViewWidth - 260, 12, 36, 36)];
    _weatherImageView = [[UIImageView alloc] init];
    [_outdoorInfoView addSubview:_weatherImageView];
    
//    UILabel *tempTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth - 220, 5, 45, 50)];
    _tempTitleLabel = [[UILabel alloc] init];
    [_outdoorInfoView addSubview:_tempTitleLabel];
    _tempTitleLabel.text = @"温度：";
    
//    _tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth - 175, 5, 55, 50)];
    _tempLabel = [[UILabel alloc] init];
    [_outdoorInfoView addSubview:_tempLabel];
    
//    UILabel *airLevelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth - 120, 5, 80, 50)];
    _airLevelTitleLabel = [[UILabel alloc] init];
    [_outdoorInfoView addSubview:_airLevelTitleLabel];
    _airLevelTitleLabel.text = @"空气指数：";
    
//    _airLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth - 40, 5, 40, 50)];
    _airLevelLabel = [[UILabel alloc] init];
    [_outdoorInfoView addSubview:_airLevelLabel];
}
#pragma mark 跑步距离
- (void)creatTotalDistance {
    
    UIView *distanceView = [[UIView alloc] initWithFrame:CGRectMake(50, self.statusBarHeight + navigationBarHeight + 80, selfViewWidth - 100, 140)];
    [self addSubview:distanceView];
    distanceView.layer.masksToBounds = YES;
    distanceView.layer.borderColor = [UIColor purpleColor].CGColor;
    distanceView.layer.borderWidth = 1;
    distanceView.layer.cornerRadius = 10;
    
    UILabel *totalDistanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, selfViewWidth - 100, 40)];
    [distanceView addSubview:totalDistanceTitleLabel];
    totalDistanceTitleLabel.text = @"累计跑步距离";
    totalDistanceTitleLabel.font = [UIFont systemFontOfSize:16 * 35 / totalDistanceTitleLabel.font.lineHeight];
    totalDistanceTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _totalDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, selfViewWidth - 120, 60)];
    [distanceView addSubview:_totalDistanceLabel];
    _totalDistanceLabel.text = @"0.00km";
    _totalDistanceLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:16 * 40 / _totalDistanceLabel.font.lineHeight];
    _totalDistanceLabel.adjustsFontSizeToFitWidth = YES;
    _totalDistanceLabel.textAlignment = NSTextAlignmentCenter;
    
//    [self networkGetDistance];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake((selfViewWidth - 100) / 2 - 50, 110, 100, 18)];
    detailLabel.text = @"查看详情 >";
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.font = [UIFont systemFontOfSize:16 * 16 / detailLabel.font.lineHeight];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [distanceView addSubview:detailLabel];
    detailLabel.layer.masksToBounds = YES;
    detailLabel.layer.borderWidth = 1;
    detailLabel.layer.borderColor = [UIColor systemGreenColor].CGColor;
    detailLabel.layer.cornerRadius = 9;
    
    UIGestureRecognizer *tapOnDistanceView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressOnDetail)];
    [distanceView addGestureRecognizer:tapOnDistanceView];
    
}

- (void)pressOnDetail {
//    NSLog(@"pressOnDetail");
    [self.delegate presentDetailPage];
}

- (void)pressTargetButton {
    [self.delegate presentTargetPage];
}

- (void)segmentControlValueChange {
    if (_segmentedControl.selectedSegmentIndex == 1) {
        _outdoorInfoView.hidden = YES;
    } else {
        _outdoorInfoView.hidden = NO;
    }
}

- (void)goBack {
    [self.delegate goBackToMainPage];
}

- (void)pressStart {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        
        [self.delegate presentOutdoorRunningPage];
        
    } else {
        
        [self.delegate presentIndoorRunningPage];
        
    }
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

- (void)networkGetWeather {
    [[Manager sharedManager] NetworkGetWeatherFinished:^(NSDictionary *dict) {
//        NSLog(@"%@", dict);
        NSString *img = [dict valueForKey:@"weatherImg"];
        NSString *airLevel = [dict valueForKey:@"airLevel"];
        NSString *temp = [dict valueForKey:@"temp"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", img]];
            self.airLevelLabel.text = airLevel;
            self.tempLabel.text = temp;
            [self.airLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.outdoorInfoView.mas_top).offset(5);
                make.bottom.mas_equalTo(self.outdoorInfoView.mas_bottom).offset(-5);
                make.right.mas_equalTo(self.outdoorInfoView.mas_right).offset(-5);
            }];
            [self.airLevelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.outdoorInfoView.mas_top).offset(5);
                make.bottom.mas_equalTo(self.outdoorInfoView.mas_bottom).offset(-5);
                make.right.mas_equalTo(self.airLevelLabel.mas_left);
            }];
            [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.outdoorInfoView.mas_top).offset(5);
                make.bottom.mas_equalTo(self.outdoorInfoView.mas_bottom).offset(-5);
                make.right.mas_equalTo(self.airLevelTitleLabel.mas_left).offset(-5);
            }];
            [self.tempTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.outdoorInfoView.mas_top).offset(5);
                make.bottom.mas_equalTo(self.outdoorInfoView.mas_bottom).offset(-5);
                make.right.mas_equalTo(self.tempLabel.mas_left);
            }];
            [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.outdoorInfoView.mas_top).offset(10);
                make.bottom.mas_equalTo(self.outdoorInfoView.mas_bottom).offset(-10);
                make.right.mas_equalTo(self.tempTitleLabel.mas_left).offset(-5);
                make.width.mas_equalTo(40);
            }];
        });
    } error:^(NSError *error) {
            
    }];
}

- (void)networkGetDistance {
    
    [[Manager sharedManager] NetworkGetSumRunningDistanceFinished:^(RunningDataModelFirst *model) {
        
//        NSLog(@"%@", model);
        
        NSString *string = [NSString stringWithFormat:@"%@km", [model data]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalDistanceLabel.text = string;
        });
        
    } error:^(NSError *error) {
            
    }];
}

@end
