//
//  DetailInfoCell.m
//  Persist
//
//  Created by 张博添 on 2022/3/24.
//

#import "DetailInfoCell.h"

@interface DetailInfoCell()

@end

@implementation DetailInfoCell

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
    
    _infoImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_infoImageView];
    
    
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    
    _calorieLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_calorieLabel];
    _calorieLabel.adjustsFontSizeToFitWidth = YES;
    
    _detailLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_detailLabel];
    _detailLabel.numberOfLines = 0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _nameLabel.frame = CGRectMake(20 + _infoImageView.frame.size.width, 10, self.frame.size.width - (30 + _infoImageView.frame.size.width), self.frame.size.width / 10);
    _calorieLabel.frame = CGRectMake(20 + _infoImageView.frame.size.width, 10 + self.frame.size.width / 10, self.frame.size.width - (30 + _infoImageView.frame.size.width), self.frame.size.width / 10);
    
    _detailLabel.frame = CGRectMake(10, 20 + _infoImageView.frame.size.height, self.frame.size.width - 20, 20);
    [_detailLabel sizeToFit];
}

@end
