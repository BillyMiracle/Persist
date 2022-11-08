//
//  IndoorRunningPageView.m
//  Persist
//
//  Created by 张博添 on 2022/2/22.
//

#import "IndoorRunningPageView.h"
#import <Masonry.h>
#import <CoreMotion/CoreMotion.h>

//#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 50.0;

@interface IndoorRunningPageView()

@property (nonatomic, assign, readonly) float statusBarHeight;

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;

@property (nonatomic, strong) UILabel *lengthLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stepLabel;

@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *continueButton;

@property (nonatomic, strong) CMPedometer * pedometer;

@property (nonatomic, strong) NSTimer *myTimer;

@property (nonatomic, strong) NSTimer *buttonTimer;

@end

@implementation IndoorRunningPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self buildUI];
    
    _totalDistance = 0;
    _totalSteps = 0;
    _time = 0;
    
    _pedometer = [[CMPedometer alloc] init];
//    [self startRunning];
    
//    [self buildTimer];
    
    return self;
}

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

#pragma mark buildUI
- (void)buildUI {
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, self.statusBarHeight)];
    [self addSubview:_statusBarView];
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, selfViewWidth, navigationBarHeight)];
    [self addSubview:_navigationBarView];
    
#pragma mark 左上角标题
    UILabel *titleLabel = [[UILabel alloc] init];
    [_navigationBarView addSubview:titleLabel];
    titleLabel.text = @"跑步机";
    titleLabel.font = [UIFont systemFontOfSize:16 * (navigationBarHeight - 15) / titleLabel.font.lineHeight];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_navigationBarView.mas_left).offset(10);
        make.top.mas_equalTo(self->_navigationBarView.mas_top).offset(10);
        make.bottom.mas_equalTo(self->_navigationBarView.mas_bottom).offset(-10);
    }];
    
    [self buildLengthLabels];
    [self buildTimeLabels];
    [self buildSpeedLabels];
    [self buildStepLabels];
    
    [self buildPauseButton];
    [self buildContinueButton];
    [self buildStopButton];
}

#pragma mark 距离标签
- (void)buildLengthLabels {
    UILabel *lengthTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, selfViewHeight * 0.33, selfViewWidth - 100, 40)];
    [self addSubview:lengthTitleLabel];
    lengthTitleLabel.text = @"公里";
    lengthTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _lengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, selfViewHeight * 0.33 - 80, selfViewWidth - 100, 80)];
    [self addSubview:_lengthLabel];
    _lengthLabel.textAlignment = NSTextAlignmentCenter;
    _lengthLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:16 * 80 / _lengthLabel.font.lineHeight];
    _lengthLabel.text = @"0.00";
}

#pragma mark 时间标签
- (void)buildTimeLabels {
    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth * 0.3, selfViewHeight * 0.6, selfViewWidth * 0.4, 40)];
    [self addSubview:timeTitleLabel];
    timeTitleLabel.text = @"时间";
    timeTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth * 0.3, selfViewHeight * 0.6 - 50, selfViewWidth * 0.4, 50)];
    _timeLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:16 * 45 / _timeLabel.font.lineHeight];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_timeLabel];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"00:00:00";
}

#pragma mark 速度标签
- (void)buildSpeedLabels {
    UILabel *speedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, selfViewHeight * 0.6, selfViewWidth * 0.3 - 10, 40)];
    [self addSubview:speedTitleLabel];
    speedTitleLabel.text = @"公里/小时";
    speedTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, selfViewHeight * 0.6 - 50, selfViewWidth * 0.3 - 20, 50)];
    [self addSubview:_speedLabel];
    _speedLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:16 * 45 / _speedLabel.font.lineHeight];
    _speedLabel.adjustsFontSizeToFitWidth = YES;
    _speedLabel.text = @"0.0";
    _speedLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark 步数标签
- (void)buildStepLabels {
    UILabel *stepTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth * 0.7, selfViewHeight * 0.6, selfViewWidth * 0.3 - 10, 40)];
    [self addSubview:stepTitleLabel];
    stepTitleLabel.text = @"步数";
    stepTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth * 0.7 + 10, selfViewHeight * 0.6 - 50, selfViewWidth * 0.3 - 20, 50)];
    [self addSubview:_stepLabel];
    _stepLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:16 * 45 / _stepLabel.font.lineHeight];
    _stepLabel.adjustsFontSizeToFitWidth = YES;
    _stepLabel.text = @"0";
    _stepLabel.textAlignment = NSTextAlignmentCenter;
    
}

#pragma mark 暂停按钮
- (void)buildPauseButton {
    _pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_pauseButton];
    _pauseButton.frame = CGRectMake(selfViewWidth / 8 * 3, selfViewHeight * 0.7, selfViewWidth / 4, selfViewWidth / 4);
    [_pauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [_pauseButton addTarget:self action:@selector(pressPauseButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressPauseButton {
    [UIView animateWithDuration:0.3 animations:^{
        self->_pauseButton.frame = CGRectMake(selfViewWidth / 2, selfViewHeight * 0.7 + selfViewWidth / 8, 1, 1);
    } completion:^(BOOL finished) {
        self.pauseButton.hidden = YES;
        self.continueButton.hidden = NO;
        self.stopButton.hidden = NO;
        [self continueButtonAndStopButtonShowWithAnimation];
    }];
    [self pauseRunning];
    [self pauseTimer];
}

- (void)continueButtonAndStopButtonShowWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.continueButton.frame = CGRectMake(selfViewWidth / 8 * 1.7, selfViewHeight * 0.7, selfViewWidth / 4, selfViewWidth / 4);
        self.stopButton.frame = CGRectMake(selfViewWidth / 8 * 4.3, selfViewHeight * 0.7, selfViewWidth / 4, selfViewWidth / 4);
        } completion:^(BOOL finished) {
            
    }];
}

#pragma mark 继续按钮
- (void)buildContinueButton {
    
    _continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_continueButton];
    _continueButton.frame = CGRectMake(selfViewWidth / 8 * 2.7, selfViewHeight * 0.7 + selfViewWidth / 8, 1, 1);
    _continueButton.hidden = YES;
    [_continueButton setBackgroundImage:[UIImage imageNamed:@"continue.png"] forState:UIControlStateNormal];
    [_continueButton addTarget:self action:@selector(pressContinueButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressContinueButton {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.continueButton.frame = CGRectMake(selfViewWidth / 8 * 2.7, selfViewHeight * 0.7 + selfViewWidth / 8, 1, 1);
        self.stopButton.frame = CGRectMake(selfViewWidth / 8 * 5.3, selfViewHeight * 0.7 + selfViewWidth / 8, 1, 1);
    } completion:^(BOOL finished){
        self.continueButton.hidden = YES;
        self.stopButton.hidden = YES;
        self.pauseButton.hidden = NO;
        [self pauseButtonShowWithAnimation];
    }];
    [self continueRunning];
    [self continueTimer];
}

- (void)pauseButtonShowWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.pauseButton.frame = CGRectMake(selfViewWidth / 8 * 3, selfViewHeight * 0.7, selfViewWidth / 4, selfViewWidth / 4);
//        self.pauseButton.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark 停止按钮
- (void)buildStopButton {
    
    _stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_stopButton];
    _stopButton.frame = CGRectMake(selfViewWidth / 8 * 5.3, selfViewHeight * 0.7 + selfViewWidth / 8, 1, 1);
    _stopButton.hidden = YES;
    [_stopButton setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    
//    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressStopButton:)];
//    longPress.minimumPressDuration = 0.1;
//    [_stopButton addGestureRecognizer:longPress];
    
    [_stopButton addTarget:self action:@selector(pressStopButton) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//- (void)longPressStopButton:(UILongPressGestureRecognizer *)longPress {
//    switch (longPress.state) {
//        case UIGestureRecognizerStateBegan: {
//
//            NSLog(@"Began");
//            break;
//        }
//
//        case UIGestureRecognizerStateEnded: {
//
//            NSLog(@"Ended");
//            break;
//        }
//        case UIGestureRecognizerStateChanged: {
//
//        }
//        default:
//            break;
//    }
//}
//- (void)timerEvent {
//
//}
//
//- (void)setPercet:(CGFloat)percent withTimer:(CGFloat)time {
//
//}

- (void)pressStopButton {
    self.stopButton.userInteractionEnabled = NO;
    [self.delegate stopRunning];
}

#pragma mark 开始跑步
- (void)startRunning {

    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSNumber *number = pedometerData.numberOfSteps;
        NSNumber *number2 = pedometerData.distance;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeStep:number and:number2];
        });
    }];
}

- (void)changeStep:(NSNumber *)numberOfSteps and:(NSNumber *)distance {
    _stepLabel.text = [NSString stringWithFormat:@"%d", _totalSteps + [numberOfSteps intValue]];
    _lengthLabel.text = [NSString stringWithFormat:@"%.2f", (_totalDistance + [distance floatValue]) / 1000];
}

#pragma mark 暂停跑步
- (void)pauseRunning {
    [_pedometer stopPedometerUpdates];
    _totalSteps = _stepLabel.text.intValue;
    _totalDistance = _lengthLabel.text.floatValue * 1000;
}

#pragma mark 继续跑步
- (void)continueRunning {
    [self startRunning];
}

#pragma mark 计时器
- (void)buildTimer {
    //初始化定时器
    _myTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    //将定时器加入主循环中
    [[NSRunLoop mainRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
    [_myTimer fire];
}

- (void)pauseTimer {
    [_myTimer invalidate];
    _myTimer = nil;
}

- (void)continueTimer {
    _myTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    //将定时器加入主循环中
    [[NSRunLoop mainRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
    [_myTimer fire];
}

- (void)updateTime {
    _time++;
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", _time / 3600, (_time % 3600) / 60, _time % 60];
    if (_lengthLabel.text.floatValue != 0) {
        _speedLabel.text = [NSString stringWithFormat:@"%.2f", _lengthLabel.text.floatValue / _time * 3600];
    }
}

@end
