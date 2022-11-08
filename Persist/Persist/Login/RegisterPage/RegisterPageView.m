//
//  RegisterView.m
//  Persist
//
//  Created by 张博添 on 2022/1/4.
//

#import "RegisterPageView.h"
#import <Masonry.h>
#import "PasswordTextField.h"

#define screenWidth self.frame.size.width
#define screenHeight self.frame.size.height

#define textFieldHeight (screenHeight / 14)
#define textFieldHeightSecond (screenHeight / 13)

static const int textFieldFontSize = 20;
static const int NICKNAMEMAXLENGTH = 15;

@interface RegisterPageView ()
<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{    
    UIView *firstView;
    UIView *secondView;
    UIView *thirdView;
}

@property (nonatomic, strong) UILabel *cautionLabel;
@property (nonatomic, strong) UILabel *cautionLabelSecond;

@property (nonatomic, assign, readonly) float statusBarHeight;

@property (nonatomic, strong) UIPickerView *genderPickerView; // 选择器视图
@property (nonatomic, copy) NSArray *genderDataSourceArray;   // 数据源数组

@property (nonatomic, strong) UIPickerView *agePickerView;
@property (nonatomic, copy) NSMutableArray *ageDataSourceArray;

@property (nonatomic, strong) UILabel *genderSetLabel;
@property (nonatomic, strong) UILabel *ageSetLabel;

@end
@implementation RegisterPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self buildDataArrays];
    [self buildUI];
    return self;
}

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
//    NSLog(@"statusBarHeight %f", statusBarManager2.statusBarFrame.size.height);
    return statusBarManager2.statusBarFrame.size.height;
}

#pragma mark - InitUI
- (void)buildUI {
    _registerLabel = [[UILabel alloc] init];
    [self addSubview:_registerLabel];
    _registerLabel.frame = CGRectMake(20, self.statusBarHeight + 15, screenWidth - 40, 40);
    _registerLabel.font = [UIFont systemFontOfSize:27];
    _registerLabel.textAlignment = NSTextAlignmentCenter;
    _registerLabel.text = @"首次注册";
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    _titleLabel.frame = CGRectMake(20, self.statusBarHeight + 55, screenWidth - 40, 40);
    _titleLabel.font = [UIFont systemFontOfSize:25];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
#pragma mark 输入密码框，禁止粘贴
    firstView = [[UIView alloc] init];
    [self addSubview:firstView];
    _passwordTextFieldFirst = [[PasswordTextField alloc] init];
    [firstView addSubview:_passwordTextFieldFirst];
    firstView.frame = CGRectMake(textFieldHeight / 2, self.statusBarHeight + 110, screenWidth - textFieldHeight, textFieldHeight);
    _passwordTextFieldFirst.frame = CGRectMake(textFieldHeight / 2, 0, screenWidth - textFieldHeight * 2, textFieldHeight);
    firstView.layer.masksToBounds = YES;
    firstView.layer.cornerRadius = textFieldHeight / 2;
    firstView.layer.borderWidth = 1;
    _passwordTextFieldFirst.font = [UIFont systemFontOfSize:textFieldFontSize];
    _passwordTextFieldFirst.placeholder = @"请设置密码";
    _passwordTextFieldFirst.delegate = self;
    _passwordTextFieldFirst.secureTextEntry = YES;
    _passwordTextFieldFirst.keyboardType = UIKeyboardTypeAlphabet;
    
#pragma mark 确认密码框，禁止粘贴
    secondView = [[UIView alloc] init];
    [self addSubview:secondView];
    _passwordTextFieldConfirm = [[PasswordTextField alloc] init];
    [secondView addSubview:_passwordTextFieldConfirm];
    secondView.frame = CGRectMake(textFieldHeight / 2, self.statusBarHeight + 110 + textFieldHeight * 7 / 6, screenWidth - textFieldHeight, textFieldHeight);
    _passwordTextFieldConfirm.frame = CGRectMake(textFieldHeight / 2, 0, screenWidth - textFieldHeight * 2, textFieldHeight);
    secondView.layer.masksToBounds = YES;
    secondView.layer.cornerRadius = textFieldHeight / 2;
    secondView.layer.borderWidth = 1;
    _passwordTextFieldConfirm.font = [UIFont systemFontOfSize:textFieldFontSize];
    _passwordTextFieldConfirm.placeholder = @"请确认密码";
    _passwordTextFieldConfirm.delegate = self;
    _passwordTextFieldConfirm.secureTextEntry = YES;
    _passwordTextFieldConfirm.keyboardType = UIKeyboardTypeAlphabet;
    
#pragma mark 确认按钮
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_confirmButton];
    _confirmButton.frame = CGRectMake(textFieldHeight / 2, screenHeight * 14 / 15 - textFieldHeight, screenWidth - textFieldHeight, textFieldHeight);
    [self setConfirmButtonOff];
    [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_confirmButton.layer setMasksToBounds:YES];
    _confirmButton.layer.cornerRadius = textFieldHeight / 2;
    _confirmButton.layer.borderWidth = 0;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:textFieldFontSize];
    
    _cautionLabel = [[UILabel alloc] init];
    [self addSubview:_cautionLabel];
    [_cautionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    _cautionLabel.text = @"请确认两次输入的密码一致";
    _cautionLabel.textColor = [UIColor systemRedColor];
    _cautionLabel.hidden = YES;
    
    _cautionLabelSecond = [[UILabel alloc] init];
    [self addSubview:_cautionLabelSecond];
    [_cautionLabelSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cautionLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    _cautionLabelSecond.text = @"密码长度应为6～16";
    _cautionLabelSecond.textColor = [UIColor systemRedColor];
    _cautionLabelSecond.hidden = YES;
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

#pragma mark - 正在输入，限制输入
//限制密码框输入长度与内容
//限制昵称框输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    if (textField == _passwordTextFieldFirst || textField == _passwordTextFieldConfirm) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex];
            //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) {
                return NO; // 48 unichar for 0
            } else if (character > 57 && character < 65) {
                return NO;
            } else if (character > 90 && character < 97) {
                return NO;
            } else if (character > 122) {
                return NO;
            }
        }
        NSUInteger newlength = textField.text.length + string.length - range.length;
        return newlength <= 16;
    }
    return YES;
}

#pragma mark - 输入结束，控制提示Label
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField == _passwordTextFieldConfirm) {
        if ([_passwordTextFieldConfirm.text isEqualToString:_passwordTextFieldFirst.text] && ![_passwordTextFieldFirst.text isEqualToString:@""]) {
            [self setConfirmButtonOn];
            _cautionLabel.hidden = YES;
        } else {
            _cautionLabel.hidden = NO;
            [self setConfirmButtonOff];
        }
    } else if (textField == _passwordTextFieldFirst) {
        //控制长度
        if (_passwordTextFieldFirst.text.length < 6 || _passwordTextFieldFirst.text.length > 16) {
            _cautionLabelSecond.hidden = NO;
            [self setConfirmButtonOff];
        } else {
            _cautionLabelSecond.hidden = YES;
            [self setConfirmButtonOn];
        }
        if ([_passwordTextFieldConfirm.text isEqualToString:_passwordTextFieldFirst.text] && ![_passwordTextFieldFirst.text isEqualToString:@""]) {
            [self setConfirmButtonOn];
            _cautionLabel.hidden = YES;
        } else {
            if (![_passwordTextFieldConfirm.text isEqualToString:@""]) {
                _cautionLabel.hidden = NO;
            }
            [self setConfirmButtonOff];
        }
    } else if (textField == _emailTextField) {
        
        if ([self isValidateEmail:_emailTextField.text]) {
            [self setConfirmButtonOn];
        } else {
            [self setConfirmButtonOff];
        }
        
    }
}
#pragma mark - 设置昵称
- (void)setNickname {
    _registerLabel.text = @"初来乍到";
    _titleLabel.text = @"设置一个适合你的昵称吧";
    
    //清除密码控件
    firstView.hidden = YES;
    secondView.hidden = YES;
    
    [firstView removeFromSuperview];
    [secondView removeFromSuperview];
    
    //设置确认按钮
    [self setConfirmButtonOff];
    
    thirdView = [[UIView alloc] init];
    [self addSubview:thirdView];
    
    _nameTextField = [[UITextField alloc] init];
    [thirdView addSubview:_nameTextField];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.font = [UIFont systemFontOfSize:textFieldFontSize + 1];
    _nameTextField.placeholder = @"请设置昵称";
    _nameTextField.delegate = self;
    _nameTextField.keyboardType = UIKeyboardTypeDefault;
    //清除按钮
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    thirdView.layer.masksToBounds = YES;
    thirdView.layer.cornerRadius = textFieldHeightSecond / 2;
    thirdView.layer.borderWidth = 1;
    
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(@(textFieldHeightSecond));
        make.left.mas_equalTo(self.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(self.mas_right).offset(-textFieldHeightSecond / 2);
    }];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thirdView.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(thirdView.mas_right).offset(-textFieldHeightSecond / 2);
        make.top.mas_equalTo(thirdView.mas_top);
        make.bottom.mas_equalTo(thirdView.mas_bottom);
    }];
    [_nameTextField addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark - 监听函数，控制昵称框输入长度
//包括粘贴的长度也可以控制
- (void)limit:(UITextField *)textField {
    if (textField == _nameTextField) {
        if ([textField markedTextRange]) {
    //有选中区域比如打拼音时，只限制最终的字数，不限制拼音长度
        } else if (textField.text.length > NICKNAMEMAXLENGTH) {
            textField.text = [textField.text substringToIndex:NICKNAMEMAXLENGTH];
        } else if (textField.text.length >= 1) {
            //长度大于一可以点确定
            [self setConfirmButtonOn];
        } else if (textField.text.length == 0) {
            //长度为0不可以点确定
            [self setConfirmButtonOff];
        }
    }
}
#pragma mark - 设置头像
- (void)setHeadImage {
    
    [_genderPickerView removeFromSuperview];
    [_agePickerView removeFromSuperview];
    
    [_genderSetLabel removeFromSuperview];
    [_ageSetLabel removeFromSuperview];
    
//    thirdView.hidden = YES;
    
    _registerLabel.text = @"挑选头像";
    _titleLabel.text = @"让大家更快记住你吧";
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    //设置确认按钮
    [self setConfirmButtonOff];
    
    _headImageView = [[UIImageView alloc] init];
    [self addSubview: _headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(200);
    }];
    _headImageView.backgroundColor = [UIColor grayColor];
    _headImageView.userInteractionEnabled = YES;
}

#pragma mark - 设置邮箱

- (void)setEmail {
    _registerLabel.text = @"设置邮箱";
    _titleLabel.text = @"让大家更快记住你吧";
    
//    _nameTextField.hidden = YES;
    [_nameTextField removeFromSuperview];
    
    //设置确认按钮
    [self setConfirmButtonOff];
    
    _emailTextField = [[UITextField alloc] init];
    [thirdView addSubview:_emailTextField];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _emailTextField.font = [UIFont systemFontOfSize:textFieldFontSize + 1];
    _emailTextField.placeholder = @"请设置邮箱";
    _emailTextField.delegate = self;
    _emailTextField.keyboardType = UIKeyboardTypeDefault;
    //清除按钮
    _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    [_emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thirdView.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(thirdView.mas_right).offset(-textFieldHeightSecond / 2);
        make.top.mas_equalTo(thirdView.mas_top);
        make.bottom.mas_equalTo(thirdView.mas_bottom);
    }];
    
}

#pragma mark - 设置年龄性别

- (void)setAgeAndGender {
    _registerLabel.text = @"完善资料";
    _titleLabel.text = @"";
    thirdView.hidden = YES;
    _emailTextField.hidden = YES;
    [thirdView removeFromSuperview];
    
    _genderPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, screenHeight * 0.4, (screenWidth - 60) / 2, 100)];
    _genderPickerView.dataSource = self;
    _genderPickerView.delegate = self;
    [self addSubview:_genderPickerView];
    
    _agePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake((screenWidth - 60) / 2 + 20, screenHeight * 0.4 - 40, (screenWidth - 60) / 2, 180)];
    _agePickerView.dataSource = self;
    _agePickerView.delegate = self;
    [self addSubview:_agePickerView];
    [_agePickerView selectRow:17 inComponent:0 animated:NO];
    
    _ageSetLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 60) / 2 + 20, screenHeight * 0.4 - 60, (screenWidth - 60) / 2, 20)];
    [self addSubview:_ageSetLabel];
    _ageSetLabel.text = @"设置年龄";
    _ageSetLabel.textAlignment = NSTextAlignmentCenter;
    
    _genderSetLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight * 0.4 - 60, (screenWidth - 60) / 2, 20)];
    [self addSubview:_genderSetLabel];
    _genderSetLabel.text = @"设置性别";
    _genderSetLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - 初始化数组
- (void)buildDataArrays {
    _ageDataSourceArray = [[NSMutableArray alloc] init];
    _genderDataSourceArray = @[@"男", @"女"];
    _age = @"18";
    _gender = @"男";
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//     NSLog(@"全局队列 ＋ 异步----%@", [NSThread currentThread]);
    //队列中添加异步任务
    dispatch_async(queue, ^{
        for (int i = 1; i < 121; i++) {
            [self.ageDataSourceArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    });
}

#pragma mark - UIPickerViewDataSource

// 返回需要展示的列（columns）的数目
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 返回每一列的行（rows）数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _genderPickerView) {
        return _genderDataSourceArray.count;
    } else {
        return _ageDataSourceArray.count;
    }
}

#pragma mark - UIPickerViewDelegate

// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _genderPickerView) {
        return [_genderDataSourceArray objectAtIndex:row];
    } else {
        return [_ageDataSourceArray objectAtIndex:row];
    }
}

// 某一行被选择时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _genderPickerView) {
        _gender = [_genderDataSourceArray objectAtIndex:row];
    } else {
        _age = [_ageDataSourceArray objectAtIndex:row];
    }
}

#pragma mark - 判断邮箱格式
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
