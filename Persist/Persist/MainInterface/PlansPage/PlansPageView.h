//
//  PlansView.h
//  Persist
//
//  Created by 张博添 on 2022/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@class CircleView;

@protocol PlansPageViewDelegate <NSObject>

- (void)openDrawerView;
- (void)presentChangeTargetPage;

@end

@interface PlansPageView : UIView

@property (nonatomic, weak) id<PlansPageViewDelegate>delegate;

@property (nonatomic, copy) NSString *originalTarget;
@property (nonatomic, copy) NSString *dateString;

- (void)updateHeadImage;
- (void)networkGetData;
- (void)updateDate;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
