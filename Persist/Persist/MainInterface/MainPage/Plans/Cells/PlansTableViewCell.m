//
//  PlansTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/3/29.
//

#import "PlansTableViewCell.h"

@interface PlansTableViewCell()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *labelView;

@end

@implementation PlansTableViewCell

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
    
    _baseView = [[UIView alloc] init];
    _baseView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_baseView];
    
    _labelView = [[UIView alloc] init];
    _labelView.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:_labelView];
    
//    _iconView = [[UIImageView alloc] init];
//    [_baseView addSubview:_iconView];
    
    _iconButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_iconButton addTarget:self action:@selector(pressIconButton) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_iconButton];
    
    _titleLabel = [[UILabel alloc] init];
    [_labelView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    [_labelView addSubview:_detailLabel];
    _detailLabel.textColor = [UIColor grayColor];
    
    _timeLabel = [[UILabel alloc] init];
    [_labelView addSubview:_timeLabel];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _baseView.frame = CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10);
//    _baseView.backgroundColor = [UIColor colorWithRed:0.95 green:0.99 blue:0.95 alpha:1];
//    _baseView.layer.masksToBounds = YES;
//    _baseView.layer.cornerRadius = 5;
    
    _labelView.frame = CGRectMake(_baseView.bounds.size.height, 0, _baseView.bounds.size.width - _baseView.bounds.size.height, _baseView.bounds.size.height);
    _labelView.layer.masksToBounds = YES;
    _labelView.layer.cornerRadius = 5;
    _labelView.backgroundColor = [UIColor colorWithRed:0.93 green:0.99 blue:0.93 alpha:1];
    
//    _iconView.frame = CGRectMake(0, 0, _baseView.bounds.size.height, _baseView.bounds.size.height);
    _iconButton.frame = CGRectMake(0, 0, _baseView.bounds.size.height, _baseView.bounds.size.height);
    
    
    _titleLabel.frame = CGRectMake(10, 0, _labelView.frame.size.width - 20 - 90, _labelView.frame.size.height * 2 / 3);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.font = [UIFont systemFontOfSize:16 / _titleLabel.font.lineHeight * (_titleLabel.frame.size.height * 0.7)];
    
    _detailLabel.frame = CGRectMake(10, _labelView.frame.size.height * 2 / 3, _titleLabel.frame.size.width, _labelView.frame.size.height / 3);
    _detailLabel.font = [UIFont systemFontOfSize:16];
    _detailLabel.font = [UIFont systemFontOfSize:16 / _detailLabel.font.lineHeight * (_detailLabel.frame.size.height * 0.7)];
    
    _timeLabel.frame = CGRectMake(_labelView.frame.size.width - 90, 0, 80, _labelView.frame.size.height);
    _timeLabel.font = _detailLabel.font;
    _timeLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)pressIconButton {
    [self.delegate pressIcon:self.tag];
}

@end
