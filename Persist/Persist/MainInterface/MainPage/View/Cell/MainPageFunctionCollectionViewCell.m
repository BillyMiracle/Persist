//
//  MainPageFunctionCollectionViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/2/19.
//
#pragma mark 小方块功能cell

#import "MainPageFunctionCollectionViewCell.h"

@implementation MainPageFunctionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
//    self.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
    
    self.backgroundColor = [UIColor whiteColor];
    
    //方块名称label
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(5, frame.size.height - _nameLabel.font.lineHeight - 5, frame.size.width - 10, _nameLabel.font.lineHeight);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    //方块图标imageView
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_nameLabel.font.lineHeight + 15) / 2, 5, frame.size.height - _nameLabel.font.lineHeight - 15, frame.size.height - _nameLabel.font.lineHeight - 15)];
    [self.contentView addSubview:_iconImageView];
    
    return self;
}

@end
