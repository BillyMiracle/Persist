//
//  PlansPageFunctionCollectionViewCell.h
//  Persist
//
//  Created by 张博添 on 2022/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlansPageFunctionCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *selectedIconView;
@property (nonatomic, strong) UIView *coverView;

@end

NS_ASSUME_NONNULL_END
