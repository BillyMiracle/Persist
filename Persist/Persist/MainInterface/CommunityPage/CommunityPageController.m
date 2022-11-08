//
//  CommunityPageController.m
//  Persist
//
//  Created by 张博添 on 2022/1/17.
//

#import "CommunityPageController.h"
#import "CommunityPageView.h"
#import "AddCommunityPageController.h"

@interface CommunityPageController ()
<CommunityPageViewDelegate>

@property (nonatomic, strong) CommunityPageView *communityPageView;

@end

@implementation CommunityPageController

- (void)viewWillAppear:(BOOL)animated {
//
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self updateHeadImage];
    [_communityPageView reloadAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage) name:@"changeHeadImage" object:nil];
    // Do any additional setup after loading the view.
    _communityPageView = [[CommunityPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    self.navigationController.navigationBarHidden = YES;
    self.view = _communityPageView;
    _communityPageView.delegate = self;
}

- (void)openDrawerView {
    [self.delegate openTheDrawer];
}

- (void)updateHeadImage {
    [_communityPageView updateHeadImage];
}

- (void)addNewCommunity {
    
    AddCommunityPageController *addCommunityPageController = [[AddCommunityPageController alloc] init];
    addCommunityPageController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addCommunityPageController animated:YES];
    
}

@end
