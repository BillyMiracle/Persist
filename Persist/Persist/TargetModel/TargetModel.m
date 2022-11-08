//
//  TargetModel.m
//  Persist
//
//  Created by 张博添 on 2022/4/12.
//

#import "TargetModel.h"

@implementation TargetModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation DataModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
