//
//  BrandNewTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/4/12.
//

#import "BrandNewTableViewCell.h"

@interface BrandNewTableViewCell()

@property (nonatomic, strong) UIView *separaterLine;

@end

@implementation BrandNewTableViewCell

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    _headImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_headImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.numberOfLines = 1;
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _separaterLine = [[UIView alloc] init];
    _separaterLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_separaterLine];
    
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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)layoutSubviews {
    _headImage.frame = CGRectMake(10, 10, 30, 30);
    _nameLabel.frame = CGRectMake(50, 10, 100, 30);
    _separaterLine.frame = CGRectMake(5, self.bounds.size.height - 0.5, self.bounds.size.width - 10, 0.5);
    _contentLabel.frame = CGRectMake(10, 50, self.bounds.size.width - 20, 100);
    [_contentLabel sizeToFit];
//    NSLog(@"%lf", _contentLabel.frame.size.height);
    if (_number == 0) {
        
    } else if (_number == 1) {
        
    } else {
        _firstImageView.frame = CGRectMake(10, 60 + _contentLabel.bounds.size.height, (self.bounds.size.width - 42) / 3, (self.bounds.size.width - 42) / 3);
        _secondImageView.frame = CGRectMake(11 + (self.bounds.size.width - 42) / 3, 60 + _contentLabel.bounds.size.height, (self.bounds.size.width - 42) / 3, (self.bounds.size.width - 42) / 3);
        _thirdImageView.frame = CGRectMake(12 + (self.bounds.size.width - 42) * 2 / 3, 60 + _contentLabel.bounds.size.height, (self.bounds.size.width - 42) / 3, (self.bounds.size.width - 42) / 3);
    }
    
}

@end
