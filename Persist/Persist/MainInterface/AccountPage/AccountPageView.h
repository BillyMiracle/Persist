//
//  AccountPageView.h
//  Persist
//
//  Created by 张博添 on 2022/1/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AccountPageViewDelegate <NSObject>

- (void)skipToPersonalHomePage;
- (void)openDrawerView;

@end

@interface AccountPageView : UIView

@property (nonatomic, weak) id<AccountPageViewDelegate> delegate;

- (void)updateHeadImage;

@end

NS_ASSUME_NONNULL_END
