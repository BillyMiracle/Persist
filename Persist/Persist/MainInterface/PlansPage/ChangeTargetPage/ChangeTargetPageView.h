//
//  ChangeTargetPageView.h
//  Persist
//
//  Created by 张博添 on 2022/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChangeTargetPageViewDelegate <NSObject>

- (void)pressBack;

- (void)cautionShow;

- (void)updateData;

@end

@interface ChangeTargetPageView : UIView

@property (nonatomic, weak) id <ChangeTargetPageViewDelegate>delegate;

@property (nonatomic, copy) NSString *originalTarget;
@property (nonatomic, copy) NSString *dateString;

- (void)showData;

@end

NS_ASSUME_NONNULL_END
