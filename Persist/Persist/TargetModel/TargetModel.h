//
//  TargetModel.h
//  Persist
//
//  Created by 张博添 on 2022/4/12.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DataModel
@end

@interface TargetModel : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSArray<DataModel> *data;

@end

@interface DataModel : JSONModel

@property (nonatomic, strong) NSString *targetUid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *beganTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *headLine;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, assign) BOOL done;
@property (nonatomic, assign) BOOL wholeDay;

@end

NS_ASSUME_NONNULL_END
