//
//  DetailPageController.m
//  Persist
//
//  Created by 张博添 on 2022/3/24.
//

#import "DetailPageController.h"


@interface DetailPageController ()
<DetailPageViewDelegate>

@end

@implementation DetailPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _detailPageView = [[DetailPageView alloc] initWithFrame:self.view.frame];
    self.view = _detailPageView;
    _detailPageView.delegate = self;
}

- (void)pressFinish {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentError {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"识别错误" message:@"未在图片中识别出对应物品" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
