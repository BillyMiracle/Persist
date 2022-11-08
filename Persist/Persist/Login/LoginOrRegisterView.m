//
//  LoginOrRegisterView.m
//  Persist
//
//  Created by 张博添 on 2021/12/28.
//

#import "LoginOrRegisterView.h"
#import "Masonry.h"
#import "PasswordTextField.h"

#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#define screenWidth self.frame.size.width
#define screenHeight self.frame.size.height

static const int textFieldFontSize = 23; //字体大小
static const int PHONEMAXLENGTH = 11;    //电话号码长度
static const int CODEMAXLENGTH = 6;      //验证码长度
static int amountOfTimeLeft = 60;               //倒计时

@interface LoginOrRegisterView ()
<UITextFieldDelegate>
{
    UIView *passwordView;
    NSTimer *countDownTimer;
}

@property (assign, nonatomic) CGFloat textFieldHeight;

@end

@implementation LoginOrRegisterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self buildUI];
    return self;
}

- (void)buildUI {
#pragma mark 切换按钮初始化
    _switchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_switchButton];
    [_switchButton setTitle:@"密码登录" forState:UIControlStateNormal];
    _switchButton.tintColor = [UIColor blackColor];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(statusBarHeight + 30);
        make.centerX.mas_equalTo(self.mas_right).offset(-80);
    }];
    [_switchButton addTarget:self action:@selector(pressSwitch) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 标题初始化
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    [_titleLabel setText:@"手机号登录/注册"];
    _titleLabel.font = [UIFont systemFontOfSize:30];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(statusBarHeight + 100);
        make.left.mas_equalTo(self.mas_left).offset(40);
    }];
    
    self.textFieldHeight = screenHeight / 13;
    
#pragma mark 账号框初始化
    UIView *accountView = [[UIView alloc] init];
    [self addSubview:accountView];
    
    _phoneNumberTextField = [[UITextField alloc] init];
    [accountView addSubview:_phoneNumberTextField];
    _phoneNumberTextField.borderStyle = UITextBorderStyleNone;
    _phoneNumberTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
    _phoneNumberTextField.placeholder = @"请输入手机号码";
    _phoneNumberTextField.delegate = self;
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    //设置监听
    [_phoneNumberTextField addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
    //清除按钮
    _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    accountView.layer.masksToBounds = YES;
    accountView.layer.cornerRadius = _textFieldHeight / 2;
    accountView.layer.borderWidth = 1;
    
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-_textFieldHeight * 2);
        make.height.mas_equalTo(@(_textFieldHeight));
        make.left.mas_equalTo(self.mas_left).offset(_textFieldHeight / 2);
        make.right.mas_equalTo(self.mas_right).offset(-_textFieldHeight / 2);
    }];
    [_phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountView.mas_left).offset(_textFieldHeight / 2);
        make.right.mas_equalTo(accountView.mas_right).offset(-_textFieldHeight / 2);
        make.top.mas_equalTo(accountView.mas_top);
        make.bottom.mas_equalTo(accountView.mas_bottom);
    }];
    
#pragma mark 密码框初始化
    passwordView = [[UIView alloc] init];
    [self addSubview:passwordView];
    passwordView.layer.masksToBounds = YES;
    passwordView.layer.cornerRadius = _textFieldHeight / 2;
    passwordView.layer.borderWidth = 1;
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.mas_centerY).offset(-_textFieldHeight * 2 / 3);
        make.top.mas_equalTo(accountView.mas_bottom).offset(_textFieldHeight / 6);
        make.height.mas_equalTo(@(_textFieldHeight));
        make.left.mas_equalTo(accountView.mas_left);
        make.right.mas_equalTo(accountView.mas_right);
    }];
    //添加输入框
    [self useMessage];
    
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_loginButton];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:textFieldFontSize - 1];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.borderWidth = 0;
    _loginButton.layer.cornerRadius = _textFieldHeight / 2;
    [_loginButton setTitle:@"一键登录/注册" forState:UIControlStateNormal];
    [self setLoginButtonOff];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordView.mas_bottom).offset(_textFieldHeight / 3);
        make.height.mas_equalTo(@(_textFieldHeight));
        make.left.mas_equalTo(accountView.mas_left);
        make.right.mas_equalTo(accountView.mas_right);
    }];
    
    _touristButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_touristButton];
    [_touristButton setTitle:@"随便逛逛" forState:UIControlStateNormal];
    [_touristButton setTintColor:[UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1]];
    [_touristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginButton.mas_bottom).offset(_textFieldHeight / 6);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}
#pragma mark - 切换登录模式
- (void)pressSwitch {
    if ([_switchButton.titleLabel.text isEqualToString:@"密码登录"]) {
        [self usePassword];
        _sendCodeButton.hidden = YES;
        [self setSendButtonOn];
        [_sendCodeButton setTitle:@"发送" forState:UIControlStateNormal];
        [countDownTimer invalidate];
    } else {
        [self useMessage];
        _sendCodeButton.hidden = NO;
    }
    _phoneNumberTextField.enabled = YES;
    _phoneNumberTextField.text = @"";
    _passwordTextField.text = @"";
    [self setLoginButtonOff];
}
#pragma mark - 验证码框输入
- (void)useMessage {
//初始化发送验证码按钮
    if (_sendCodeButton == nil) {
        _sendCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        double codeButtonWidth = _textFieldHeight * 4 / 3;
        _sendCodeButton.frame = CGRectMake(screenWidth - _textFieldHeight - codeButtonWidth, 0, codeButtonWidth, _textFieldHeight);
        [passwordView addSubview:_sendCodeButton];
        [_sendCodeButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendCodeButton.layer.masksToBounds = YES;
        _sendCodeButton.layer.borderWidth = 1;
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:textFieldFontSize - 1];
        [_sendCodeButton addTarget:self action:@selector(pressSendCodeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    [self setSendButtonOff];
    [_passwordTextField removeFromSuperview];
    _passwordTextField = [[UITextField alloc] init];
    [passwordView addSubview:_passwordTextField];
    _passwordTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.delegate = self;
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordView.mas_left).offset(_textFieldHeight / 2);
//        make.right.mas_equalTo(passwordView.mas_right).offset(-_textFieldHeight / 2);
        make.right.mas_equalTo(_sendCodeButton.mas_left);
        make.top.mas_equalTo(passwordView.mas_top);
        make.bottom.mas_equalTo(passwordView.mas_bottom);
    }];
    _passwordTextField.enabled = NO;
//注册监听
    [_passwordTextField addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
    [_switchButton setTitle:@"密码登录" forState:UIControlStateNormal];
    [_titleLabel setText:@"手机号登录/注册"];
    _passwordTextField.placeholder = @"请输入验证码";
    [_loginButton setTitle:@"一键登录/注册" forState:UIControlStateNormal];
}
#pragma mark - 密码框输入，禁止粘贴
- (void)usePassword {
    [_passwordTextField removeFromSuperview];
    _passwordTextField = [[PasswordTextField alloc] init];
    [passwordView addSubview:_passwordTextField];
    _passwordTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.delegate = self;
    _passwordTextField.keyboardType = UIKeyboardTypeAlphabet;
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordView.mas_left).offset(_textFieldHeight / 2);
        make.right.mas_equalTo(passwordView.mas_right).offset(-_textFieldHeight / 2);
        make.top.mas_equalTo(passwordView.mas_top);
        make.bottom.mas_equalTo(passwordView.mas_bottom);
    }];
    _passwordTextField.delegate = self;
    _passwordTextField.enabled = NO;
    [_switchButton setTitle:@"验证码登录" forState:UIControlStateNormal];
    [_titleLabel setText:@"密码登录"];
    _passwordTextField.placeholder = @"请输入密码";
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _passwordTextField.secureTextEntry = YES;
}
#pragma mark - 限制密码框输入内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    if (textField == _passwordTextField) {
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
    }
    return YES;
}
#pragma mark - 输入结束，更改按钮与输入框状态
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    //密码框在输入
    if (textField == _passwordTextField) {
        //密码输入
        if ([_titleLabel.text isEqualToString:@"密码登录"]) {
            //输入了密码
            if ([self CheckPhoneNumInput:_phoneNumberTextField.text] && ![_passwordTextField.text isEqualToString:@""]) {
                [self setLoginButtonOn];
            } else {
                [self setLoginButtonOff];
            }
        } else {//验证码输入
            if ([self CheckPhoneNumInput:_phoneNumberTextField.text] && [self CheckVerificationCodeInput:_passwordTextField.text]) {
                //验证码与手机的格式均正确
                [self setLoginButtonOn];
            } else {
                [self setLoginButtonOff];
            }
        }
    } else if (textField == _phoneNumberTextField) {//电话号码框在输入
        if ([self CheckPhoneNumInput:textField.text]) {
            if (![_titleLabel.text isEqualToString:@"密码登录"]) {
        //输入电话号码后允许发送验证码
                [self setSendButtonOn];
            } else {
        //使用密码登录允许输入密码
                _passwordTextField.enabled = YES;
            }
            
        } else {
            _passwordTextField.text = @"";
            _passwordTextField.enabled = NO;
            [self setLoginButtonOff];
        }
    }
}

#pragma mark - 按发送验证码按钮
- (void)pressSendCodeButton {
    [self creatTimerFunction];
    _passwordTextField.enabled = YES;
    [self setSendButtonOff];
    [_sendCodeButton setTitle:[NSString stringWithFormat:@"%02ds", amountOfTimeLeft] forState:UIControlStateNormal];
    _phoneNumberTextField.enabled = NO;
    _phoneNumber = _phoneNumberTextField.text;
    
}

#pragma mark - 生成计时器
- (void)creatTimerFunction {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    NSRunLoop* mainloop = [NSRunLoop mainRunLoop];
    [mainloop addTimer:timer forMode:NSRunLoopCommonModes];
    countDownTimer = timer;
}

- (void)timerCountDown {
    //未到一分钟
    if (amountOfTimeLeft > 0) {
        amountOfTimeLeft--;
        [_sendCodeButton setTitle:[NSString stringWithFormat:@"%02ds", amountOfTimeLeft] forState:UIControlStateNormal];
        
    } else {//时限已到
        
        [countDownTimer invalidate];
        countDownTimer = nil;
        amountOfTimeLeft = 60;
        [self setSendButtonOn];
        [_sendCodeButton setTitle:@"发送" forState:UIControlStateNormal];
        _phoneNumberTextField.enabled = YES;
        
    }
}


#pragma mark- 判断手机号码
- (BOOL)CheckPhoneNumInput:(NSString *)phone {
    NSString *Regex = @"(13[0-9]|14[57]|15[012356789]|18[012356789])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:phone];
}
#pragma mark- 判断验证码
- (BOOL)CheckVerificationCodeInput:(NSString *)code {
    NSString *Regex = @"\\d{6}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
//    NSLog(@"%d", [mobileTest evaluateWithObject:code]);
    return [mobileTest evaluateWithObject:code];
}

#pragma mark- 更改登录按钮状态
- (void)setLoginButtonOn {
    _loginButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [_loginButton setTintColor:[UIColor blackColor]];
    _loginButton.userInteractionEnabled = YES;
}

- (void)setLoginButtonOff {
    _loginButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:0.7];
    [_loginButton setTintColor:[UIColor darkGrayColor]];
    _loginButton.userInteractionEnabled = NO;
}

#pragma mark - 更改验证码按钮状态
- (void)setSendButtonOn {
    [_sendCodeButton setTintColor:[UIColor blackColor]];
    _sendCodeButton.userInteractionEnabled = YES;
}

- (void)setSendButtonOff {
    [_sendCodeButton setTintColor:[UIColor darkGrayColor]];
    _sendCodeButton.userInteractionEnabled = NO;
}


#pragma mark - 监听函数，控制电话框输入长度
//包括粘贴的长度也可以控制
- (void)limit:(UITextField *)textField{
    if (textField == _phoneNumberTextField) {
        if (textField.text.length > PHONEMAXLENGTH){
            textField.text = [textField.text substringToIndex:PHONEMAXLENGTH];
        }
    } else if (textField == _passwordTextField) {
        if (textField.text.length > CODEMAXLENGTH){
            textField.text = [textField.text substringToIndex:CODEMAXLENGTH];
        }
    }
}

@end
#pragma mark - 学习内容：
//NSPredicate模式字符串
//textField监听，代理函数和方法重写
