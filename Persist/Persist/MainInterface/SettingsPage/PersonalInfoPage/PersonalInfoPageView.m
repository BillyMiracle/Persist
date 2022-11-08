//
//  PersonalInfoPageView.m
//  Persist
//
//  Created by 张博添 on 2022/2/25.
//

#import "PersonalInfoPageView.h"
#import "LoginOrRegisterModel.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 50.0;

@interface PersonalInfoPageView()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PersonalInfoPageView

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
    
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    
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
    _titleLabel.text = @"个人资料";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16 * (_titleLabel.frame.size.height - 18) / _titleLabel.font.lineHeight];
}

- (void)pressBackButton {
    [self.delegate pressBack];
}

#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return selfViewHeight / 8;
    }
    return selfViewHeight / 12;
}

#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.textLabel.text = @"更换头像";
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(selfViewWidth - 10 + 20 - selfViewHeight / 8, 10, selfViewHeight / 8 - 20, selfViewHeight / 8 - 20)];
        [cell.contentView addSubview:imgView];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = imgView.frame.size.width / 2;
        imgView.layer.borderWidth = 0;
        imgView.image = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
        
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = [[LoginOrRegisterModel sharedModel] nickName];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = [[LoginOrRegisterModel sharedModel] gender];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"年龄";
            cell.detailTextLabel.text = [[LoginOrRegisterModel sharedModel] age];
        }
        return cell;
    }
}
#pragma mark DidSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row == 0) {
        
        [self.delegate changeHeadImage];
        
    } else if (indexPath.row == 1) {
        
        [self.delegate changeName];
        
    } else if (indexPath.row == 2) {
        
        [self.delegate changeGender];
        
    } else {
        
        [self.delegate changeAge];
        
    }
}

- (void)reload {
    [_mainTableView reloadData];
}
@end
