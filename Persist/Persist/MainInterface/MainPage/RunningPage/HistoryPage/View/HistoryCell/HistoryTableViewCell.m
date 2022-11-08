//
//  HistoryTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/3/17.
//

#import "HistoryTableViewCell.h"

#define selfWidth self.frame.size.width
#define selfHeight self.frame.size.height

@interface HistoryTableViewCell() {
    CALayer *_layer;
}

@end

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _layer = [CALayer layer];
    _layer.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.99 alpha:1].CGColor;
    _layer.shadowColor = [UIColor blackColor].CGColor;
    _layer.shadowOffset = CGSizeMake(1, 1);
    _layer.shadowRadius = 1;
    _layer.shadowOpacity = 0.7;
    _layer.cornerRadius = 20;
    [self.contentView.layer addSublayer:_layer];
    
    _distanceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_distanceLabel];
    _distanceLabel.textAlignment = NSTextAlignmentLeft;
    _distanceLabel.adjustsFontSizeToFitWidth = YES;
    
    _runTimeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_runTimeLabel];
    _runTimeLabel.textAlignment = NSTextAlignmentRight;
    _runWhenLabel.adjustsFontSizeToFitWidth = YES;
    
    _runWhenLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_runWhenLabel];
    _runWhenLabel.textAlignment = NSTextAlignmentRight;
    _runWhenLabel.adjustsFontSizeToFitWidth = YES;
    _runWhenLabel.textColor = [UIColor grayColor];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _layer.frame = CGRectMake(2, 3, selfWidth - 4, selfHeight - 6);
    
    _distanceLabel.frame = CGRectMake(20, selfHeight * 0.2, selfWidth / 2 - 30, selfHeight * 0.5);
    _distanceLabel.font = [UIFont systemFontOfSize:16];
    _distanceLabel.font = [UIFont systemFontOfSize:(16 * (_distanceLabel.frame.size.height * 0.8) / (_distanceLabel.font.lineHeight))];
    
    _runTimeLabel.frame = CGRectMake(selfWidth / 2 + 10, selfHeight * 0.2, selfWidth / 2 - 30, selfHeight * 0.4);
    _runTimeLabel.font = [UIFont systemFontOfSize:16];
    _runTimeLabel.font = [UIFont systemFontOfSize:(16 * (_runTimeLabel.frame.size.height * 0.8) / (_runTimeLabel.font.lineHeight))];
    
    _runWhenLabel.frame = CGRectMake(selfWidth / 2 + 10, selfHeight * 0.65, selfWidth / 2 - 30, selfHeight * 0.3);
    _runWhenLabel.font = [UIFont systemFontOfSize:16];
    _runWhenLabel.font = [UIFont systemFontOfSize:(16 * (_runWhenLabel.frame.size.height * 0.6) / (_runWhenLabel.font.lineHeight))];
}

@end
