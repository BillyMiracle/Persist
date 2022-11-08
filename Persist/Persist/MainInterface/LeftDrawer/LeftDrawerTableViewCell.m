//
//  LeftDrawerTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/1/20.
//

#import "LeftDrawerTableViewCell.h"

@implementation LeftDrawerTableViewCell

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
    
    if ([reuseIdentifier isEqualToString:@"normal"]) {
        
//        self.backgroundColor = [UIColor lightGrayColor];
        
    } else {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    
    return self;
}

@end
