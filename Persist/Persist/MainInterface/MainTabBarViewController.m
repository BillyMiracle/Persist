//
//  MainTabBarViewController.m
//  Persist
//
//  Created by 张博添 on 2022/1/3.
//

#import "MainTabBarViewController.h"
#import "MainPageController.h"
#import "AccountPageController.h"
#import "LoginOrRegisterModel.h"
#import "PlansPageController.h"
#import "CommunityPageController.h"
#import "LeftDrawerView.h"
#import "DrawerDelegate.h"
//#import "PersonalHomepageController.h"
#import "PersonalInfoPageController.h"
#import "SettingsPageController.h"
#import "DishRecognizeController.h"

#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
 
#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define LEFTVIEWWIDTH ((ScreenWidth/2) + 60)

@interface MainTabBarViewController ()
<ControllersOpenDrawerDelegate,
LeftDrawerViewDelegate>

@property (nonatomic, strong) MainPageController *mainPageController;
@property (nonatomic, strong) AccountPageController *accountPageController;
@property (nonatomic, strong) PlansPageController *plansPageController;
@property (nonatomic, strong) CommunityPageController *communityPageController;

@property (nonatomic,assign) BOOL   isOpen;
@property (nonatomic,strong) UIPanGestureRecognizer *gestureRecognizr;
@property (nonatomic,strong) LeftDrawerView         *leftDrawerView;
@property (nonatomic,strong) UIView                 *shawdowView;
@property (nonatomic,assign) CGPoint                initialPosition;//初始位置

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainPageController = [[MainPageController alloc] init];
    UINavigationController *mainPageNavController = [[UINavigationController alloc] initWithRootViewController:_mainPageController];
    _mainPageController.delegate = self;
    mainPageNavController.title = @"首页";
    mainPageNavController.tabBarItem.image = [self scaleToSize:[UIImage imageNamed:@"cangchucangku.png"] size:CGSizeMake(30, 30)];
//    mainPageNavController.tabBarItem.image = [UIImage imageNamed:@"jia.png"];


    _accountPageController = [[AccountPageController alloc] init];
    UINavigationController *accountPageNavController = [[UINavigationController alloc] initWithRootViewController:_accountPageController];
    _accountPageController.delegate = self;
    accountPageNavController.title = @"我的";
    accountPageNavController.tabBarItem.image = [self scaleToSize:[UIImage imageNamed:@"user.png"] size:CGSizeMake(30, 30)];
    
    _plansPageController = [[PlansPageController alloc] init];
    UINavigationController *plansPageNavController = [[UINavigationController alloc] initWithRootViewController:_plansPageController];
    _plansPageController.delegate = self;
    plansPageNavController.title = @"计划";
    plansPageNavController.tabBarItem.image = [self scaleToSize:[UIImage imageNamed:@"dingdan-2.png"] size:CGSizeMake(30, 30)];
    
    _communityPageController = [[CommunityPageController alloc] init];
    UINavigationController *communityPageNavController = [[UINavigationController alloc] initWithRootViewController:_communityPageController];
    _communityPageController.delegate = self;
    communityPageNavController.title = @"社区";
    communityPageNavController.tabBarItem.image = [self scaleToSize:[UIImage imageNamed:@"wangluo.png"] size:CGSizeMake(30, 30)];
    
    self.viewControllers = @[mainPageNavController, plansPageNavController, communityPageNavController, accountPageNavController];
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    UIView *customBackgroundView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    customBackgroundView.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] insertSubview:customBackgroundView atIndex:0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, self.view.frame.size.width, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    [[UITabBar appearance] insertSubview:view atIndex:0];
    
//    NSLog(@"%@, %@, %@, %ld", [[LoginOrRegisterModel sharedModel] phoneNumber], [[LoginOrRegisterModel sharedModel] passWord], [[LoginOrRegisterModel sharedModel] nickName], [[LoginOrRegisterModel sharedModel] loginStatus]);
}

#pragma mark - 抽屉界面
- (void)openTheDrawer {
    [self.view addSubview:self.shawdowView];
    [self.view addSubview:self.leftDrawerView];
    [self.view addGestureRecognizer:self.gestureRecognizr];
    self.isOpen = NO;
    [self openLeftDrawer];
}

- (UIPanGestureRecognizer *)gestureRecognizr {
    if (!_gestureRecognizr) {
        _gestureRecognizr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveDrawer:)];
        _gestureRecognizr.maximumNumberOfTouches = 1;
        _gestureRecognizr.minimumNumberOfTouches = 1;
    }
    return _gestureRecognizr;
}
- (LeftDrawerView *)leftDrawerView {
    if (!_leftDrawerView) {
        _leftDrawerView = [[LeftDrawerView alloc]initWithFrame:CGRectMake(-LEFTVIEWWIDTH, 0, LEFTVIEWWIDTH, ScreenHeight)];
        _leftDrawerView.delegate = self;
    }
    return _leftDrawerView;
}
- (UIView *)shawdowView {
    if (!_shawdowView) {
        _shawdowView =  [[UIView alloc] initWithFrame:self.view.frame];
        _shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        _shawdowView.hidden = YES;
        UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnShawdow:)];
        [_shawdowView addGestureRecognizer:tapIt];
        _shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _shawdowView;
}

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    [self closeLeftDrawer];
}

- (void)openLeftDrawer {
    float duration = 0.2;
    self.shawdowView.hidden = NO;
    
    [self.leftDrawerView updateSteps];
    [self.leftDrawerView updateHeadImage];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
 
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.leftDrawerView.frame = CGRectMake(0, 0, LEFTVIEWWIDTH, ScreenHeight);
                     }
                     completion:nil];
    self.isOpen= YES;
}
- (void)closeLeftDrawer {
    float duration = 0.2;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
        } completion:^(BOOL finished) {
            self.shawdowView.hidden = YES;
    }];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.leftDrawerView.frame = CGRectMake(-LEFTVIEWWIDTH, 0, LEFTVIEWWIDTH, ScreenHeight);
    } completion:nil];
    self.isOpen = NO;
}
- (void)moveDrawer:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    if ([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
        
        _initialPosition.x = _leftDrawerView.center.x;
        
    } else if ([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged && translation.x < 0) {
        
        float movingOffset = _initialPosition.x + translation.x;
        if (movingOffset <= LEFTVIEWWIDTH) {
            self.leftDrawerView.center = CGPointMake(movingOffset, self.leftDrawerView.center.y);
        }
        float changingAlpha = self.leftDrawerView.frame.origin.x + LEFTVIEWWIDTH;
        float alpha = MAX((changingAlpha / (ScreenWidth/2 + 50)) - 0.5, 0);
        self.shawdowView.hidden = NO;
        self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha: alpha];
        
    } else if ([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        
        if (self.leftDrawerView.frame.origin.x < -LEFTVIEWWIDTH / 2){
            [self closeLeftDrawer];
        } else {
            [self openLeftDrawer];
        }
        
    }
}

- (void)presentPersonalHomePage {
//    PersonalHomepageController *personalHomePageController = [[PersonalHomepageController alloc] init];
    PersonalInfoPageController *personalInfoPageController = [[PersonalInfoPageController alloc] init];
//    personalHomePageController.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:personalHomePageController animated:YES completion:nil];
    [self closeLeftDrawer];
    personalInfoPageController.hidesBottomBarWhenPushed = YES;
//    NSLog(@"%@", self.selectedViewController);
    [self.selectedViewController pushViewController:personalInfoPageController animated:YES];
}

- (void)presentSettingsPage {
    SettingsPageController *settingPageController = [[SettingsPageController alloc] init];
//    settingPageController.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:settingPageController animated:YES completion:nil];
    [self closeLeftDrawer];
    settingPageController.hidesBottomBarWhenPushed = YES;
//    NSLog(@"%@", self.selectedViewController);
    [self.selectedViewController pushViewController:settingPageController animated:YES];
}

- (void)presentFoodToolsPage {
    DishRecognizeController *dishRecognizePage = [[DishRecognizeController alloc] init];
    [self closeLeftDrawer];
    dishRecognizePage.hidesBottomBarWhenPushed = YES;
    [self.selectedViewController pushViewController:dishRecognizePage animated:YES];
}

#pragma mark 调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
