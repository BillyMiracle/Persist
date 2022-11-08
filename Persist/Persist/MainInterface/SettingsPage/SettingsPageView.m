//
//  SettingsPageView.m
//  Persist
//
//  Created by 张博添 on 2022/1/20.
//

#import "SettingsPageView.h"
#import <Masonry.h>
#import "LoginOrRegisterModel.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 50.0;

@interface SettingsPageView ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy)NSArray *titleArray;

@end

@implementation SettingsPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
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
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight + self.statusBarHeight, selfViewWidth, selfViewHeight - navigationBarHeight - self.statusBarHeight)style:UITableViewStyleGrouped];
    _mainTableView.sectionHeaderHeight = 0;
    _mainTableView.sectionFooterHeight = 0;
    [self addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
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
    _titleLabel.text = @"设置";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16 * (_titleLabel.frame.size.height - 18) / _titleLabel.font.lineHeight];
    
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    
    _titleArray = @[@"账号与安全", @"未成年人模式", @"申请认证",
                    @"运动设置", @"消息与提醒", @"隐私",
                    @"通用设置", @"个人信息收集单", @"第三方SDK列表",
                    @"邀请好友", @"运动风险需知", @"关于"];
}

- (void)pressBackButton {
    [self.delegate pressBack];
}

#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 5;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return selfViewHeight / 13;
}

#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 &&indexPath.section == 0) {
        UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.textLabel.text = @"个人资料";
        
        UIImageView *headImageView = [[UIImageView alloc] init];
        [headImageView setImage:[[UIImage alloc] initWithData:[[LoginOrRegisterModel sharedModel] imageData]]];
        [cell.contentView addSubview:headImageView];
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = (selfViewHeight / 13 - 20) / 2;
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.top.mas_offset(10);
            make.bottom.mas_offset(-10);
            make.width.mas_equalTo(selfViewHeight / 13 - 20);
        }];
        return cell;
    } else {
        UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row - 1];
        } else if (indexPath.section == 1) {
            cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row + 3];
        } else {
            cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row + 7];
        }
        return cell;
    }
}
#pragma mark DidSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0 && indexPath.row == 0) {
        
        [self.delegate pressPersonalInfoPage];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        [self.delegate pressAccountAndSecurityPage];
        
    } else {
        
    }
}

- (void)reload {
    [_mainTableView reloadData];
}

@end
