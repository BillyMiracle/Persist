//
//  LeftDrawerView.h
//  Persist
//
//  Created by 张博添 on 2022/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LeftDrawerViewDelegate <NSObject>

- (void)presentPersonalHomePage;
- (void)presentSettingsPage;
- (void)presentFoodToolsPage;

@end


@interface LeftDrawerView : UIView

@property (nonatomic, weak) id<LeftDrawerViewDelegate> delegate;

- (void)updateSteps;
- (void)updateHeadImage;
@end

NS_ASSUME_NONNULL_END
