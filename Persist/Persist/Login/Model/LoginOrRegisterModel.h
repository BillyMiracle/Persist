//
//  LoginOrRegisterModel.h
//  Persist
//
//  Created by 张博添 on 2022/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginOrRegisterModel : NSObject

@property (nonatomic, copy, readonly) NSString *phoneNumber;
@property (nonatomic, copy, readonly) NSString *nickName;
@property (nonatomic, copy, readonly) NSString *passWord;
@property (nonatomic, copy, readonly) NSData *imageData;
@property (nonatomic, copy, readonly) NSString *age;
@property (nonatomic, copy, readonly) NSString *gender;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, assign, readonly) NSInteger loginStatus;
@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *headImagePath;

//@property (nonatomic, assign, readonly) BOOL shouldChangeHeadImage;

#pragma mark - 单例
+ (instancetype)sharedModel;

- (void)updateInfoWithPhoneNum:(NSString *)phoneNum nickName:(NSString *)nickName passWord:(NSString *)passWord headImage:(NSData * _Nullable)imageData gender:(NSString *)gender age:(NSString *)age email:(NSString *)email token:(NSString *)token userID:(NSString *)userID headImagePath:(NSString *)headImagePath;
- (void)updateHeadImageWithData:(NSData*)imageData andHeadImagePath:(NSString *)headImagePath;
- (void)logout;
- (BOOL)isLoggedIn;
//- (void)shouldChangeHeadImageSetOn;
//- (void)shouldChangeHeadImageSetOff;
@end

NS_ASSUME_NONNULL_END
