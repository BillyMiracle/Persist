//
//  ChangeTargetPageController.m
//  Persist
//
//  Created by 张博添 on 2022/3/17.
//

#import "ChangeTargetPageController.h"
#import "ChangeTargetPageView.h"

@interface ChangeTargetPageController ()
<UIGestureRecognizerDelegate, ChangeTargetPageViewDelegate>

@property (nonatomic, strong) ChangeTargetPageView *changeTargetPageView;

@end

@implementation ChangeTargetPageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _changeTargetPageView = [[ChangeTargetPageView alloc] initWithFrame:self.view.frame];
    _changeTargetPageView.delegate = self;
    self.view = _changeTargetPageView;
    _changeTargetPageView.dateString = self.dateString;
    _changeTargetPageView.originalTarget = self.originalTarget;
    [_changeTargetPageView showData];
}

- (void)pressBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cautionShow {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"无效时间，请输入5～80的时间" message:nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateData {
    
}

@end
