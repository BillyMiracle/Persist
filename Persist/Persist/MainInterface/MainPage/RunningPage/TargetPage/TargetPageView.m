//
//  TargetPageView.m
//  Persist
//
//  Created by 张博添 on 2022/2/20.
//

#import "TargetPageView.h"
#import <Masonry.h>

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

#define buttonHeight (selfViewHeight / 14)

@interface TargetPageView()
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign, readonly) float statusBarHeight;

@property (nonatomic, strong) UIPickerView *mainPickerView;
@property (nonatomic, copy) NSArray *lengthArray;
@property (nonatomic, strong) NSMutableArray *timeArray;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UILabel *speedReedLabel;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *confirmButton;

@end

static const NSInteger labelFontSize = 34;
static const float navigationBarHeight = 50.0;

@implementation TargetPageView

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
#pragma mark 滚轮
    
    _mainPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 170, selfViewWidth - 100, selfViewHeight - 250)];
    [self addSubview:_mainPickerView];
    _mainPickerView.delegate = self;
    _mainPickerView.dataSource = self;
#pragma mark 初始化数组
    _lengthArray = @[@"自定义", @"0.80", @"1.00", @"2.00", @"3.00", @"4.00", @"5.00", @"6.00", @"7.00", @"8.00", @"9.00", @"10.00", @"15.00", @"20.00", @"21.25", @"42.25"];
    //初始化时间数组
    _timeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 10; i++) {
        for (int j = 0; j <= 5; j++) {
            if (i != 0 || j != 0) {
                [self->_timeArray addObject:[NSString stringWithFormat:@"%02d:%02d:00", i, j * 10]];
            }
        }
    }
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(50, _mainPickerView.frame.origin.y, selfViewWidth - 100, _mainPickerView.center.y - _mainPickerView.frame.origin.y - 20 - 40)];
    [self addSubview:_coverView];
    _coverView.backgroundColor = [UIColor whiteColor];
    
#pragma mark 距离标题
    UILabel *lengthLabel = [[UILabel alloc] init];
    [_coverView addSubview:lengthLabel];
    [lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverView.mas_left);
        make.bottom.mas_equalTo(_coverView.mas_bottom);
        make.right.mas_equalTo(_coverView.mas_centerX);
        make.height.mas_equalTo(50);
    }];
    lengthLabel.text = @"距离";
    lengthLabel.textAlignment = NSTextAlignmentCenter;
    lengthLabel.font = [UIFont systemFontOfSize:labelFontSize];
    
#pragma mark 时间标题
    UILabel *timeLabel = [[UILabel alloc] init];
    [_coverView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverView.mas_centerX);
        make.bottom.mas_equalTo(_coverView.mas_bottom);
        make.right.mas_equalTo(_coverView.mas_right);
        make.height.mas_equalTo(50);
    }];
    timeLabel.text = @"时间";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont  systemFontOfSize:labelFontSize];
    
    
#pragma mark 配速标题
    UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 70, selfViewWidth - 100, 50)];
    speedLabel.textAlignment = NSTextAlignmentCenter;
    speedLabel.font = [UIFont systemFontOfSize:labelFontSize];
    speedLabel.text = @"配速";
    [self addSubview:speedLabel];
    
    
#pragma mark 配速标签
    _speedReedLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, selfViewWidth - 100, 50)];
    _speedReedLabel.textAlignment = NSTextAlignmentCenter;
    _speedReedLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:labelFontSize + 2];
    [self addSubview:_speedReedLabel];
    
    [_mainPickerView selectRow:1 inComponent:0 animated:NO];
    float length = [[_lengthArray objectAtIndex:[_mainPickerView selectedRowInComponent:0]] doubleValue];
    float time = ([_mainPickerView selectedRowInComponent:1] + 1) * 10;
    [_speedReedLabel setText:[NSString stringWithFormat:@"%02d'%02d", (int)(time / length * 60) / 60, (int)(time / length * 60) % 60]];
    
#pragma mark 返回按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_backButton];
    _backButton.frame = CGRectMake(10, self.statusBarHeight + 10, navigationBarHeight - 20, navigationBarHeight - 20);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 确认按钮
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_confirmButton];
   
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-(selfViewHeight / 15));
        make.left.mas_equalTo(self.mas_left).offset(buttonHeight / 2);
        make.right.mas_equalTo(self.mas_right).offset(-(buttonHeight / 2));
        make.height.mas_equalTo(buttonHeight);
    }];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton.layer setMasksToBounds:YES];
    _confirmButton.layer.cornerRadius = buttonHeight / 2;
    _confirmButton.layer.borderWidth = 0;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [_confirmButton setTintColor:[UIColor blackColor]];
    [_confirmButton addTarget:self action:@selector(pressConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

// 返回需要展示的列（columns）的数目
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// 返回每一列的行（rows）数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return _lengthArray.count;
    } else {
        return _timeArray.count;
    }
}

// 设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return (selfViewWidth - 100) / 2;
    } else {
        return (selfViewWidth - 100) / 2;
    }
}

// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_lengthArray objectAtIndex:row];;
    } else {
        return [_timeArray objectAtIndex:row];
    }
}

// 某一行被选择时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    float length = [[_lengthArray objectAtIndex:[_mainPickerView selectedRowInComponent:0]] doubleValue];
    float time = ([_mainPickerView selectedRowInComponent:1] + 1) * 10.0;
//    NSLog(@"%f %f", (time / length * 60) / 60, (time / length * 60));
    
    [_speedReedLabel setText:[NSString stringWithFormat:@"%02d'%02d", (int)(time / length * 60) / 60, (int)(time / length * 60) % 60]];
    
}

- (void)pressBackButton {
    [self.delegate goBackToRunningPage];
}

- (void)pressConfirmButton {
    int time = ([_mainPickerView selectedRowInComponent:1] + 1) * 10.0;
    float length = [[_lengthArray objectAtIndex:[_mainPickerView selectedRowInComponent:0]] floatValue];
    NSDictionary *infoDic = @{@"selectedTimeIndex":[NSNumber numberWithLong:[_mainPickerView selectedRowInComponent:1]], @"selectedLengthIndex":[NSNumber numberWithLong:[_mainPickerView selectedRowInComponent:0]], @"selectedTimeInSeconds":[NSNumber numberWithInt:time], @"selectedLengthInKiloMeters":[NSNumber numberWithFloat:length]};
    [self.delegate confirmWithInfo:infoDic];
}

- (void)TPV_adjustTargetWithIndex:(NSInteger)indexOne and:(NSInteger)indexTwo {
    [_mainPickerView selectRow:indexOne inComponent:0 animated:NO];
    [_mainPickerView selectRow:indexTwo inComponent:1 animated:NO];
}

@end
