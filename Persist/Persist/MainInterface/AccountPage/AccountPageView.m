//
//  AccountPageView.m
//  Persist
//
//  Created by 张博添 on 2022/1/16.
//

#import "AccountPageView.h"
#import "AccountPageTableViewCell.h"
//#import "PersonalHomepageController.h"
#import "CustomView.h"
#import "LoginOrRegisterModel.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

#define nameLabelHeight (selfViewWidth / 8)

#define sectionThreeCellHeight 100

static const float navigationBarHeight = 50.0;
static const float sectionTwoHeaderHeight = 44.0;

static const float sectionOneRowTwoHeight = 120;

@interface AccountPageView ()
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) CustomView *exerciseCustomView;
@property (nonatomic, strong) CustomView *dataCustomView;

@property (nonatomic, strong) UIButton *headImageButton;

@end

@implementation AccountPageView

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
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewHeight) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.sectionHeaderHeight = 0;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.clipsToBounds = YES;
    _mainTableView.bounces = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    [_mainTableView registerClass:[AccountPageTableViewCell class] forCellReuseIdentifier:@"First"];
    [_mainTableView registerClass:[AccountPageTableViewCell class] forCellReuseIdentifier:@"Second"];
    [_mainTableView registerClass:[AccountPageTableViewCell class] forCellReuseIdentifier:@"Third"];
    [self addSubview:_mainTableView];
    
    _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //解决自动向下偏移一个状态栏高度的问题。
    
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, self.statusBarHeight)];
    [self addSubview:_statusBarView];
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, selfViewWidth, navigationBarHeight)];
    _navigationBarView.backgroundColor = [UIColor colorWithWhite:1 alpha:_mainTableView.contentOffset.y / (selfViewWidth / 2)];
    [self addSubview:_navigationBarView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressNavigationBarView)];
//    [_navigationBarView addGestureRecognizer:tap];
    
    _headImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _headImageButton.frame = CGRectMake(10, 5, 60, 60);
    _headImageButton.layer.masksToBounds = YES;
    _headImageButton.layer.borderWidth = 0;
    _headImageButton.layer.cornerRadius = 30;
    [_headImageButton addTarget:self action:@selector(pressHeadImageButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *headImage = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
    [_headImageButton setBackgroundImage:headImage forState:UIControlStateNormal];
    
    [_navigationBarView addSubview:_headImageButton];
}

//- (void)pressNavigationBarView {
//    [self.delegate skipToPersonalHomePage];
//}

#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return sectionTwoHeaderHeight;
//        return 100;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return selfViewWidth / 2 + navigationBarHeight + self.statusBarHeight;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        return sectionOneRowTwoHeight;
    } else {
        
        return selfViewHeight - sectionTwoHeaderHeight - self.statusBarHeight - navigationBarHeight;
        
        
//        return sectionThreeCellHeight;
    }
}
#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        AccountPageTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"First" forIndexPath:indexPath];
        
        cell.nameLabel.text = [[LoginOrRegisterModel sharedModel] nickName];
        cell.nameLabel.font = [UIFont systemFontOfSize:16];
        cell.nameLabel.font = [UIFont systemFontOfSize:16 * (nameLabelHeight - 5) / (cell.nameLabel.font.lineHeight)];
        
        cell.subTitleLabel.frame = CGRectMake(selfViewWidth - 90, (selfViewWidth / 2 + navigationBarHeight + self.statusBarHeight) / 2 - nameLabelHeight / 2, 80, nameLabelHeight);
        
        cell.ageLabel.text = [NSString stringWithFormat:@"年龄：%@", [[LoginOrRegisterModel sharedModel] age]];
        cell.ageLabel.font = [UIFont systemFontOfSize:16];
        cell.ageLabel.font = [UIFont systemFontOfSize:16 * 23 / (cell.ageLabel.font.lineHeight)];
        
        cell.genderLabel.text = [NSString stringWithFormat:@"性别：%@", [[LoginOrRegisterModel sharedModel] gender]];
        cell.genderLabel.font = cell.ageLabel.font;
        
        return cell;

    } else if (indexPath.row == 1 && indexPath.section == 0) {
        AccountPageTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"Second" forIndexPath:indexPath];
        
        _exerciseCustomView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth / 2, sectionOneRowTwoHeight)];
        [cell.contentView addSubview:_exerciseCustomView];
        _exerciseCustomView.titleLabel.text = @"总运动";
        
        _dataCustomView = [[CustomView alloc] initWithFrame:CGRectMake(selfViewWidth / 2, 0, selfViewWidth / 2, sectionOneRowTwoHeight)];
        [cell.contentView addSubview:_dataCustomView];
        _dataCustomView.titleLabel.text = @"我的会员";
        
        return cell;
        
    } else {
        
        AccountPageTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"Third" forIndexPath:indexPath];
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.delegate skipToPersonalHomePage];
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainTableView) {
        _navigationBarView.backgroundColor = [UIColor colorWithWhite:1 alpha:_mainTableView.contentOffset.y / (selfViewWidth / 2)];
        _statusBarView.backgroundColor = [UIColor colorWithWhite:1 alpha:_mainTableView.contentOffset.y / (selfViewWidth / 2)];
        if (_mainTableView.contentOffset.y / (selfViewWidth / 2) > 1) {
            _headImageButton.frame = CGRectMake(10, 5, 40, 40);
            _headImageButton.layer.cornerRadius = 20;
        } else {
            _headImageButton.frame = CGRectMake(10, 5, 60 - 20 * _mainTableView.contentOffset.y / (selfViewWidth / 2), 60 - 20 * _mainTableView.contentOffset.y / (selfViewWidth / 2));
            _headImageButton.layer.cornerRadius = 30 - 10 * _mainTableView.contentOffset.y / (selfViewWidth / 2);
        }
    }
}

- (void)pressHeadImageButton {
    [self.delegate openDrawerView];
}

- (void)updateHeadImage {
    UIImage *headImage = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
    [_headImageButton setBackgroundImage:headImage forState:UIControlStateNormal];
}

@end
