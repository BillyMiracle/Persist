//
//  CommunityPageView.h
//  Persist
//
//  Created by 张博添 on 2022/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommunityPageViewDelegate <NSObject>

- (void)openDrawerView;
- (void)addNewCommunity;


@end

@interface CommunityPageView : UIView

@property (nonatomic, weak) id<CommunityPageViewDelegate> delegate;

- (void)reloadAll;
- (void)updateHeadImage;

@end

NS_ASSUME_NONNULL_END
