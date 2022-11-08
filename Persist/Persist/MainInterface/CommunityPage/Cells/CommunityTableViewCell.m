//
//  CommunityTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/4/10.
//

#import "CommunityTableViewCell.h"
#import <Masonry.h>

@implementation CommunityTableViewCell

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
    
    _secondImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_secondImageView];
    
    _thirdImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_thirdImageView];
    
    _firstImageView.contentMode = UIViewContentModeScaleAspectFill;
    _firstImageView.clipsToBounds = YES;
    
    _secondImageView.contentMode = UIViewContentModeScaleAspectFill;
    _secondImageView.clipsToBounds = YES;
    
    _thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
    _thirdImageView.clipsToBounds = YES;
    
    _imagesArray = [[NSMutableArray alloc] init];
    
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
    
    if (_imagesArray.count == 0) {
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImage.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(_headImage.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
    } else {
        /*
        if (_cellWidth) {
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_headImage.mas_left);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
                make.top.mas_equalTo(_headImage.mas_bottom).offset(5);
                make.bottom.mas_equalTo(_firstImageView.mas_top).offset(-10);
            }];
            
            [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.left.mas_equalTo(self.contentView.mas_left).offset(20);
    //            make.width.mas_equalTo((self.bounds.size.width - 42) / 3);
    //            make.height.mas_equalTo((self.bounds.size.width - 42) / 3);
                make.width.mas_equalTo((_cellWidth - 42) / 3);
                make.height.mas_equalTo((_cellWidth - 42) / 3);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            }];
            
            [_secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_firstImageView.mas_right).offset(1);
    //            make.width.mas_equalTo((self.bounds.size.width - 42) / 3);
    //            make.height.mas_equalTo((self.bounds.size.width - 42) / 3);
                make.width.mas_equalTo((_cellWidth - 42) / 3);
                make.height.mas_equalTo((_cellWidth - 42) / 3);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            }];
            
            [_thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_secondImageView.mas_right).offset(1);
    //            make.width.mas_equalTo((self.bounds.size.width - 42) / 3);
    //            make.height.mas_equalTo((self.bounds.size.width - 42) / 3);
                make.width.mas_equalTo((_cellWidth - 42) / 3);
                make.height.mas_equalTo((_cellWidth - 42) / 3);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        }*/
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImage.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(_headImage.mas_bottom).offset(5);
            make.bottom.mas_equalTo(_firstImageView.mas_top).offset(-10);
        }];
        
        [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.width.mas_equalTo((self.bounds.size.width - 42) / 3);
            make.height.mas_equalTo((self.bounds.size.width - 42) / 3);
//            make.width.mas_equalTo((_cellWidth - 42) / 3);
//            make.height.mas_equalTo((_cellWidth - 42) / 3);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        [_secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_firstImageView.mas_right).offset(1);
            make.width.mas_equalTo((self.bounds.size.width - 42) / 3);
            make.height.mas_equalTo((self.bounds.size.width - 42) / 3);
//            make.width.mas_equalTo((_cellWidth - 42) / 3);
//            make.height.mas_equalTo((_cellWidth - 42) / 3);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        [_thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_secondImageView.mas_right).offset(1);
            make.width.mas_equalTo((self.bounds.size.width - 42) / 3);
            make.height.mas_equalTo((self.bounds.size.width - 42) / 3);
//            make.width.mas_equalTo((_cellWidth - 42) / 3);
//            make.height.mas_equalTo((_cellWidth - 42) / 3);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
    }
//    NSLog(@"%lf", (self.bounds.size.width - 42) / 3);
    
}

@end
