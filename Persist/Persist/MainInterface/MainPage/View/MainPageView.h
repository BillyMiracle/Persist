//
//  MainPageView.h
//  Persist
//
//  Created by 张博添 on 2022/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MainPageViewDelegate <NSObject>

- (void)openDrawerView;
- (void)pushToRunningPage;
- (void)pushToFoodToolsPage;
- (void)presentPlanPage;

@end

@interface MainPageView : UIView

@property (nonatomic, weak) id<MainPageViewDelegate>delegate;

- (void)updateHeadImage;

@end

NS_ASSUME_NONNULL_END
