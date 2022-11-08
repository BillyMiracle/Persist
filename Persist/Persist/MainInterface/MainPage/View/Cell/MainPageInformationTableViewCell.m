//
//  MainPageInformationTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/2/19.
//

#import "MainPageInformationTableViewCell.h"

@interface MainPageInformationTableViewCell()

@property (nonatomic, strong) UIView *titleView;
@end

@implementation MainPageInformationTableViewCell {
    CALayer *layer;
    UIView *backView;
    UILabel *titleLabel;
}

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
    
    self.backgroundColor = [UIColor yellowColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleView];
    
    layer = [CALayer layer];
    [_titleView.layer addSublayer:layer];
    
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [_titleView addSubview:backView];
    
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 18;
    backView.layer.borderWidth = 0.5;
    backView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"我的计划"];
    [backView addSubview:titleLabel];
    
    return self;
}

- (void)layoutSubviews {
    _titleView.frame = CGRectMake(0, 0, self.bounds.size.width, 40);
    
    
    layer.frame = CGRectMake(self.bounds.size.width * 0.25, 2, self.bounds.size.width *0.5, 36);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowRadius = 1;
    layer.shadowOpacity = 0.7;
    layer.cornerRadius = 18;

    backView.frame = CGRectMake(self.bounds.size.width * 0.25, 2, self.bounds.size.width *0.5, 36);
    titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width * 0.5, 36);
    
}

@end
