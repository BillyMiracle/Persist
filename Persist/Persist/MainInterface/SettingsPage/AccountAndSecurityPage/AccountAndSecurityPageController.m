//
//  AccountAndSecurityPageController.m
//  Persist
//
//  Created by 张博添 on 2022/2/13.
//

#import "AccountAndSecurityPageController.h"
#import "AccountAndSecurityPageView.h"
#import "LoginOrRegisterController.h"
#import "ChangePasswordController.h"
#import "ChangeEmailController.h"

@interface AccountAndSecurityPageController ()
<AccountAndSecurityPageViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) AccountAndSecurityPageView *accountAndSecurityPageView;

@end

@implementation AccountAndSecurityPageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [_accountAndSecurityPageView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _accountAndSecurityPageView = [[AccountAndSecurityPageView alloc] initWithFrame:self.view.frame];
    _accountAndSecurityPageView.delegate = self;
    self.view = _accountAndSecurityPageView;
}

- (void)pressBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressChangeEmail {
    ChangeEmailController *changeEmailController = [[ChangeEmailController alloc] init];
    [self presentViewController:changeEmailController animated:YES completion:nil];
}

- (void)pressChangePassword {
    
    ChangePasswordController *changePasswordController = [[ChangePasswordController alloc] init];
    [self presentViewController:changePasswordController animated:YES completion:nil];
    
}

- (void)pressLogout {
    
    LoginOrRegisterController *loginController = [[LoginOrRegisterController alloc] init];
    loginController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginController animated:YES completion:nil];
    
}

@end
