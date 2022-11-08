//
//  SceneDelegate.m
//  Persist
//
//  Created by 张博添 on 2021/12/28.
//

#import "SceneDelegate.h"
#import "LoginOrRegisterController.h"
#import "MainTabBarViewController.h"
#import "LoginOrRegisterModel.h"
#import "Manager.h"

@interface SceneDelegate ()

@property (nonatomic, strong) LoginOrRegisterController *loginOrRegisterController;
@property (nonatomic, strong) MainTabBarViewController *mainTabBarController;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
//    NSLog(@"%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    
    
    
    [[Manager sharedManager] NetworkTestTokenWithToken:[[LoginOrRegisterModel sharedModel] token] finished:^(TokenValidModel *model) {
        
        if (model.status) {//失败
            NSLog(@"验证失败");
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_loginOrRegisterController = [[LoginOrRegisterController alloc] init];
                self.window.rootViewController = self->_loginOrRegisterController;
            });
        } else {//成功
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_mainTabBarController = [[MainTabBarViewController alloc] init];
                self.window.rootViewController = self->_mainTabBarController;
            });
        }

    } error:^(NSError *error) {
        //网络出错
        NSLog(@"网络出错");

    }];
    
//    if ([[LoginOrRegisterModel sharedModel] isLoggedIn]) {
//        _mainTabBarController = [[MainTabBarViewController alloc] init];
//        self.window.rootViewController = _mainTabBarController;
//    } else {
//        _loginOrRegisterController = [[LoginOrRegisterController alloc] init];
//        self.window.rootViewController = _loginOrRegisterController;
//    }
}

@end
