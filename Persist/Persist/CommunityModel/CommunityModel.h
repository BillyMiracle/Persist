//
//  CommunityModel.h
//  Persist
//
//  Created by 张博添 on 2022/4/12.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CommunityDataModel

@end

@interface CommunityModel : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSArray<CommunityDataModel> *data;

@end

@interface CommunityDataModel : JSONModel

@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *beganTime;
@property (nonatomic, strong) NSString *communityUid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *picture;
@property (nonatomic, strong) NSString *userName;

@end

NS_ASSUME_NONNULL_END
