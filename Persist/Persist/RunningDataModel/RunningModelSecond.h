//
//  RunningModelSecond.h
//  Persist
//
//  Created by 张博添 on 2022/3/17.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RunningDataModel
@end


@interface RunningDataModel : JSONModel

@property (nonatomic, strong) NSString *runWhen;
@property (nonatomic, strong) NSString *runTime;
@property (nonatomic, strong) NSString *distance;

@end


@interface RunningModelSecond : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSArray<RunningDataModel> *data;

@end

NS_ASSUME_NONNULL_END
