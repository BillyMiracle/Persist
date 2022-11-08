//
//  Manager.h
//  Persist
//
//  Created by 张博添 on 2022/2/18.
//

#import <Foundation/Foundation.h>
#import "NetworkLinkedLoginModel.h"
#import "TokenValidModel.h"
#import <UIKit/UIKit.h>
#import "RunningDataModelFirst.h"
#import "RunningModelSecond.h"
#import "TargetModel.h"
#import "CommunityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Manager : NSObject

typedef void (^registerSucceedBlock)(NetworkLinkedLoginModel * _Nonnull loginModel);
typedef void (^loginSucceedBlock)(NetworkLinkedLoginModel * _Nonnull loginModel, NSString * _Nonnull token);
typedef void (^uploadHeadImageSucceedBlock)(NSString * _Nonnull path);
typedef void (^updateHeadImageSucceedBlock)(NSString * _Nonnull path);
typedef void (^validSucceedBlock)(TokenValidModel * _Nonnull tokenValidModelModel);
typedef void (^weatherSucceedBlock)(NSDictionary * _Nonnull dataDictionary);
typedef void (^VerificationCodeSucceedBlock)(NetworkLinkedLoginModel * _Nonnull loginModel, NSString * _Nullable token);
typedef void (^DownloadHeadImageBlock)(NSData *imageData);
typedef void (^updateInfoBlock)(NSString *message);
typedef void (^getRunningDataFirstBlock)(RunningDataModelFirst * _Nonnull dataModel);
typedef void (^getRunningDataSecondBlock)(RunningModelSecond * _Nonnull dataModel);
typedef void (^recognizeSucceedBlock)(NSDictionary * _Nonnull dataDictionary);
typedef void (^uploadTargetSucceedBlock)(RunningDataModelFirst * _Nonnull dataModel);
typedef void (^getTargetSucceedBlock)(TargetModel * _Nonnull targetModel);
typedef void (^getCommunitySucceedBlock)(CommunityModel * _Nonnull communityModel);
typedef void (^addCommunitySucceedBlock)(CommunityModel * _Nonnull communityModel);

typedef void (^errorBlock)(NSError * _Nonnull error);


+ (instancetype)sharedManager;

- (void)NetworkTestTokenWithToken:(NSString *)token finished:(validSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkRegisterWithData:(NSDictionary *)infoDictionary finished:(registerSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkLoginWithData:(NSDictionary *)infoDictionary finished:(loginSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkUpLoadHeadImageWithImage:(UIImage *)image andUserID:(NSString *)userID finished:(uploadHeadImageSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkUpdateHeadImageWithImage:(UIImage *)image andUserID:(NSString *)userID finished:(updateHeadImageSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetWeatherFinished:(weatherSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkSendVerificationCodeWithPhoneNumber:(NSString *)phone finished:(VerificationCodeSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkLoginWithPhone:(NSString *)phone andVerificationCode:(NSString *)code finished:(VerificationCodeSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkDownloadHeadImageWithURL:(NSString *)URL Finished:(DownloadHeadImageBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkChangeUserName:(NSString *)name finished:(updateInfoBlock)succeedBlock error:(errorBlock)error;

- (void)NetworkChangeAge:(NSString *)name finished:(updateInfoBlock)succeedBlock error:(errorBlock)error;

- (void)NetworkGetSumRunningTime:(NSString *)time finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetSumRunningDistanceFinished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetDaySumTimeAt:(NSString *)day finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkUpdateRunRecordWithDate:(NSString *)date andTime:(NSString *)time andDistance:(NSString *)distance finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetRunHistoryAt:(NSString *)date finished:(getRunningDataSecondBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetAllRunHistoryFinished:(getRunningDataSecondBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetRunTargetAt:(NSString *)day finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkUpdateRunTargetAt:(NSString *)day andTarget:(NSString *)target finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkUpdatePassword:(NSString *)newPassword finished:(validSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkDishRecognize:(NSString *)image64 finished:(recognizeSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkVegetableRecognize:(NSString *)image64 finished:(recognizeSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkAddTarget:(NSString *)headLine andRemark:(NSString *)remark andBeginTime:(NSString *)beginTime andEndTime:(NSString *)endTime andType:(int)typeNum addIsWholeDay:(int)isWholeDay succeed:(uploadTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkAddDailyTarget:(NSString *)headLine andRemark:(NSString *)remark andBeginTime:(NSString *)beginTime andType:(int)typeNum addIsWholeDay:(int)isWholeDay succeed:(uploadTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetDailyTargetListWithDay:(NSString *)day succeed:(getTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetAllTargetInDay:(NSString *)day succeed:(getTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkUploadCommunityWithContent:(NSString *)content andPicts:(NSArray *)pictArray finished:(addCommunitySucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetCommunityFinished:(getCommunitySucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkGetAllTargetsSucceed:(getTargetSucceedBlock)succeedBlock error:(errorBlock)error;

- (void)NetworkChangeDailyTargetIsDoneWithTargetId:(NSString *)targetId andDay:(NSString *)day finished:(getTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

- (void)NetworkChangeTargetIsDoneWithTargetId:(NSString *)targetId finished:(getTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock;

@end

NS_ASSUME_NONNULL_END
