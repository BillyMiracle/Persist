//
//  ChangeTargetPageView.m
//  Persist
//
//  Created by 张博添 on 2022/3/17.
//

#import "ChangeTargetPageView.h"
#import "PasswordTextField.h"
#import <Masonry.h>
#import "Manager.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const int textFieldFontSize = 20;

static const float navigationBarHeight = 50.0;

@interface ChangeTargetPageView()

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) PasswordTextField *timeTextField;

@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation ChangeTargetPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self buildUI];
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
    
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_navigationBarView addSubview:_backButton];
    _backButton.frame = CGRectMake(10, 10, navigationBarHeight - 20, navigationBarHeight - 20);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(navigationBarHeight, 0, selfViewWidth - 2 * navigationBarHeight, navigationBarHeight)];
    [_navigationBarView addSubview:_titleLabel];
    _titleLabel.text = @"调整目标";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16 * (_titleLabel.frame.size.height - 18) / _titleLabel.font.lineHeight];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_confirmButton];
    _confirmButton.frame = CGRectMake((selfViewHeight / 14) / 2, selfViewHeight * 14 / 15 - (selfViewHeight / 14), selfViewWidth - (selfViewHeight / 14), (selfViewHeight / 14));
    [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
    [_confirmButton.layer setMasksToBounds:YES];
    _confirmButton.layer.cornerRadius = (selfViewHeight / 14) / 2;
    _confirmButton.layer.borderWidth = 0;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:textFieldFontSize];
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [_confirmButton setTintColor:[UIColor blackColor]];
    _confirmButton.userInteractionEnabled = YES;
    [_confirmButton addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    
    _timeTextField = [[PasswordTextField alloc] initWithFrame:CGRectMake(selfViewWidth * 0.3, self.statusBarHeight + navigationBarHeight + 50, selfViewWidth * 0.3, 50)];
    [self addSubview:_timeTextField];
    [_timeTextField setFont:[UIFont systemFontOfSize:16]];
    [_timeTextField setFont:[UIFont systemFontOfSize:16 * 48 / _timeTextField.font.lineHeight]];
    _timeTextField.textAlignment = NSTextAlignmentCenter;
    _timeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_timeTextField.frame.origin.x, _timeTextField.frame.origin.y + _timeTextField.frame.size.height, _timeTextField.frame.size.width, 1)];
    [self addSubview:lineView];
    [lineView setBackgroundColor:[UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1]];
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth * 0.6, self.statusBarHeight + navigationBarHeight + 50, selfViewWidth * 0.2, 50)];
    [self addSubview:_subLabel];
    [_subLabel setText:@"分钟"];
    [_subLabel setFont:[UIFont systemFontOfSize:22]];
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_timeTextField.mas_bottom);
        make.left.mas_equalTo(_timeTextField.mas_right);
    }];
    
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.text = @"范围5～80，建议30";
    [self addSubview:_hintLabel];
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeTextField.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (void)pressBackButton {
    [self.delegate pressBack];
}
#pragma mark 点击确认
- (void)pressConfirm {
    if ([_timeTextField.text isEqualToString:@""]) {
        [self.delegate cautionShow];
    } else if (_timeTextField.text.intValue > 80 || _timeTextField.text.intValue < 5) {
        [self.delegate cautionShow];
    } else {
        [_confirmButton setUserInteractionEnabled:NO];
//        [[Manager sharedManager] NetworkUpdateRunTargetAt:self.dateString andTarget:_timeTextField.text finished:^(RunningDataModelFirst *model) {
//            [self.delegate pressBack];
//        } error:^(NSError *error) {
//            [self.confirmButton setUserInteractionEnabled:YES];
//        }];
        [self.delegate pressBack];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_timeTextField resignFirstResponder];
}

- (void)showData {
    _timeTextField.text = self.originalTarget;
}

@end
