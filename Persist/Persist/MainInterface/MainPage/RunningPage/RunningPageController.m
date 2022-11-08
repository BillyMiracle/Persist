//
//  RunningPageController.m
//  Persist
//
//  Created by 张博添 on 2022/2/20.
//

#import "RunningPageController.h"
#import "RunningPageView.h"
#import "TargetPageController.h"
#import "IndoorRunningPageController.h"
#import "OutdoorRunningPageController.h"
#import "HistoryPage/HistoryPageController.h"

@interface RunningPageController ()
<UIGestureRecognizerDelegate, RunningPageViewDelegate, TargetPageControllerDelegate>

@property (nonatomic, strong) RunningPageView *runningPageView;

@property (nonatomic, assign) NSInteger selectedTimeIndex;
@property (nonatomic, assign) NSInteger selectedLengthIndex;

@property (nonatomic, assign) NSInteger selectedTimeInSeconds;
@property (nonatomic, assign) float selectedLengthInKiloMeters;

@property (nonatomic, assign) BOOL targetEnabled;

@end

@implementation RunningPageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [_runningPageView networkGetDistance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _runningPageView = [[RunningPageView alloc] initWithFrame:self.view.frame];
    self.view = _runningPageView;
    _runningPageView.delegate = self;
    
}

- (void)goBackToMainPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentTargetPage {
    TargetPageController *targetPage = [[TargetPageController alloc] init];
    [self.navigationController pushViewController:targetPage animated:YES];
    targetPage.delegate = self;
    if (_targetEnabled) {
        [targetPage TPC_adjustTargetWithIndex:_selectedLengthIndex and:_selectedTimeIndex];
    }
}

- (void)getInfo:(NSDictionary *)infoDictionary {
    _selectedTimeIndex = [[infoDictionary valueForKey:@"selectedTimeIndex"] intValue];
    _selectedLengthIndex = [[infoDictionary valueForKey:@"selectedLengthIndex"] intValue];
    _selectedTimeInSeconds = [[infoDictionary valueForKey:@"selectedTimeInSeconds"] intValue];
    _selectedLengthInKiloMeters = [[infoDictionary valueForKey:@"selectedLengthInKiloMeters"] floatValue];
    _targetEnabled = YES;
    NSLog(@"%ld, %ld, %ld, %f", _selectedTimeIndex, _selectedLengthIndex, _selectedTimeInSeconds, _selectedLengthInKiloMeters);
}

- (void)presentIndoorRunningPage {
    IndoorRunningPageController *indoorRunningPage = [[IndoorRunningPageController alloc] init];
    indoorRunningPage.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:indoorRunningPage animated:YES completion:nil];
}

- (void)presentOutdoorRunningPage {
    OutdoorRunningPageController *outdoorRunningPage = [[OutdoorRunningPageController alloc] init];
    outdoorRunningPage.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:outdoorRunningPage animated:YES completion:nil];
    
//    TestViewController *test = [[TestViewController alloc] init];
//    test.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:test animated:YES completion:nil];
    
}

#pragma mark 显示跑步详情
- (void)presentDetailPage {
    HistoryPageController *historyPageController = [[HistoryPageController alloc] init];
    historyPageController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyPageController animated:YES];
}

@end
