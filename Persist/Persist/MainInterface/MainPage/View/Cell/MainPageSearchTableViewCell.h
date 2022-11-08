//
//  MainPageSearchTableViewCell.h
//  Persist
//
//  Created by 张博添 on 2022/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainPageSearchTableViewCell : UITableViewCell
<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
