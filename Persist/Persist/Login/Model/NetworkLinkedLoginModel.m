//
//  NetworkLinkedLoginModel.m
//  Persist
//
//  Created by 张博添 on 2022/2/22.
//

#import "NetworkLinkedLoginModel.h"

@implementation UserDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation NetworkLinkedLoginModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
