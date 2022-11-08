//
//  DetailPageController.h
//  Persist
//
//  Created by 张博添 on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import "DetailPageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailPageController : UIViewController

@property (nonatomic, strong) DetailPageView *detailPageView;

- (void)presentError;

@end

NS_ASSUME_NONNULL_END
