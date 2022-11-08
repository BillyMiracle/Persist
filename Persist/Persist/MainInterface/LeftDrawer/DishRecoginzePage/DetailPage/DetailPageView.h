//
//  DetailPageView.h
//  Persist
//
//  Created by 张博添 on 2022/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailPageViewDelegate <NSObject>

- (void)pressFinish;

@end


@interface DetailPageView : UIView

@property (nonatomic, strong) UIImage *targetImage;

@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *calorieArray;

@property (nonatomic, strong) NSMutableArray *imageURLArray;
@property (nonatomic, strong) NSMutableArray *detailArray;

@property (nonatomic, assign) BOOL isDish;

@property (nonatomic, weak) id <DetailPageViewDelegate>delegate;

- (void)reloadTableView;

@end

NS_ASSUME_NONNULL_END
