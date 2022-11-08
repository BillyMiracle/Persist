//
//  CommunityTableViewCell.h
//  Persist
//
//  Created by 张博添 on 2022/4/10.
//

#import <UIKit/UIKit.h>
#import <SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, assign) float cellWidth;

@end

NS_ASSUME_NONNULL_END
