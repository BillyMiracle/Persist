//
//  LoginOrRegisterModel.m
//  Persist
//
//  Created by 张博添 on 2022/1/9.
//

#import "LoginOrRegisterModel.h"
#import "FMDB.h"

static LoginOrRegisterModel *infoModel = nil;

@interface LoginOrRegisterModel ()

@property (nonatomic, strong) NSString *objectsFilePath;
@property (nonatomic, strong) FMDatabase *objectsDataBase;

@end

@implementation LoginOrRegisterModel

#pragma mark - 单例
+ (instancetype)sharedModel {
    if(!infoModel) {
        //dispatch_ once _t: 使用 dispatch_once 方法能保证某段代码在程序运行过程中只被执行 1 次，并且即使在多线程的环境下，dispatch _once也可以保证线程安全。 ，用在这里就是只创建一次manger，不会创建不同的manger
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            infoModel = [[LoginOrRegisterModel alloc] init];
            [infoModel initTable];
        });
    }
    [infoModel select];
    return infoModel;
}

#pragma mark - 初始化Table
- (void)initTable {
    [self creatTable];
    [self insert];
}

#pragma mark 退出登录
- (void)logout {
    [self deleteAll];
    [self insert];
}

#pragma mark - 更新数据
- (void)updateInfoWithPhoneNum:(NSString *)phoneNum nickName:(NSString *)nickName passWord:(NSString *)passWord headImage:(NSData*)imageData gender:(NSString *)gender age:(NSString *)age email:(NSString *)email token:(NSString *)token userID:(NSString *)userID headImagePath:(NSString *)headImagePath {
    if ([_objectsDataBase open]) {
        NSString *updateSQL = @"update InfoTable set PhoneNumber=?,NickName=?,PassWord=?,HeadImage=?,Gender=?,Age=?,Email=?,token=?,UserID=?,HeadImagePath=?,LoginStatus=? where id=1";
        BOOL success = [_objectsDataBase executeUpdate:updateSQL, phoneNum, nickName, passWord, imageData, gender, age, email, token, userID, headImagePath,@1];
        if (success) {
            NSLog(@"更新成功");
        } else {
            NSLog(@"更新失败");
        }
        [_objectsDataBase close];
    }
}

- (void)updateHeadImageWithData:(NSData*)imageData andHeadImagePath:(NSString *)headImagePath {
    if ([_objectsDataBase open]) {
        NSString *updateSQL = @"update InfoTable set HeadImage=?,HeadImagePath=? where id=1";
        BOOL success = [_objectsDataBase executeUpdate:updateSQL, imageData, headImagePath];
        if (success) {
            NSLog(@"更新成功");
        } else {
            NSLog(@"更新失败");
        }
        [_objectsDataBase close];
    }
}

- (void)updateNickName:(NSString *)nickName {
    if ([_objectsDataBase open]) {
        NSString *updateSQL = @"update InfoTable set NickName=? where id=1";
        BOOL success = [_objectsDataBase executeUpdate:updateSQL, nickName];
        if (success) {
            NSLog(@"更新成功");
        } else {
            NSLog(@"更新失败");
        }
        [_objectsDataBase close];
    }
}



#pragma mark - 创建
- (void)creatTable {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents firstObject];
    _objectsFilePath = [documentsPath stringByAppendingPathComponent:@"loginInfo.db"];
    _objectsDataBase = [FMDatabase databaseWithPath:_objectsFilePath];
    if ([_objectsDataBase open]) {
        NSString *createTableSql = @"create table if not exists InfoTable(id integer primary key autoincrement,PhoneNumber text,NickName text,PassWord text,HeadImage bolb,Age text,Gender text,Email text,UserID text,HeadImagePath text,LoginStatus integer,Token text)";
        BOOL success = [_objectsDataBase executeUpdate:createTableSql];
        if (success) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
        
//        BOOL success2 = [_objectsDataBase executeUpdate:@"DROP TABLE InfoTable"];
//        if (success2) {
//            NSLog(@"shanchu表成功");
//        }
        
    } else {
        NSLog(@"打开失败");
    }
}
- (void)insert {
    if ([_objectsDataBase open]) {
        NSString *insertSQL = @"insert into InfoTable (id) values (?)";
        BOOL success = [_objectsDataBase executeUpdate:insertSQL, @1];
        if (success) {
//            NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
        [_objectsDataBase close];
    }
}
- (void)deleteAll {
    if ([_objectsDataBase open]) {
        NSString *deleteSQL = @"delete from InfoTable where 1";
        BOOL success = [_objectsDataBase executeUpdate:deleteSQL];
        if (success) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
        [_objectsDataBase close];
    }
}
#pragma mark - 判断是否登陆
- (BOOL)isLoggedIn {
    if (_loginStatus) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 读出数据
- (void)select {
    if ([_objectsDataBase open]) {
        NSString *selectSQL = @"select * from InfoTable where id = 1";
        FMResultSet *set = [_objectsDataBase executeQuery:selectSQL];
        if (infoModel) {
            while ([set next]) {
                _phoneNumber = [set stringForColumn:@"PhoneNumber"];
                _nickName = [set stringForColumn:@"NickName"];
                _passWord = [set stringForColumn:@"PassWord"];
                _imageData = [set dataForColumn:@"HeadImage"];
                _loginStatus = [set intForColumn:@"LoginStatus"];
                _age = [set stringForColumn:@"Age"];
                _gender = [set stringForColumn:@"Gender"];
                _email = [set stringForColumn:@"Email"];
                _token = [set stringForColumn:@"Token"];
                _userID = [set stringForColumn:@"UserID"];
                _headImagePath = [set stringForColumn:@"HeadImagePath"];
            }
//            NSLog(@"%@, %@, %@, %@, %@, %@", _phoneNumber, _nickName, _passWord, _age, _gender, _email);
            [_objectsDataBase close];
        }
    }
}


//- (void)logout {
//    if ([_objectsDataBase open]) {
//        NSString *updateSQL = @"update InfoTable set token=?, LoginStatus=? where id=1";
//        BOOL success = [_objectsDataBase executeUpdate:updateSQL, @"0", @1];
//        if (success) {
//            NSLog(@"登出成功");
//        } else {
//            NSLog(@"登出失败");
//        }
//        [_objectsDataBase close];
//    }
//}

@end
