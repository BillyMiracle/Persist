//
//  TargetPageView.h
//  Persist
//
//  Created by 张博添 on 2022/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TargetPageViewDelegate <NSObject>

- (void)goBackToRunningPage;
- (void)confirmWithInfo:(NSDictionary *)dict;

@end

@interface TargetPageView : UIView

@property (nonatomic, weak) id<TargetPageViewDelegate>delegate;

- (void)TPV_adjustTargetWithIndex:(NSInteger)indexOne and:(NSInteger)indexTwo;

@end

NS_ASSUME_NONNULL_END
