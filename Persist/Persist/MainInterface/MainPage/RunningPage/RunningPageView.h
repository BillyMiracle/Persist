//
//  RunningPageView.h
//  Persist
//
//  Created by 张博添 on 2022/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RunningPageViewDelegate <NSObject>

- (void)presentTargetPage;
- (void)goBackToMainPage;
- (void)presentIndoorRunningPage;
- (void)presentOutdoorRunningPage;

- (void)presentDetailPage;

@end


@interface RunningPageView : UIView

@property (nonatomic, weak) id<RunningPageViewDelegate>delegate;

- (void)networkGetDistance;

@end

NS_ASSUME_NONNULL_END
