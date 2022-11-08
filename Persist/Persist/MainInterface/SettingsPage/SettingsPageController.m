//
//  SettingsPageController.m
//  Persist
//
//  Created by 张博添 on 2022/1/20.
//

#import "SettingsPageController.h"
#import "SettingsPageView.h"
#import "AccountAndSecurityPageController.h"
#import "PersonalInfoPageController.h"


@interface SettingsPageController ()
<SettingsPageViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) SettingsPageView *settingsPageView;

@end

@implementation SettingsPageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }

    [self reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"changeHeadImage" object:nil];

    
    _settingsPageView = [[SettingsPageView alloc] initWithFrame:self.view.frame];
    self.view = _settingsPageView;
    _settingsPageView.delegate = self;
}

- (void)pressBack {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressAccountAndSecurityPage {
    AccountAndSecurityPageController *accountPage = [[AccountAndSecurityPageController alloc] init];
    accountPage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accountPage animated:YES];
}

- (void)pressPersonalInfoPage {
    PersonalInfoPageController *personalPage = [[PersonalInfoPageController alloc] init];
    personalPage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalPage animated:YES];
}

- (void)reload {
    [_settingsPageView reload];
}

@end
