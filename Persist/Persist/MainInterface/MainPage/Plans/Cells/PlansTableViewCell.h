//
//  PlansTableViewCell.h
//  Persist
//
//  Created by 张博添 on 2022/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PlansTableViewCellDelegate <NSObject>

- (void)pressIcon:(NSInteger)index;

@end

@interface PlansTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, weak) id <PlansTableViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
