//
//  HistoryPageController.m
//  Persist
//
//  Created by 张博添 on 2022/3/29.
//

#import "HistoryPageController.h"
#import "HistoryPageView.h"

@interface HistoryPageController ()
<UIGestureRecognizerDelegate, HistoryPageViewDelegate>



@end

@implementation HistoryPageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HistoryPageView *historyPageView = [[HistoryPageView alloc] initWithFrame:self.view.frame];
    self.view = historyPageView;
    historyPageView.delegate = self;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
