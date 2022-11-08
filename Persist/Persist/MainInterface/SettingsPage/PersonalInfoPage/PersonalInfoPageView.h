//
//  PersonalInfoPageView.h
//  Persist
//
//  Created by 张博添 on 2022/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PersonalInfoPageViewDelegate <NSObject>

- (void)pressBack;
- (void)changeHeadImage;
- (void)changeName;
- (void)changeGender;
- (void)changeAge;

@end

@interface PersonalInfoPageView : UIView

@property (nonatomic, weak) id<PersonalInfoPageViewDelegate>delegate;
- (void)reload;
@end

NS_ASSUME_NONNULL_END
