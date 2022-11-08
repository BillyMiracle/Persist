//
//  MainPageSearchTableViewCell.m
//  Persist
//
//  Created by 张博添 on 2022/2/19.
//

#import "MainPageSearchTableViewCell.h"
#import <Masonry.h>

@implementation MainPageSearchTableViewCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _searchBar = [[UISearchBar alloc] init];
    [self.contentView addSubview:_searchBar];
    _searchBar.placeholder = @"搜索想要的内容";

    _searchBar.delegate = self;
    return self;
}

- (void)layoutSubviews {
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self presentSearchPage];
    return NO;
}

- (void)presentSearchPage {
    NSLog(@"presentSearchPge");
}

/*
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"收键盘监听");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //searchText是searchBar上的文字 每次输入或删除都都会打印全部
}

//点击键盘上搜索时的相应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
*/

@end
