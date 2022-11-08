//
//  TokenValidModel.m
//  Persist
//
//  Created by 张博添 on 2022/2/22.
//

#import "TokenValidModel.h"
#import "FMDB.h"

static AppTokenModel *appToken = nil;

@interface AppTokenModel()

@property (nonatomic, strong) NSString *objectsFilePath;
@property (nonatomic, strong) FMDatabase *objectsDataBase;

@end

@implementation AppTokenModel

+ (instancetype)sharedModel {
    
    if (appToken == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            appToken = [[AppTokenModel alloc] init];
        });
    }
    
    return appToken;
}

@end

@implementation TokenValidModel

@end
