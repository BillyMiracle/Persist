//
//  IndoorRunningPageController.m
//  Persist
//
//  Created by 张博添 on 2022/2/22.
//

#import "IndoorRunningPageController.h"
#import "IndoorRunningPageView.h"
#import "Manager.h"

@interface IndoorRunningPageController ()
<IndoorRunningPageDelegate>

@property (nonatomic, strong) IndoorRunningPageView *indoorRunningPageView;

@end

@implementation IndoorRunningPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _indoorRunningPageView = [[IndoorRunningPageView alloc] initWithFrame:self.view.frame];
    self.view = _indoorRunningPageView;
    _indoorRunningPageView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_indoorRunningPageView startRunning];
    [_indoorRunningPageView buildTimer];
    
}

- (void)stopRunning {
    NSLog(@"%f %d %d", _indoorRunningPageView.totalDistance / 1000, _indoorRunningPageView.totalSteps, _indoorRunningPageView.time);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //设置自定义的格式模版
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [df stringFromDate:today];
    float time = _indoorRunningPageView.time;
    [[Manager sharedManager] NetworkUpdateRunRecordWithDate:dateString andTime:[NSString stringWithFormat:@"%.1f", time / 60] andDistance:[NSString stringWithFormat:@"%.2f", _indoorRunningPageView.totalDistance / 1000] finished:^(RunningDataModelFirst *model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
    } error:^(NSError *error) {
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
