//
//  DateCollectionViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/3/2.
//

#import "DateCollectionViewCell.h"

@implementation DateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 18)];
    _weekdayLabel.textColor = [UIColor grayColor];
    _weekdayLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_weekdayLabel];
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, frame.size.width, 36)];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.font = [UIFont systemFontOfSize:16];
    
    [self.contentView addSubview:_dayLabel];
    
    return self;
}

@end
