//
//  LoginOrRegisterView.h
//  Persist
//
//  Created by 张博添 on 2021/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@protocol LoginOrRegisterViewDelegate <NSObject>
//
//- (void)sendCode;
//
//@end

@interface LoginOrRegisterView : UIView
//切换按钮
@property (nonatomic, strong) UIButton *switchButton;
//标题Label
@property (nonatomic, strong) UILabel *titleLabel;
//电话号码和密码（验证码）输入框
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *passwordTextField;


@property (nonatomic, strong) UIButton *agreementButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *touristButton;

//发送验证码
@property (nonatomic, strong) UIButton *sendCodeButton;

@property (nonatomic, copy, readonly) NSString *phoneNumber;
@property (nonatomic, copy, readonly) NSString *password;

//@property (nonatomic, weak) id<LoginOrRegisterViewDelegate>delegate;

- (void)setSendButtonOn;
- (void)setSendButtonOff;

@end

NS_ASSUME_NONNULL_END
