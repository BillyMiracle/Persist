//
//  TargetPageController.m
//  Persist
//
//  Created by 张博添 on 2022/2/20.
//

#import "TargetPageController.h"
#import "TargetPageView.h"

@interface TargetPageController ()
<UIGestureRecognizerDelegate, TargetPageViewDelegate>

@property (nonatomic, strong) TargetPageView *targetPageView;

@end

@implementation TargetPageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (TargetPageView *)targetPageView {
    if (_targetPageView == nil) {
        _targetPageView = [[TargetPageView alloc] initWithFrame:self.view.frame];
        _targetPageView.delegate = self;
        self.view = _targetPageView;
    }
    return _targetPageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.targetPageView;
    
}

- (void)goBackToRunningPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmWithInfo:(NSDictionary *)dict {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate getInfo:dict];
}

- (void)TPC_adjustTargetWithIndex:(NSInteger)indexOne and:(NSInteger)indexTwo {
    [self.targetPageView TPV_adjustTargetWithIndex:indexOne and:indexTwo];
}

@end
