//
//  PlansController.m
//  Persist
//
//  Created by 张博添 on 2022/1/17.
//

#import "PlansPageController.h"
#import "PlansPageView.h"
#import "ChangeTargetPageController.h"

@interface PlansPageController ()
<PlansPageViewDelegate>

@property (nonatomic, strong) PlansPageView *plansPageView;

@end

@implementation PlansPageController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self updateHeadImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage) name:@"changeHeadImage" object:nil];
    
    _plansPageView = [[PlansPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    self.navigationController.navigationBarHidden = YES;
    self.view = _plansPageView;
    _plansPageView.delegate = self;
}

- (void)openDrawerView {
    [self.delegate openTheDrawer];
}

- (void)updateHeadImage {
    [_plansPageView updateHeadImage];
//    [_plansPageView networkGetData];
    [_plansPageView updateDate];
//    [_plansPageView reload];
}

- (void)presentChangeTargetPage {
    ChangeTargetPageController *changeTargetPage = [[ChangeTargetPageController alloc] init];
    changeTargetPage.hidesBottomBarWhenPushed = YES;
    changeTargetPage.originalTarget = self.plansPageView.originalTarget;
    changeTargetPage.dateString = self.plansPageView.dateString;
    [self.navigationController pushViewController:changeTargetPage animated:YES];
}


@end
