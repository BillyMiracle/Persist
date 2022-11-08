//
//  AccountPageTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/1/17.
//

#import "AccountPageTableViewCell.h"

#define selfWidth self.frame.size.width
#define selfHeight self.frame.size.height


static const float nameLabelFontSize = 16;

@interface AccountPageTableViewCell()

@property (assign, nonatomic, readonly) float statusBarHeight;

@end

@implementation AccountPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ([self.reuseIdentifier isEqualToString:@"First"]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor systemPurpleColor];
        self.backgroundColor = [UIColor systemPinkColor];
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
//        _nameLabel.font = [UIFont systemFontOfSize:nameLabelFontSize];
        _nameLabel.textColor = [UIColor whiteColor];
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:nameLabelFontSize];
        _subTitleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.text = @"个人主页 >";
        [self.contentView addSubview:_subTitleLabel];
        
        _genderLabel = [[UILabel alloc] init];
        _genderLabel.adjustsFontSizeToFitWidth = YES;
        _genderLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_genderLabel];
        
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.adjustsFontSizeToFitWidth = YES;
        _ageLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_ageLabel];
        
    } else if ([self.reuseIdentifier isEqualToString:@"Second"]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _nameLabel.frame = CGRectMake(10, (selfWidth / 2 + 50 + self.statusBarHeight) / 2 - selfWidth / 16, selfWidth - 100, selfWidth / 8);
    
    _genderLabel.frame = CGRectMake(10, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 20, selfWidth / 3, 40);
    _ageLabel.frame = CGRectMake(_genderLabel.frame.origin.x + _genderLabel.frame.size.width + 10, _genderLabel.frame.origin.y, selfWidth / 3, 40);
}

@end
