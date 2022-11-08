//
//  NetworkLinkedLoginModel.h
//  Persist
//
//  Created by 张博添 on 2022/2/22.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDataModel : JSONModel

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *headUrl;

@end

@interface NetworkLinkedLoginModel : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) UserDataModel *data;

@end

NS_ASSUME_NONNULL_END
