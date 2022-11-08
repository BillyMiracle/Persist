//
//  CommunityOnePictTableViewCell.h
//  Persist
//
//  Created by 张博添 on 2022/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityOnePictTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *firstImageView;

@end

NS_ASSUME_NONNULL_END
