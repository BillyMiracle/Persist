//
//  PlansView.h
//  Persist
//
//  Created by 张博添 on 2022/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PlansViewDelegate <NSObject>

- (void)cancel;
- (void)confirmWithStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andTitle:(NSString *)title andRemark:(NSString *)remark andTimeType:(NSInteger)timeType andType:(NSInteger)typeNum;

@end

@interface PlansView : UIView

@property (nonatomic, weak) id <PlansViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
