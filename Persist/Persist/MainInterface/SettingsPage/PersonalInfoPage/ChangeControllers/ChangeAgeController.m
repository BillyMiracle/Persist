//
//  ChangeAgeController.m
//  Persist
//
//  Created by 张博添 on 2022/3/15.
//

#import "ChangeAgeController.h"
#import <Masonry.h>

#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height

#define textFieldHeightSecond (screenHeight / 13)

static const int textFieldFontSize = 23; //字体大小

@interface ChangeAgeController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIView *thirdView;
    float textFieldHeight;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIPickerView *agePickerView;
@property (nonatomic, copy) NSMutableArray *ageDataSourceArray;

@end

@implementation ChangeAgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    [self.view addSubview:_titleLabel];
    [_titleLabel setText:@"更改年龄"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:28];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
    }];
    
    textFieldHeight = screenHeight / 13;
    
    _ageDataSourceArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 121; i++) {
        [self.ageDataSourceArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    _agePickerView = [[UIPickerView alloc] init];
    [self.view addSubview:_agePickerView];
    [_agePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(_titleLabel.mas_left).offset(20);
        make.right.mas_equalTo(_titleLabel.mas_right).offset(-20);
    }];
    _agePickerView.delegate = self;
    _agePickerView.dataSource = self;
    [_agePickerView selectRow:17 inComponent:0 animated:NO];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_confirmButton];
    _confirmButton.frame = CGRectMake(textFieldHeight / 2, screenHeight * 13 / 15 - screenHeight / 13, screenWidth - (screenHeight / 13), screenHeight / 13);
    [self setConfirmButtonOn];
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

- (void)pressConfirm {
    
    [self setConfirmButtonOff];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 返回需要展示的列（columns）的数目
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 返回每一列的行（rows）数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _ageDataSourceArray.count;
}

#pragma mark - UIPickerViewDelegate

// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_ageDataSourceArray objectAtIndex:row];
}

// 某一行被选择时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    _age = [_ageDataSourceArray objectAtIndex:row];
}

@end
