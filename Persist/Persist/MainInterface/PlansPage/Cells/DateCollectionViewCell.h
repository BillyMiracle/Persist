//
//  DateCollectionViewCell.h
//  Persist
//
//  Created by 张博添 on 2022/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *weekdayLabel;
@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UIView *selectedView;

@end

NS_ASSUME_NONNULL_END
