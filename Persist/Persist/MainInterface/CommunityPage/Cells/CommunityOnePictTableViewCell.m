//
//  CommunityOnePictTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/4/12.
//

#import "CommunityOnePictTableViewCell.h"
#import <Masonry.h>

@implementation CommunityOnePictTableViewCell

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
    
    _firstImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_firstImageView];
    
    
//    _firstImageView.contentMode = UIViewContentModeScaleAspectFill;
//    _firstImageView.clipsToBounds = YES;
    
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
        make.bottom.mas_equalTo(_firstImageView.mas_top).offset(-10);
    }];
    
    CGSize size = CGSizeMake(0, 0);
    
    if (_firstImageView.image && (_firstImageView.image.size.width >= _firstImageView.image.size.height)) {

        size = CGSizeMake(self.contentView.frame.size.width * 0.7, self.contentView.frame.size.width *0.7 / _firstImageView.image.size.width * _firstImageView.image.size.height);

    } else if (_firstImageView.image != nil && (_firstImageView.image.size.width < _firstImageView.image.size.height)) {

        size = CGSizeMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.width / 2 / _firstImageView.image.size.width * _firstImageView.image.size.height);

    }
//    NSLog(@"%lf %lf", size.width, size.height);
    
//    size = CGSizeMake(200, 400);
    if (size.width != 0 && size.height != 0) {
        [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(size.height);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    
}

@end
