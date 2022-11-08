//
//  AccountPageTableViewCell.h
//  Persist
//
//  Created by 张博添 on 2022/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountPageTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *genderLabel;
@property (nonatomic, strong) UILabel *ageLabel;

@end

NS_ASSUME_NONNULL_END
