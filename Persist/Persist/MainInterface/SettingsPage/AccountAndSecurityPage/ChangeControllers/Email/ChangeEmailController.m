//
//  ChangeEmailController.m
//  Persist
//
//  Created by 张博添 on 2022/3/22.
//

#import "ChangeEmailController.h"
#import <Masonry.h>

#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height

#define textFieldHeightSecond (screenHeight / 13)

static const int textFieldFontSize = 23; //字体大小

@interface ChangeEmailController ()
<UITextFieldDelegate>
{
    UIView *firstView;
    float textFieldHeight;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UITextField *emailTextField;

@end

@implementation ChangeEmailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
#pragma mark 标题初始化
    _titleLabel = [[UILabel alloc] init];
    [self.view addSubview:_titleLabel];
    [_titleLabel setText:@"更改邮箱"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:28];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
    }];
    
    textFieldHeight = screenHeight / 13;
    
#pragma mark 第一个密码框
    firstView = [[UIView alloc] init];
    [self.view addSubview:firstView];
    firstView.layer.masksToBounds = YES;
    firstView.layer.cornerRadius = textFieldHeightSecond / 2;
    firstView.layer.borderWidth = 1;
    
    _emailTextField = [[UITextField alloc] init];
    [firstView addSubview:_emailTextField];
    _emailTextField.borderStyle = UITextBorderStyleNone;
    _emailTextField.font = [UIFont systemFontOfSize:textFieldFontSize + 1];
    _emailTextField.placeholder = @"请输入新邮箱";
    _emailTextField.delegate = self;
    _emailTextField.keyboardType = UIKeyboardTypeDefault;
    //清除按钮
    _emailTextField.secureTextEntry = YES;
    _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(@(textFieldHeightSecond));
        make.left.mas_equalTo(self.view.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(self.view.mas_right).offset(-textFieldHeightSecond / 2);
    }];
    [_emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstView.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(firstView.mas_right).offset(-textFieldHeightSecond / 2);
        make.top.mas_equalTo(firstView.mas_top);
        make.bottom.mas_equalTo(firstView.mas_bottom);
    }];
    
#pragma mark 确认按钮
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_confirmButton];
    _confirmButton.frame = CGRectMake(textFieldHeight / 2, screenHeight * 13 / 15 - textFieldHeight, screenWidth - textFieldHeight, textFieldHeight);
    [self setConfirmButtonOff];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton.layer setMasksToBounds:YES];
    _confirmButton.layer.cornerRadius = textFieldHeight / 2;
    _confirmButton.layer.borderWidth = 0;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:textFieldFontSize];
    
    [_confirmButton addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark 点击确认按钮
- (void)pressConfirm {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark textFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField == _emailTextField) {
        
        if ([self isValidateEmail:_emailTextField.text]) {
            [self setConfirmButtonOn];
        } else {
            [self setConfirmButtonOff];
        }
        
    }
}

#pragma mark - 判断邮箱格式
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 收回键盘
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_emailTextField resignFirstResponder];
}


@end
