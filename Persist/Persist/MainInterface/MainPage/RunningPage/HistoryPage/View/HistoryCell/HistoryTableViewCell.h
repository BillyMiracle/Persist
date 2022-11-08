//
//  HistoryTableViewCell.h
//  Persist
//
//  Created by 张博添 on 2022/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *runWhenLabel;
@property (nonatomic, strong) UILabel *runTimeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

NS_ASSUME_NONNULL_END
