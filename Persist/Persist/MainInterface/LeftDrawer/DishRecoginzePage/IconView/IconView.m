//
//  IconView.m
//  Persist
//
//  Created by 张博添 on 2022/3/24.
//

#import "IconView.h"

@implementation IconView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    //方块名称label
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(5, frame.size.height - _nameLabel.font.lineHeight - 5, frame.size.width - 10, _nameLabel.font.lineHeight);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    
    //方块图标imageView
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_nameLabel.font.lineHeight + 15) / 2, 5, frame.size.height - _nameLabel.font.lineHeight - 15, frame.size.height - _nameLabel.font.lineHeight - 15)];
    [self addSubview:_iconImageView];
    
    return self;
}

@end
