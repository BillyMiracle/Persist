//
//  LoginOrRegisterController.m
//  Persist
//
//  Created by 张博添 on 2021/12/28.
//

#import "LoginOrRegisterController.h"
#import "LoginOrRegisterView.h"
#import "MainTabBarViewController.h"
#import "RegisterPageController.h"
#import "Manager.h"
#import "NetworkLinkedLoginModel.h"
#import "LoginOrRegisterModel.h"

@interface LoginOrRegisterController ()

@property (nonatomic, strong) LoginOrRegisterView *loginOrRegisterView;
@property (nonatomic, strong) MainTabBarViewController *mainTabBarViewController;
@property (nonatomic, strong) RegisterPageController *registerPageController;

@end

@implementation LoginOrRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginOrRegisterView = [[LoginOrRegisterView alloc] initWithFrame:self.view.frame];
    self.view = _loginOrRegisterView;
    [_loginOrRegisterView.loginButton addTarget:self action:@selector(pressLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginOrRegisterView.touristButton addTarget:self action:@selector(pressTourist) forControlEvents:UIControlEventTouchUpInside];
    [_loginOrRegisterView.sendCodeButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 点击注册登陆按钮
- (void)pressLogin {
    _loginOrRegisterView.loginButton.userInteractionEnabled = NO;
    if ([_loginOrRegisterView.loginButton.titleLabel.text isEqualToString:@"登录"]) {
//账号密码登录
        NSString *phoneNumber = _loginOrRegisterView.phoneNumberTextField.text;
        NSString *password = _loginOrRegisterView.passwordTextField.text;
//        NSLog(@"%@ %@", phoneNumber, password);
        
        [[Manager sharedManager] NetworkLoginWithData:@{@"phoneNumber":phoneNumber, @"password":password} finished:^(NetworkLinkedLoginModel *loginModel, NSString *token) {

            UserDataModel *dataModel = [loginModel data];
            
            NSString *name = [dataModel userName];
            NSString *phone = [dataModel phone];
            int age = [dataModel age];
            NSString *gender = [dataModel gender];
            NSString *password = [dataModel password];
            NSString *email = [dataModel email];
            NSString *userID = [dataModel uid];
            NSString *headURL = [dataModel headUrl];
            
            NSLog(@"%@", dataModel);
            
            [[LoginOrRegisterModel sharedModel] updateInfoWithPhoneNum:phone nickName:name passWord:password headImage:nil gender:gender age:[NSString stringWithFormat:@"%d", age] email:email token:token userID:userID headImagePath:headURL];
            [[Manager sharedManager] NetworkDownloadHeadImageWithURL:headURL Finished:^(NSData *imageData) {
                
                [[LoginOrRegisterModel sharedModel] updateHeadImageWithData:imageData andHeadImagePath:headURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentMainInterface];
                });
                
            } error:^(NSError *error) {
                NSLog(@"头像下载失败");
            }];
            
            

        } error:^(NSError *error) {
            NSLog(@"error");
            self.loginOrRegisterView.loginButton.userInteractionEnabled = YES;
        }];
        
    } else {
//验证验证码
        [self verificationCodeValid];
    }
}
#pragma mark - 点击游客按钮
- (void)pressTourist {
    [self presentMainInterface];
}

- (void)presentMainInterface {
    _mainTabBarViewController = [[MainTabBarViewController alloc] init];
    _mainTabBarViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_mainTabBarViewController animated:YES completion:nil];
}

- (void)presentRegisterPage {
    _registerPageController = [[RegisterPageController alloc] init];
    _registerPageController.modalPresentationStyle = UIModalPresentationFullScreen;
    _registerPageController.phoneNumber = _loginOrRegisterView.phoneNumber;
    [self presentViewController:_registerPageController animated:YES completion:nil];
}
//收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_loginOrRegisterView.passwordTextField resignFirstResponder];
    [_loginOrRegisterView.phoneNumberTextField resignFirstResponder];
}

//点击获取短信验证码
 - (void)send {
     
     NSLog(@"send");
     
     
     [[Manager sharedManager] NetworkSendVerificationCodeWithPhoneNumber:_loginOrRegisterView.phoneNumberTextField.text finished:^(NetworkLinkedLoginModel *loginModel, NSString *token) {

         NSLog(@"%@", loginModel);

     } error:^(NSError *error) {

         NSLog(@"发送失败");

     }];
     
 }

#pragma mark - 判断验证码是否正确
- (void)verificationCodeValid {
    
    
    [[Manager sharedManager] NetworkLoginWithPhone:_loginOrRegisterView.phoneNumberTextField.text andVerificationCode:_loginOrRegisterView.passwordTextField.text finished:^(NetworkLinkedLoginModel *loginModel, NSString *token) {
        
        NSLog(@"%@", loginModel);
        if ([loginModel.msg isEqualToString:@"已注册验证码正确"]) {
            
            UserDataModel *dataModel = [loginModel data];
            
            NSString *name = [dataModel userName];
            NSString *phone = [dataModel phone];
            int age = [dataModel age];
            NSString *gender = [dataModel gender];
            NSString *password = [dataModel password];
            NSString *email = [dataModel email];
            NSString *userID = [dataModel uid];
            NSString *headURL = [dataModel headUrl];
            
            NSLog(@"%@", dataModel);
            
            UIImage *image = [UIImage imageNamed:@"morentouxiang.png"];
            NSData *data = UIImagePNGRepresentation(image);
//            NSLog(@"%@", data);
            [[LoginOrRegisterModel sharedModel] updateInfoWithPhoneNum:phone nickName:name passWord:password headImage:data gender:gender age:[NSString stringWithFormat:@"%d", age] email:email token:token userID:userID headImagePath:headURL];
            NSLog(@"%@", headURL);
            [[Manager sharedManager] NetworkDownloadHeadImageWithURL:headURL Finished:^(NSData *imageData) {
                
                NSLog(@"%@", imageData);
                [[LoginOrRegisterModel sharedModel] updateHeadImageWithData:imageData andHeadImagePath:headURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentMainInterface];
                });
                
            } error:^(NSError *error) {
                NSLog(@"头像下载失败");
            }];
            
//            [self presentMainInterface];
            
            
        } else if ([loginModel.msg isEqualToString:@"已注册验证码不正确"] || [loginModel.msg isEqualToString:@"未注册验证码不正确"]) {
            
            NSLog(@"验证码不正确");
            self.loginOrRegisterView.loginButton.userInteractionEnabled = YES;

            
        } else if ([loginModel.msg isEqualToString:@"未注册验证码正确"]) {
            
            NSLog(@"未注册验证码正确");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentRegisterPage];
            });
            
        }
        
        
    } error:^(NSError *error) {
            
        NSLog(@"验证失败");
        self.loginOrRegisterView.loginButton.userInteractionEnabled = YES;

        
    }];
    
//    [self presentRegisterPage];
    
}

#pragma mark - 判断是否已经注册过了
- (void)alreadyRegistered {
    //注册过
    
    
    //未注册
    
}

@end
