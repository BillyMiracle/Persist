//
//  AccountAndSecurityView.m
//  Persist
//
//  Created by 张博添 on 2022/2/13.
//

#import "AccountAndSecurityPageView.h"
#import "LoginOrRegisterModel.h"


#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height


static const float navigationBarHeight = 50.0;

@interface AccountAndSecurityPageView()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation AccountAndSecurityPageView

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self buildUI];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)buildUI {
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight + self.statusBarHeight, selfViewWidth, selfViewHeight - navigationBarHeight - self.statusBarHeight)style:UITableViewStyleGrouped];
    _mainTableView.sectionHeaderHeight = 0;
    _mainTableView.sectionFooterHeight = 0;
    [self addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell3"];
    
    
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
    _titleLabel.text = @"账号与安全";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16 * (_titleLabel.frame.size.height - 18) / _titleLabel.font.lineHeight];
}

- (void)pressBackButton {
    [self.delegate pressBack];
}

#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return selfViewHeight / 14;
}

#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row == 0 &&indexPath.section == 0) || indexPath.section == 1 || (indexPath.row == 1 && indexPath.section == 0)) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        if (indexPath.row == 0 &&indexPath.section == 0) {
            cell.detailTextLabel.text = [[LoginOrRegisterModel sharedModel] phoneNumber];
            cell.textLabel.text = @"更改手机号";
        } else if (indexPath.section == 1) {
            cell.detailTextLabel.text = @"此操作不可撤销";
            cell.textLabel.text = @"注销账户";
        } else {
            cell.textLabel.text = @"更改邮箱";
            cell.detailTextLabel.text = [[LoginOrRegisterModel sharedModel] email];
        }
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        
        cell.textLabel.text = @"更改密码";
        
        return cell;
    } else {
        UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.text = @"退出登录";
        
        return cell;
    }
}
#pragma mark DidSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {//修改手机号
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {//修改邮箱
        [self.delegate pressChangeEmail];
    } else if (indexPath.section == 0 && indexPath.row == 2) {//修改密码
        [self.delegate pressChangePassword];
    } else if (indexPath.section == 1) {//注销账户
        
    } else {//退出登录
        [[LoginOrRegisterModel sharedModel] logout];
        [self.delegate pressLogout];
    }
}

- (void)reload {
    [_mainTableView reloadData];
    
}

@end
