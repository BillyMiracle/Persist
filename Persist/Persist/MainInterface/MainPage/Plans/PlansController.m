//
//  PlansController.m
//  Persist
//
//  Created by 张博添 on 2022/3/30.
//

#import "PlansController.h"
#import "PlansView.h"
#import "Manager.h"

@interface PlansController ()
<PlansViewDelegate>

@end

@implementation PlansController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PlansView *plansView = [[PlansView alloc] initWithFrame:self.view.frame];
    self.view = plansView;
    plansView.delegate = self;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmWithStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andTitle:(NSString *)title andRemark:(NSString *)remark andTimeType:(NSInteger)timeType andType:(NSInteger)typeNum {
    NSLog(@"%ld %ld", typeNum, timeType);
    if (timeType == 0) {
        [[Manager sharedManager] NetworkAddDailyTarget:title andRemark:remark andBeginTime:startDate andType:(int)typeNum addIsWholeDay:1 succeed:^(RunningDataModelFirst * _Nonnull dataModel){
            
            NSLog(@"succeeded");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNotification *noti = [NSNotification notificationWithName:@"newTarget" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:noti];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        } error:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        [[Manager sharedManager] NetworkAddTarget:title andRemark:remark andBeginTime:startDate andEndTime:endDate andType:(int)typeNum addIsWholeDay:0 succeed:^(RunningDataModelFirst * _Nonnull dataModel){
            
//            NSLog(@"succeeded");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNotification *noti = [NSNotification notificationWithName:@"newTarget" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:noti];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        } error:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

@end
