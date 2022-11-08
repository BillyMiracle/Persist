//
//  RegisterView.h
//  Persist
//
//  Created by 张博添 on 2022/1/4.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface RegisterPageView : UIView

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *registerLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *passwordTextFieldFirst;
@property (nonatomic, strong) UITextField *passwordTextFieldConfirm;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *emailTextField;

@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *age;

- (void)setNickname;
- (void)setHeadImage;
- (void)setConfirmButtonOn;
- (void)setConfirmButtonOff;
- (void)setEmail;
- (void)setAgeAndGender;

@end

NS_ASSUME_NONNULL_END
