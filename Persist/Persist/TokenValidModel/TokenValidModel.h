//
//  TokenValidModel.h
//  Persist
//
//  Created by 张博添 on 2022/2/22.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppTokenModel : NSObject

@property (nonatomic, strong) NSString *token;

+ (instancetype)sharedModel;

@end

@interface TokenValidModel : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;

@end

NS_ASSUME_NONNULL_END
