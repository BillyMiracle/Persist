//
//  OutdoorRunningPageController.m
//  Persist
//
//  Created by 张博添 on 2022/2/28.
//

#import "OutdoorRunningPageController.h"
#import "OutdoorRunningPageView.h"
#import "Manager.h"

@interface OutdoorRunningPageController ()
<OutdoorRunningPageViewDelegate>
@property (nonatomic, strong) OutdoorRunningPageView *outdoorRunningPageView;

@end

@implementation OutdoorRunningPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _outdoorRunningPageView = [[OutdoorRunningPageView alloc] initWithFrame:self.view.frame];
    self.view = _outdoorRunningPageView;
    _outdoorRunningPageView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)stopRunning {
    
    NSLog(@"%f %f", _outdoorRunningPageView.totalDistance, _outdoorRunningPageView.totalTime);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //设置自定义的格式模版
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [df stringFromDate:today];
    float time = _outdoorRunningPageView.totalTime;
    [[Manager sharedManager] NetworkUpdateRunRecordWithDate:dateString andTime:[NSString stringWithFormat:@"%.1f", time / 60] andDistance:[NSString stringWithFormat:@"%.2f", _outdoorRunningPageView.totalDistance] finished:^(RunningDataModelFirst *model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
    } error:^(NSError *error) {
        
    }];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
