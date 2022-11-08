//
//  DetailInfoCell.h
//  Persist
//
//  Created by 张博添 on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import <SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *calorieLabel;

@property (nonatomic, strong) UIImageView *infoImageView;
@property (nonatomic, strong) UILabel *detailLabel;

@end

NS_ASSUME_NONNULL_END
