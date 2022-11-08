//
//  ChangePasswordController.m
//  Persist
//
//  Created by 张博添 on 2022/3/22.
//

#import "ChangePasswordController.h"
#import <Masonry.h>
#import "LoginOrRegisterModel.h"
#import "PasswordTextField.h"

#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height

#define textFieldHeightSecond (screenHeight / 13)

static const int textFieldFontSize = 23; //字体大小

@interface ChangePasswordController ()
<UITextFieldDelegate>
{
    UIView *firstView;
    UIView *secondView;
    float textFieldHeight;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) PasswordTextField *previousPasswordTextField;
@property (nonatomic, strong) PasswordTextField *confirmPasswordTextField;

@property (nonatomic, strong) UILabel *cautionLabel;
@property (nonatomic, strong) UILabel *cautionLabelSecond;

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark 标题初始化
    _titleLabel = [[UILabel alloc] init];
    [self.view addSubview:_titleLabel];
    [_titleLabel setText:@"更改密码"];
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
    
    _previousPasswordTextField = [[PasswordTextField alloc] init];
    [firstView addSubview:_previousPasswordTextField];
    _previousPasswordTextField.borderStyle = UITextBorderStyleNone;
    _previousPasswordTextField.font = [UIFont systemFontOfSize:textFieldFontSize + 1];
    _previousPasswordTextField.placeholder = @"请确认旧密码";
    _previousPasswordTextField.delegate = self;
    _previousPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    //清除按钮
    _previousPasswordTextField.secureTextEntry = YES;
    
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(@(textFieldHeightSecond));
        make.left.mas_equalTo(self.view.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(self.view.mas_right).offset(-textFieldHeightSecond / 2);
    }];
    [_previousPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstView.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(firstView.mas_right).offset(-textFieldHeightSecond / 2);
        make.top.mas_equalTo(firstView.mas_top);
        make.bottom.mas_equalTo(firstView.mas_bottom);
    }];
    
#pragma mark 第二个密码框
    secondView = [[UIView alloc] init];
    [self.view addSubview:secondView];
    secondView.layer.masksToBounds = YES;
    secondView.layer.cornerRadius = textFieldHeightSecond / 2;
    secondView.layer.borderWidth = 1;
    secondView.hidden = YES;
    
    _confirmPasswordTextField = [[PasswordTextField alloc] init];
    [secondView addSubview:_confirmPasswordTextField];
    _confirmPasswordTextField.borderStyle = UITextBorderStyleNone;
    _confirmPasswordTextField.font = [UIFont systemFontOfSize:textFieldFontSize + 1];
    _confirmPasswordTextField.placeholder = @"请确认新密码";
    _confirmPasswordTextField.delegate = self;
    _confirmPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    //清除按钮
    _confirmPasswordTextField.secureTextEntry = YES;
    
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(firstView.mas_bottom).offset(20);
        make.height.mas_equalTo(@(textFieldHeightSecond));
        make.left.mas_equalTo(self.view.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(self.view.mas_right).offset(-textFieldHeightSecond / 2);
    }];
    [_confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(secondView.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(secondView.mas_right).offset(-textFieldHeightSecond / 2);
        make.top.mas_equalTo(secondView.mas_top);
        make.bottom.mas_equalTo(secondView.mas_bottom);
    }];
    
#pragma mark 注意标签
    _cautionLabel = [[UILabel alloc] init];
    [self.view addSubview:_cautionLabel];
    [_cautionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    _cautionLabel.text = @"请确认两次输入的密码一致";
    _cautionLabel.textColor = [UIColor systemRedColor];
    _cautionLabel.hidden = YES;
    
    _cautionLabelSecond = [[UILabel alloc] init];
    [self.view addSubview:_cautionLabelSecond];
    [_cautionLabelSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cautionLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    _cautionLabelSecond.text = @"密码长度应为6～8";
    _cautionLabelSecond.textColor = [UIColor systemRedColor];
    _cautionLabelSecond.hidden = YES;
    
#pragma mark 确认按钮
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_confirmButton];
    _confirmButton.frame = CGRectMake(textFieldHeight / 2, screenHeight * 13 / 15 - textFieldHeight, screenWidth - textFieldHeight, textFieldHeight);
    [self setConfirmButtonOff];
    [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
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

#pragma mark 收回键盘
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_previousPasswordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
}



- (void)pressConfirm {
    
    if ([_confirmButton.titleLabel.text isEqualToString:@"下一步"]) {
        if ([_previousPasswordTextField.text isEqualToString:[[LoginOrRegisterModel sharedModel] passWord]]) {
            
            [self gotoConfirmMode];
        
        } else {
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"密码有误" message:nil preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } else {
        
        
        
    }
}

#pragma mark textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    if (textField == _previousPasswordTextField || textField == _confirmPasswordTextField) {
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
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField == _previousPasswordTextField) {
        
        if ([_confirmButton.titleLabel.text isEqualToString:@"下一步"]) {
            if (textField.text.length > 0) {
                [self setConfirmButtonOn];
            } else {
                [self setConfirmButtonOff];
            }
        } else {
            if (_previousPasswordTextField.text.length < 6 || _previousPasswordTextField.text.length > 16) {
                _cautionLabelSecond.hidden = NO;
                [self setConfirmButtonOff];
            } else {
                _cautionLabelSecond.hidden = YES;
//                [self setConfirmButtonOn];
            }
            if ([_confirmPasswordTextField.text isEqualToString:_previousPasswordTextField.text] && ![_previousPasswordTextField.text isEqualToString:@""]) {
                [self setConfirmButtonOn];
                _cautionLabel.hidden = YES;
            } else {
                if (![_confirmPasswordTextField.text isEqualToString:@""]) {
                    _cautionLabel.hidden = NO;
                }
                [self setConfirmButtonOff];
            }
        }
        
    } else {
        
        if ([_confirmPasswordTextField.text isEqualToString:_previousPasswordTextField.text] && ![_previousPasswordTextField.text isEqualToString:@""]) {
            [self setConfirmButtonOn];
            _cautionLabel.hidden = YES;
        } else {
            _cautionLabel.hidden = NO;
            [self setConfirmButtonOff];
        }
        
    }
}

#pragma mark - 进入写新密码的模式
- (void)gotoConfirmMode {
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self setConfirmButtonOff];
    secondView.hidden = NO;
    _previousPasswordTextField.text = nil;
    _previousPasswordTextField.placeholder = @"请输入新密码";
}

@end
