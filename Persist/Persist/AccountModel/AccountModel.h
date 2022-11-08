//
//  AccountModel.h
//  Persist
//
//  Created by 张博添 on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountModel : NSObject


- (NSString *)getAccountPhoneNumber;

- (NSString *)getAccountNickName;

- (NSData *)getAccountImageData;


@end

NS_ASSUME_NONNULL_END
