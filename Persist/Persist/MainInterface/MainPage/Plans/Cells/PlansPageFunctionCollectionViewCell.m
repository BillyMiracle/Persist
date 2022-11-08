//
//  PlansPageFunctionCollectionViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/4/1.
//

#import "PlansPageFunctionCollectionViewCell.h"

@implementation PlansPageFunctionCollectionViewCell

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
    
    _selectedIconView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 0.8, 0, frame.size.height * 0.2, frame.size.height * 0.2)];
    _selectedIconView.image = [UIImage imageNamed:@"selected.png"];
    [self.contentView addSubview:_selectedIconView];
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _coverView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.contentView addSubview:_coverView];
    
    return self;
}

@end
