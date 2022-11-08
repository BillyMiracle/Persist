//
//  AccountPageController.m
//  Persist
//
//  Created by 张博添 on 2022/1/3.
//

#import "AccountPageController.h"
#import "AccountPageView.h"
//#import "PersonalHomepageController.h"
#import "PersonalInfoPageController.h"
@interface AccountPageController ()
<AccountPageViewDelegate>

@property (nonatomic, strong) AccountPageView *accountPageView;
//@property PersonalHomepageController *personalHomepageController;
@property (nonatomic, strong) PersonalInfoPageController *personalInfoPageController;

@end

@implementation AccountPageController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage) name:@"changeHeadImage" object:nil];
    [self updateHeadImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage) name:@"changeHeadImage" object:nil];
    _accountPageView = [[AccountPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    self.navigationController.navigationBarHidden = YES;
    _accountPageView.delegate = self;
    self.view = _accountPageView;
}

- (void)skipToPersonalHomePage {
    if (!_personalInfoPageController) {
        _personalInfoPageController = [[PersonalInfoPageController alloc] init];
        _personalInfoPageController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
//    [self.tabBarController presentViewController:_personalHomepageController animated:YES completion:nil];
//    self.tabBarController.hidesBottomBarWhenPushed = YES;
    _personalInfoPageController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_personalInfoPageController animated:YES];
    
}

- (void)openDrawerView {
    [self.delegate openTheDrawer];
}

- (void)updateHeadImage {
    [_accountPageView updateHeadImage];
}

@end
