//
//  CommunityNoPictTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/4/12.
//

#import "CommunityNoPictTableViewCell.h"
#import <Masonry.h>

@implementation CommunityNoPictTableViewCell

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
    
    _headImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_headImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.numberOfLines = 1;
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_equalTo(@30);
        make.height.mas_equalTo(@30);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImage.mas_right).offset(10);
        make.top.mas_equalTo(_headImage.mas_top);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@30);
    }];
        
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImage.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(_headImage.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

@end
