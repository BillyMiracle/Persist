//
//  ChangeNameController.m
//  Persist
//
//  Created by 张博添 on 2022/3/14.
//

#import "ChangeNameController.h"
#import <Masonry.h>

#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height

#define textFieldHeightSecond (screenHeight / 13)

static const int textFieldFontSize = 23; //字体大小
static const int NICKNAMEMAXLENGTH = 15;

@interface ChangeNameController ()
{
    UIView *firstView;
    float textFieldHeight;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation ChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark 标题初始化
    _titleLabel = [[UILabel alloc] init];
    [self.view addSubview:_titleLabel];
    [_titleLabel setText:@"更改昵称"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:28];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
    }];
    
    textFieldHeight = screenHeight / 13;
    
    firstView = [[UIView alloc] init];
    [self.view addSubview:firstView];
    firstView.layer.masksToBounds = YES;
    firstView.layer.cornerRadius = textFieldHeightSecond / 2;
    firstView.layer.borderWidth = 1;

    
    _nameTextField = [[UITextField alloc] init];
    [firstView addSubview:_nameTextField];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.font = [UIFont systemFontOfSize:textFieldFontSize + 1];
    _nameTextField.placeholder = @"请设置昵称";
//    _nameTextField.delegate = self;
    _nameTextField.keyboardType = UIKeyboardTypeDefault;
    //清除按钮
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    firstView.layer.masksToBounds = YES;
    firstView.layer.cornerRadius = textFieldHeightSecond / 2;
    firstView.layer.borderWidth = 1;
    
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(@(textFieldHeightSecond));
        make.left.mas_equalTo(self.view.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(self.view.mas_right).offset(-textFieldHeightSecond / 2);
    }];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstView.mas_left).offset(textFieldHeightSecond / 2);
        make.right.mas_equalTo(firstView.mas_right).offset(-textFieldHeightSecond / 2);
        make.top.mas_equalTo(firstView.mas_top);
        make.bottom.mas_equalTo(firstView.mas_bottom);
    }];
    [_nameTextField addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
    
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
    [_nameTextField resignFirstResponder];
}

- (void)pressConfirm {
    
    [self setConfirmButtonOff];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
