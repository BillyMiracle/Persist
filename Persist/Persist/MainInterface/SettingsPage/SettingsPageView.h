//
//  SettingsPageView.h
//  Persist
//
//  Created by 张博添 on 2022/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SettingsPageViewDelegate <NSObject>

- (void)pressBack;
- (void)pressPersonalInfoPage;
- (void)pressAccountAndSecurityPage;

@end

@interface SettingsPageView : UIView

@property (nonatomic, weak) id <SettingsPageViewDelegate>delegate;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
