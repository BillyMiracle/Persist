//
//  IndoorRunningPageView.h
//  Persist
//
//  Created by 张博添 on 2022/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IndoorRunningPageDelegate <NSObject>

- (void)stopRunning;

@end


@interface IndoorRunningPageView : UIView

@property (nonatomic, assign) float totalDistance;
@property (nonatomic, assign) int totalSteps;
@property (nonatomic, assign) int time;

@property (nonatomic, weak) id <IndoorRunningPageDelegate>delegate;

- (void)startRunning;
- (void)buildTimer;

@end

NS_ASSUME_NONNULL_END
