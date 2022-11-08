//
//  CustomView.m
//  Persist
//
//  Created by 张博添 on 2022/1/17.
//

#import "CustomView.h"

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = frame.size.height / 20;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = frame.size.height / 5;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, frame.size.width - 30, (frame.size.height - 30) / 4)];
    [self addSubview:_titleLabel];
//    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.font = [UIFont systemFontOfSize:16 * _titleLabel.frame.size.height / (_titleLabel.font.lineHeight)];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + (frame.size.height - 30) / 4, frame.size.width - 30, (frame.size.height - 30) / 2)];
    [self addSubview:_detailLabel];
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    return self;
}

@end
