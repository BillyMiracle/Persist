//
//  OutdoorRunningPageView.h
//  Persist
//
//  Created by 张博添 on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OutdoorRunningPageViewDelegate <NSObject>

- (void)stopRunning;

@end

@interface OutdoorRunningPageView : UIView

@property (nonatomic, assign) float totalDistance;
@property (nonatomic, assign) int totalSteps;
@property (nonatomic, assign) NSTimeInterval totalTime;

@property (nonatomic, weak) id<OutdoorRunningPageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
