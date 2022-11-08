//
//  AccountAndSecurityView.h
//  Persist
//
//  Created by 张博添 on 2022/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AccountAndSecurityPageViewDelegate <NSObject>

- (void)pressBack;
- (void)pressLogout;

- (void)pressChangeEmail;
- (void)pressChangePassword;

@end

@interface AccountAndSecurityPageView : UIView

@property (nonatomic, weak) id<AccountAndSecurityPageViewDelegate>delegate;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
