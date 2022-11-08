//
//  RunningDataModelFirst.h
//  Persist
//
//  Created by 张博添 on 2022/3/16.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RunningDataModelFirst : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *data;

@end

NS_ASSUME_NONNULL_END
