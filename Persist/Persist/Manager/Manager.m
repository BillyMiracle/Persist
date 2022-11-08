//
//  Manager.m
//  Persist
//
//  Created by 张博添 on 2022/2/18.
//

#import "Manager.h"
#import "AFNetworking.h"
#import "LoginOrRegisterModel.h"

static Manager *manager = nil;

@implementation Manager

//注册
//http://39.105.117.193/register/addInfo?password=123456&userName=ZBT&age=100&gender=男&email=510986792@qq.com&phone=13654998899

//登陆
//http://39.105.117.193/login/byPassword?phone=13654998899&password=123456

+ (instancetype)sharedManager {
    if(!manager) {
        //dispatch_ once _t: 使用 dispatch_once 方法能保证某段代码在程序运行过程中只被执行 1 次，并且即使在多线程的环境下，dispatch _once也可以保证线程安全。 ，用在这里就是只创建一次manger，不会创建不同的manger
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [Manager new];
        });
    }
    return manager;
}

#pragma mark 验证token
- (void)NetworkTestTokenWithToken:(NSString *)token finished:(validSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *testURL = @"http://39.105.117.193/test";
    testURL = [testURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:testURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            TokenValidModel *model = [[TokenValidModel alloc] initWithData:data error:nil];
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
    
}

#pragma mark 注册
- (void)NetworkRegisterWithData:(NSDictionary *)infoDictionary finished:(registerSucceedBlock)succeedBlock error:(errorBlock) errorBlock {
    
    NSString *phoneNumber = [infoDictionary valueForKey:@"phoneNumber"];
    NSString *password = [infoDictionary valueForKey:@"password"];
    NSString *userName = [infoDictionary valueForKey:@"userName"];
    int age = [[infoDictionary valueForKey:@"age"] intValue];
    NSString *gender = [infoDictionary valueForKey:@"gender"];
    NSString *email = [infoDictionary valueForKey:@"email"];
    
    NSString *registerURL = [NSString stringWithFormat:@"http://39.105.117.193/register/addInfo?phone=%@&password=%@&userName=%@&age=%d&gender=%@&email=%@", phoneNumber, password, userName, age, gender, email];
    registerURL = [registerURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"registerURL = %@", registerURL);
    
    NSURL *Url = [NSURL URLWithString:registerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NetworkLinkedLoginModel *model = [[NetworkLinkedLoginModel alloc] initWithData:data error:nil];
            succeedBlock(model);
            
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}


#pragma mark 登陆
- (void)NetworkLoginWithData:(NSDictionary *)infoDictionary finished:(loginSucceedBlock)succeedBlock error:(errorBlock) errorBlock {
    
    NSString *phoneNumber = [infoDictionary valueForKey:@"phoneNumber"];
    NSString *password = [infoDictionary valueForKey:@"password"];
    
    NSString *loginURL = [NSString stringWithFormat: @"http://39.105.117.193/login/byPassword?phone=%@&password=%@", phoneNumber, password];
    loginURL = [loginURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:loginURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSDictionary *allHeaderFields = res.allHeaderFields;
            
//            if ([allHeaderFields.allKeys containsObject:@"token"]) {
//                NSString *token = [allHeaderFields objectForKey:@"token"];
//                //fileLength = [lengthObj integerValue];
//                NSLog(@"token = %@", token);
//            }
//            NSLog(@"allHeaderFields is %@", allHeaderFields);
            NetworkLinkedLoginModel *model = [[NetworkLinkedLoginModel alloc] initWithData:data error:nil];
            NSString *token = [allHeaderFields objectForKey:@"token"];
            succeedBlock(model, token);
            //返回model数据和token
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
    
}

#pragma mark 上传头像
- (void)NetworkUpLoadHeadImageWithImage:(UIImage *)image andUserID:(NSString *)userID finished:(uploadHeadImageSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSData *imageData;
    NSString *mimetype;
    //判断下图片是什么格式
    if (UIImagePNGRepresentation(image) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(image);
    } else {
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    NSInteger length = [imageData length] / 1000;
    NSLog(@"image-kb:%ld kb,image-M:%ld M", length, length / 1024);
    
    NSString *urlString = [NSString stringWithFormat:@"http://39.105.117.193/register/user/upLoadHead?uid=%@", userID];
//    NSDictionary *params = @{@"token":@"220"};
    NSDictionary *params = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *str = @"file";
        NSString *fileName = [[NSString alloc] init];
        if (UIImagePNGRepresentation(image) != nil) {
            fileName = [NSString stringWithFormat:@"%@.png", str];
        } else {
            fileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        // 上传图片，以文件流的格式
        /*
        *filedata : 图片的data
        *name     : 后台的提供的字段
        *mimeType : 类型
        */
        [formData appendPartWithFileData:imageData name:str fileName:fileName mimeType:mimetype];
        
    } progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //打印看下返回的是什么东西
        NSDictionary *dict = responseObject;
//        NSLog(@"上传凭证成功:%@", [dict valueForKey:@"message"]);
        NSString *path = [dict valueForKey:@"msg"];
//        NSLog(@"%@", responseObject);
        succeedBlock(path);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片失败，失败原因是:%@", error);
    }];
}

#pragma mark - 更新头像
- (void)NetworkUpdateHeadImageWithImage:(UIImage *)image andUserID:(NSString *)userID finished:(updateHeadImageSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSData *imageData;
    NSString *mimetype;
    //判断下图片是什么格式
    if (UIImagePNGRepresentation(image) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(image);
    } else {
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    NSInteger length = [imageData length] / 1000;
    NSLog(@"image-kb:%ld kb,image-M:%ld M", length, length / 1024);
    
    NSString *urlString = [NSString stringWithFormat:@"http://39.105.117.193/user/updateHead?uid=%@", userID];
//    NSDictionary *params = @{@"token":@"220"};
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    NSLog(@"%@", token);
    NSDictionary *params = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *str = @"file";
        NSString *fileName = [[NSString alloc] init];
        if (UIImagePNGRepresentation(image) != nil) {
            fileName = [NSString stringWithFormat:@"%@.png", str];
        } else {
            fileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        // 上传图片，以文件流的格式
        /*
        *filedata : 图片的data
        *name     : 后台的提供的字段
        *mimeType : 类型
        */
        [formData appendPartWithFileData:imageData name:str fileName:fileName mimeType:mimetype];
        
    } progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //打印看下返回的是什么东西
        NSDictionary *dict = responseObject;
//        NSLog(@"上传凭证成功:%@", [dict valueForKey:@"message"]);
        NSString *path = [dict valueForKey:@"msg"];
//        NSLog(@"%@", responseObject);
        succeedBlock(path);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片失败，失败原因是:%@", error);
    }];
}


#pragma mark - 获取天气
- (void)NetworkGetWeatherFinished:(weatherSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *stringFirst = [NSString stringWithFormat:@"https://tianqiapi.com/api?version=v1&appid=28845343&appsecret=zPNqw1IO"];
    stringFirst = [stringFirst stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlFirst = [NSURL URLWithString:stringFirst];
    NSURLRequest *requestFirst = [NSURLRequest requestWithURL:urlFirst];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestFirst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *allDataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSArray *dataArray = [allDataDict objectForKey:@"data"];
            NSDictionary *dataDict = [dataArray objectAtIndex:0];
            NSDictionary *finalDataDict = @{@"temp":[dataDict objectForKey:@"tem"], @"weatherImg":[dataDict objectForKey:@"wea_img"], @"airLevel":[dataDict objectForKey:@"air_level"]};
//            NSLog(@"%@", finalDataDict);
            succeedBlock(finalDataDict);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

#pragma mark - 发送验证码
- (void)NetworkSendVerificationCodeWithPhoneNumber:(NSString *)phone finished:(VerificationCodeSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *registerURL = [NSString stringWithFormat:@"http://39.105.117.193/register/codeSend?phone=%@", phone];
    registerURL = [registerURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"registerURL = %@", registerURL);
    
    NSURL *Url = [NSURL URLWithString:registerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NetworkLinkedLoginModel *model = [[NetworkLinkedLoginModel alloc] initWithData:data error:nil];
            succeedBlock(model, nil);
            
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

#pragma mark - 电话验证码登录
- (void)NetworkLoginWithPhone:(NSString *)phone andVerificationCode:(NSString *)code finished:(VerificationCodeSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *registerURL = [NSString stringWithFormat:@"http://39.105.117.193/login/byCode?phone=%@&code=%@", phone, code];
    registerURL = [registerURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"registerURL = %@", registerURL);
    
    NSURL *Url = [NSURL URLWithString:registerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSDictionary *allHeaderFields = res.allHeaderFields;
            NSString *token = [allHeaderFields objectForKey:@"token"];
            
            NetworkLinkedLoginModel *model = [[NetworkLinkedLoginModel alloc] initWithData:data error:nil];
            succeedBlock(model, token);
            
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}
#pragma mark 下载头像
- (void)NetworkDownloadHeadImageWithURL:(NSString *)URL Finished:(DownloadHeadImageBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *registerURL = [NSString stringWithFormat:@"https://presist.oss-cn-beijing.aliyuncs.com/%@", URL];
    registerURL = [registerURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@", registerURL);
    NSURL *Url = [NSURL URLWithString:registerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

//        NSLog(@"%@", data);
        if (error == nil) {
            succeedBlock(data);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView
}

#pragma mark - 更改用户名
- (void)NetworkChangeUserName:(NSString *)name finished:(updateInfoBlock)succeedBlock error:(errorBlock)error {
    
    NSString *testURL = @"";
    testURL = [testURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:testURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    [request setValue:[[LoginOrRegisterModel sharedModel] token] forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            TokenValidModel *model = [[TokenValidModel alloc] initWithData:data error:nil];
            succeedBlock([model msg]);
        } else {
//            errorBlock(error);
        }
    }];
    [dataTask resume];
    
}

#pragma mark - 更改年龄
- (void)NetworkChangeAge:(NSString *)name finished:(updateInfoBlock)succeedBlock error:(errorBlock)error {
    
    
    
}

#pragma mark - 获取某天运动时长
- (void)NetworkGetSumRunningTime:(NSString *)time finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *testURL = [NSString stringWithFormat:@"http://39.105.117.193/run/getPlanDaySumTime?uid=%@&day=%@", [[LoginOrRegisterModel sharedModel] userID], time];
    testURL = [testURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:testURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            RunningDataModelFirst *model = [[RunningDataModelFirst alloc] initWithData:data error:nil];
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

#pragma mark - 获取一共运动距离
- (void)NetworkGetSumRunningDistanceFinished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/run/getRunSumDistance?uid=%@", [[LoginOrRegisterModel sharedModel] userID]];
//    NSLog(@"%@", [[LoginOrRegisterModel sharedModel] token]);
//    NSLog(@"%@", myURL);
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            RunningDataModelFirst *model = [[RunningDataModelFirst alloc] initWithData:data error:nil];
            if (model.status) {
                NSError *myError = [[NSError alloc] init];
                errorBlock(myError);
            }
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

#pragma mark - 获取某天运动时间
- (void)NetworkGetDaySumTimeAt:(NSString *)day finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/run/getPlanDaySumTime?uid=%@&day=%@", [[LoginOrRegisterModel sharedModel] userID], day];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            RunningDataModelFirst *model = [[RunningDataModelFirst alloc] initWithData:data error:nil];
            if (model.status) {
                NSError *myError = [[NSError alloc] init];
                errorBlock(myError);
            }
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

#pragma mark - 上传跑步记录
- (void)NetworkUpdateRunRecordWithDate:(NSString *)date andTime:(NSString *)time andDistance:(NSString *)distance finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/run/addRunRecord?uid=%@&runWhen=%@&runTime=%@&distance=%@", [[LoginOrRegisterModel sharedModel] userID], date, time, distance];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            RunningDataModelFirst *model = [[RunningDataModelFirst alloc] initWithData:data error:nil];
            if (model.status) {
                NSError *myError = [[NSError alloc] init];
                errorBlock(myError);
            }
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
    
}

#pragma mark - 获取某天的跑步记录
- (void)NetworkGetRunHistoryAt:(NSString *)date finished:(getRunningDataSecondBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/run/getPlanRunRecord?uid=%@&day=%@", [[LoginOrRegisterModel sharedModel] userID], date];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            RunningModelSecond *model = [[RunningModelSecond alloc] initWithData:data error:nil];
            if (model.status) {
                NSError *myError = [[NSError alloc] init];
                errorBlock(myError);
            }
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
    
}
#pragma mark - 获取全部跑步记录
- (void)NetworkGetAllRunHistoryFinished:(getRunningDataSecondBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/run/queryRunRecordsByUid?uid=%@", [[LoginOrRegisterModel sharedModel] userID]];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            RunningModelSecond *model = [[RunningModelSecond alloc] initWithData:data error:nil];
            if (model.status) {
                NSError *myError = [[NSError alloc] init];
                errorBlock(myError);
            }
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}


#pragma mark - 获取某天的跑步目标
- (void)NetworkGetRunTargetAt:(NSString *)date finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/run/getPlanTarget?uid=%@&day=%@", [[LoginOrRegisterModel sharedModel] userID], date];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            RunningDataModelFirst *model = [[RunningDataModelFirst alloc] initWithData:data error:nil];
            if (model.status) {
                NSError *myError = [[NSError alloc] init];
                errorBlock(myError);
            }
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

#pragma mark - 更新某日的目标
- (void)NetworkUpdateRunTargetAt:(NSString *)day andTarget:(NSString *)target finished:(getRunningDataFirstBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/run/updatePlanTarget?uid=%@&day=%@&target=%@", [[LoginOrRegisterModel sharedModel] userID], day, target];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            RunningDataModelFirst *model = [[RunningDataModelFirst alloc] initWithData:data error:nil];
            if (model.status) {
                NSError *myError = [[NSError alloc] init];
                errorBlock(myError);
            }
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
    
}

#pragma mark 更新密码
- (void)NetworkUpdatePassword:(NSString *)newPassword finished:(validSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
}

#pragma mark 菜品识别
- (void)NetworkDishRecognize:(NSString *)image64 finished:(recognizeSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *myURL = [NSString stringWithFormat:@"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=E3hXRYakXxeErrVvYC7a0rdd&client_secret=VmwjnYnTUmF6hrMyBaj0smBMK3GhNR1A"];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *token = [dict objectForKey:@"access_token"];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSDictionary *paramDict = @{@"access_token":token, @"image":image64, @"baike_num":@5};
            [manager POST:@"https://aip.baidubce.com/rest/2.0/image-classify/v2/dish" parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                NSDictionary *dict = responseObject;
//                NSLog(@"%@", dict);
                succeedBlock(dict);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"失败，失败原因是:%@", error);
                errorBlock(error);
            }];
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

#pragma mark 果蔬识别
- (void)NetworkVegetableRecognize:(NSString *)image64 finished:(recognizeSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *myURL = [NSString stringWithFormat:@"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=E3hXRYakXxeErrVvYC7a0rdd&client_secret=VmwjnYnTUmF6hrMyBaj0smBMK3GhNR1A"];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *token = [dict objectForKey:@"access_token"];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSDictionary *paramDict = @{@"access_token":token, @"image":image64, @"baike_num":@5};
            [manager POST:@"https://aip.baidubce.com/rest/2.0/image-classify/v1/classify/ingredient" parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                NSDictionary *dict = responseObject;
//                NSLog(@"%@", dict);
                succeedBlock(dict);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"失败，失败原因是:%@", error);
                errorBlock(error);
            }];
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

- (void)NetworkAddDailyTarget:(NSString *)headLine andRemark:(NSString *)remark andBeginTime:(NSString *)beginTime andType:(int)typeNum addIsWholeDay:(int)isWholeDay succeed:(uploadTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/target/addDailyTarget?uid=%@&type=%d&wholeDay=%d&headLine=%@&remark=%@&done=false&beganTime=%@", [[LoginOrRegisterModel sharedModel] userID], typeNum, isWholeDay, headLine, remark, beginTime];
    NSLog(@"%@", myURL);
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            RunningDataModelFirst *model = [[RunningDataModelFirst alloc] initWithData:data error:nil];
            succeedBlock(model);
            
        } else {
            
        }
    }];
    [dataTask resume];
}

- (void)NetworkGetDailyTargetListWithDay:(NSString *)day succeed:(getTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/target/getDailyTargetList?uid=%@&day=%@", [[LoginOrRegisterModel sharedModel] userID], day];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            TargetModel *model = [[TargetModel alloc] initWithData:data error:nil];
            
            succeedBlock(model);
            
        } else {
            
        }
    }];
    [dataTask resume];
}

- (void)NetworkAddTarget:(NSString *)headLine andRemark:(NSString *)remark andBeginTime:(NSString *)beginTime andEndTime:(NSString *)endTime andType:(int)typeNum addIsWholeDay:(int)isWholeDay succeed:(uploadTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/target/addTarget?uid=%@&type=%d&wholeDay=%d&headLine=%@&remark=%@&isDone=false&beganTime=%@&endTime=%@", [[LoginOrRegisterModel sharedModel] userID], typeNum, isWholeDay, headLine, remark, beginTime, endTime];
    NSLog(@"%@", myURL);
    
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            RunningDataModelFirst *model = [[RunningDataModelFirst alloc] initWithData:data error:nil];
            
            succeedBlock(model);
            
        } else {
            
        }
    }];
    [dataTask resume];
    
}

- (void)NetworkGetAllTargetInDay:(NSString *)day succeed:(getTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/target/isTargetInRange?uid=%@&day=%@", [[LoginOrRegisterModel sharedModel] userID], day];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            TargetModel *model = [[TargetModel alloc] initWithData:data error:nil];
            
            succeedBlock(model);
            
        } else {
            
        }
    }];
    [dataTask resume];
    
}

- (void)NetworkGetAllTargetsSucceed:(getTargetSucceedBlock)succeedBlock error:(errorBlock)error {
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/target/getTargetList?uid=%@", [[LoginOrRegisterModel sharedModel] userID]];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            TargetModel *model = [[TargetModel alloc] initWithData:data error:nil];
//            NSLog(@"%@", model);
            
            succeedBlock(model);
            
        } else {
            
        }
    }];
    [dataTask resume];
}

- (void)NetworkChangeTargetIsDoneWithTargetId:(NSString *)targetId finished:(getTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/target/changeIsDone?uid=%@&targetUid=%@", [[LoginOrRegisterModel sharedModel] userID], targetId];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            TargetModel *model = [[TargetModel alloc] initWithData:data error:nil];
            
            succeedBlock(model);
            
        } else {
            
        }
    }];
    [dataTask resume];
    
}

- (void)NetworkChangeDailyTargetIsDoneWithTargetId:(NSString *)targetId andDay:(NSString *)day finished:(getTargetSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/target/changeDailyIsDone?uid=%@&targetUid=%@&day=%@", [[LoginOrRegisterModel sharedModel] userID], targetId, day];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSString *token = [[LoginOrRegisterModel sharedModel] token];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            TargetModel *model = [[TargetModel alloc] initWithData:data error:nil];
            
            succeedBlock(model);
            
        } else {
            
        }
    }];
    [dataTask resume];
    
}

- (void)NetworkUploadCommunityWithContent:(NSString *)content andPicts:(NSArray *)pictArray finished:(addCommunitySucceedBlock)succeedBlock error:(errorBlock)errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[[LoginOrRegisterModel sharedModel] token] forHTTPHeaderField:@"token"];
//    NSString *urlString = [NSString stringWithFormat:@"http://39.105.117.193/community/addCommunity?uid=%@&headUrl=%@&userName=%@&content=%@", [[LoginOrRegisterModel sharedModel] userID], [NSString stringWithFormat:@"https://Persist.oss-cn-beijing.aliyuncs.com/%@", [[LoginOrRegisterModel sharedModel] headImagePath]], [[LoginOrRegisterModel sharedModel] nickName],content];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSDate *today = [NSDate date];
    NSString *todayString = [df stringFromDate:today];
    
    NSString *urlString = @"http://39.105.117.193/community/addCommunity";
    NSLog(@"%@", urlString);
    NSDictionary *param = @{@"uid":[[LoginOrRegisterModel sharedModel] userID], @"headUrl":[[LoginOrRegisterModel sharedModel] headImagePath], @"userName":[[LoginOrRegisterModel sharedModel] nickName], @"content":content, @"beganTime":todayString};
    [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage *image in pictArray) {
            
            NSData *imageData;
            NSString *mimetype;
            if (UIImagePNGRepresentation(image) != nil) {
                mimetype = @"image/png";
                imageData = UIImagePNGRepresentation(image);
            } else {
                mimetype = @"image/jpeg";
                imageData = UIImageJPEGRepresentation(image, 1.0);
            }
            NSString *str = @"pictures";
            NSString *fileName = [[NSString alloc] init];
            if (UIImagePNGRepresentation(image) != nil) {
                fileName = [NSString stringWithFormat:@"%@.png", str];
            } else {
                fileName = [NSString stringWithFormat:@"%@.jpg", str];
            }
            NSLog(@"%@", fileName);
            [formData appendPartWithFileData:imageData name:str fileName:fileName mimeType:mimetype];
        }
        
    } progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CommunityModel *model = [[CommunityModel alloc] init];
        succeedBlock(model);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"失败，失败原因是:%@", error);
        errorBlock(error);
    }];
    
}

- (void)NetworkGetCommunityFinished:(getCommunitySucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *myURL = [NSString stringWithFormat:@"http://39.105.117.193/community/queryCommunityList"];
    myURL = [myURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    [request setValue:[[LoginOrRegisterModel sharedModel] token] forHTTPHeaderField:@"token"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            CommunityModel *model = [[CommunityModel alloc] initWithData:data error:nil];
            succeedBlock(model);
            
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

@end
