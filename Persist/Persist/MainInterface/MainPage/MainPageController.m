//
//  MainPageController.m
//  Persist
//
//  Created by 张博添 on 2022/1/3.
//

#import "MainPageController.h"
#import "MainPageView.h"
#import "RunningPageController.h"
#import "DishRecognizeController.h"
#import "PlansController.h"

@interface MainPageController ()
<MainPageViewDelegate>

@property (nonatomic, strong) MainPageView *mainPageView;

@end

@implementation MainPageController

- (void)viewWillAppear:(BOOL)animated {
    
}

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
    // Do any additional setup after loading the view.
    _mainPageView = [[MainPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    self.navigationController.navigationBarHidden = YES;
    self.view = _mainPageView;
    _mainPageView.delegate = self;
}

- (void)openDrawerView {
    [self.delegate openTheDrawer];
}

- (void)pushToRunningPage {
    RunningPageController *runningPageController = [[RunningPageController alloc] init];
    runningPageController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:runningPageController animated:YES];
}
- (void)updateHeadImage {
    [_mainPageView updateHeadImage];
}

- (void)pushToFoodToolsPage {
    DishRecognizeController *dishRecognizeController = [[DishRecognizeController alloc] init];
    dishRecognizeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dishRecognizeController animated:YES];
}

- (void)presentPlanPage {
    PlansController *plansController = [[PlansController alloc] init];
    [self presentViewController:plansController animated:YES completion:nil];
}

@end
